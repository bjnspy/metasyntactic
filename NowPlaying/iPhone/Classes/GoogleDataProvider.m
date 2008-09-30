// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "GoogleDataProvider.h"

#import "BoxOffice.pb.h"
#import "Application.h"
#import "DateUtilities.h"
#import "Location.h"
#import "LookupResult.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation GoogleDataProvider

- (void) dealloc {
    [super dealloc];
}


+ (GoogleDataProvider*) providerWithModel:(NowPlayingModel*) model {
    return [[[GoogleDataProvider alloc] initWithModel:model] autorelease];
}


- (NSString*) providerFolder {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Google"];
}


- (NSDictionary*) processMovies:(NSArray*) movies {
    NSMutableDictionary* movieIdToMovieMap = [NSMutableDictionary dictionary];

    for (MovieProto* movieProto in movies) {
        NSString* identifier = movieProto.getIdentifier;
        NSString* imdbId = movieProto.getIMDbUrl;
        NSString* poster = @"";
        NSString* title = movieProto.getTitle;
        NSString* rating = movieProto.getRawRating;
        NSInteger length = movieProto.getLength;
        NSString* synopsis = movieProto.getDescription;
        NSArray* genres =  [[movieProto.getGenre stringByReplacingOccurrencesOfString:@"_" withString:@" "] componentsSeparatedByString:@"/"];
        NSArray* directors = movieProto.getDirectorList;
        NSArray* cast = movieProto.getCastList;
        NSString* releaseDateString = movieProto.getReleaseDate;
        NSDate* releaseDate = nil;
        if (releaseDateString.length == 10) {
            NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
            components.year = [[releaseDateString substringWithRange:NSMakeRange(0, 4)] intValue];
            components.month = [[releaseDateString substringWithRange:NSMakeRange(5, 2)] intValue];
            components.day = [[releaseDateString substringWithRange:NSMakeRange(8, 2)] intValue];

            releaseDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        }

        Movie* movie = [Movie movieWithIdentifier:identifier
                                            title:title
                                           rating:rating
                                           length:length
                                      releaseDate:releaseDate
                                           imdbId:imdbId
                                           poster:poster
                                         synopsis:synopsis
                                           studio:@""
                                        directors:directors
                                             cast:cast
                                           genres:genres];

        [movieIdToMovieMap setObject:movie forKey:identifier];
    }

    return movieIdToMovieMap;
}


- (NSMutableDictionary*) processMovieAndShowtimesList:(NSArray*) movieAndShowtimesList
                                    movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (MovieAndShowtimesProto* movieAndShowtimes in movieAndShowtimesList) {
        NSString* movieId = movieAndShowtimes.getMovieIdentifier;
        NSString* movieTitle = [[movieIdToMovieMap objectForKey:movieId] canonicalTitle];

        NSMutableArray* performances = [NSMutableArray array];

        for (ShowtimeProto* showtime in movieAndShowtimes.getShowtimes.getShowtimesList) {
            NSString* time = showtime.getTime;
            NSString* url = showtime.getUrl;

            time = [Theater processShowtime:time];

            if ([url hasPrefix:@"m="]) {
                url = [NSString stringWithFormat:@"http://iphone.fandango.com/tms.asp?a=11586&%@", url];
            }

            Performance* performance = [Performance performanceWithTime:time
                                                                    url:url];

            [performances addObject:performance.dictionary];
        }

        [dictionary setObject:performances forKey:movieTitle];
    }

    return dictionary;
}


- (void) processTheaterAndMovieShowtimes:(TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimes
                                theaters:(NSMutableArray*) theaters
                            performances:(NSMutableDictionary*) performances
                     synchronizationData:(NSMutableDictionary*) synchronizationData
                     originatingLocation:(Location*) originatingLocation
                            theaterNames:(NSArray*) theaterNames
                       movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    TheaterProto* theater = theaterAndMovieShowtimes.getTheater;
    NSString* name = theater.getName;
    if (name.length == 0) {
        return;
    }

    if (theaterNames != nil && ![theaterNames containsObject:name]) {
        return;
    }

    NSString* identifier = theater.getIdentifier;
    NSString* address =    theater.getStreetAddress;
    NSString* city =       theater.getCity;
    NSString* state =      theater.getState;
    NSString* postalCode = theater.getPostalCode;
    NSString* country =    theater.getCountry;
    NSString* phone =      theater.getPhone;
    double latitude =      theater.getLatitude;
    double longitude =     theater.getLongitude;

    NSArray* movieAndShowtimesList = theaterAndMovieShowtimes.getMovieAndShowtimesList;
    
    NSMutableDictionary* movieToShowtimesMap = [self processMovieAndShowtimesList:movieAndShowtimesList
                                                                movieIdToMovieMap:movieIdToMovieMap];

    [synchronizationData setObject:[DateUtilities today] forKey:name];
    if (movieToShowtimesMap.count == 0) {
        // no showtime information available.  fallback to anything we've
        // stored (but warn the user).

        NSString* performancesFile = [self performancesFile:name];
        NSDictionary* oldPerformances = [NSDictionary dictionaryWithContentsOfFile:performancesFile];

        if (oldPerformances.count > 0) {
            movieToShowtimesMap = [NSMutableDictionary dictionaryWithDictionary:oldPerformances];
            [synchronizationData setObject:[self synchronizationDateForTheater:name] forKey:name];
        }
    }

    Location* location = [Location locationWithLatitude:latitude
                                              longitude:longitude
                                                address:address
                                                   city:city
                                                  state:state
                                             postalCode:postalCode
                                                country:country];

    [performances setObject:movieToShowtimesMap forKey:name];
    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                           phoneNumber:phone
                                              location:location
                                   originatingLocation:originatingLocation
                                           movieTitles:movieToShowtimesMap.allKeys]];
}


- (NSArray*) processTheaterAndMovieShowtimes:(NSArray*) theaterAndMovieShowtimes
                         originatingLocation:(Location*) originatingLocation
                                theaterNames:(NSArray*) theaterNames
                           movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];
    NSMutableDictionary* synchronizationData = [NSMutableDictionary dictionary];

    for (TheaterAndMovieShowtimesProto* proto in theaterAndMovieShowtimes) {
        [self processTheaterAndMovieShowtimes:proto
                                     theaters:theaters
                                 performances:performances
                          synchronizationData:synchronizationData
                          originatingLocation:originatingLocation
                                 theaterNames:theaterNames
                            movieIdToMovieMap:movieIdToMovieMap];
    }

    return [NSArray arrayWithObjects:theaters, performances, synchronizationData, nil];
}


- (LookupResult*) processTheaterListings:(TheaterListingsProto*) element
                     originatingLocation:(Location*) originatingLocation
                            theaterNames:(NSArray*) theaterNames {
    NSArray* movieProtos = element.getMoviesList;
    NSArray* theaterAndMovieShowtimes = element.getTheaterAndMovieShowtimesList;
//    NSArray* theaterElements = [element elements:@"Theater"];
    
    NSDictionary* movieIdToMovieMap = [self processMovies:movieProtos];
    
    NSArray* theatersAndPerformances = [self processTheaterAndMovieShowtimes:theaterAndMovieShowtimes
                                                         originatingLocation:originatingLocation
                                                                theaterNames:theaterNames
                                                           movieIdToMovieMap:movieIdToMovieMap];
    
    NSMutableArray* movies = [NSMutableArray arrayWithArray:movieIdToMovieMap.allValues];
    NSMutableArray* theaters = [theatersAndPerformances objectAtIndex:0];
    NSMutableDictionary* performances = [theatersAndPerformances objectAtIndex:1];
    NSMutableDictionary* synchronizationData = [theatersAndPerformances objectAtIndex:2];
    
    return [LookupResult resultWithMovies:movies
                                 theaters:theaters
                             performances:performances
                      synchronizationData:synchronizationData];
}


- (LookupResult*) lookupLocation:(Location*) location
                    theaterNames:(NSArray*) theaterNames {
    if (location.postalCode == nil) {
        return nil;
    }

    NSString* country = location.country.length == 0 ? [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
    : location.country;


    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                   fromDate:[DateUtilities today]
                                                                     toDate:self.model.searchDate
                                                                    options:0];
    NSInteger day = components.day;
    day = MIN(MAX(day, 0), 7);

    NSString* address = [NSString stringWithFormat:
                         @"http://%@.appspot.com/LookupTheaterListings2?country=%@&language=%@&postalcode=%@&day=%d&format=pb&latitude=%d&longitude=%d",
                         [Application host],
                         country,
                         [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                         [Utilities stringByAddingPercentEscapes:location.postalCode],
                         day,
                         (int)(location.latitude * 1000000),
                         (int)(location.longitude * 1000000)];

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:address
                                                     important:YES];
    if (data == nil) {
        return nil;
    }
    
    @try {
        TheaterListingsProto* theaterListings = [TheaterListingsProto parseFromData:data];
        
        return [self processTheaterListings:theaterListings
                        originatingLocation:location
                               theaterNames:theaterNames];
        
    }
    @catch (NSException * e) {
    }

    return nil;
}


- (NSString*) displayName {
    return @"Google";
}


@end