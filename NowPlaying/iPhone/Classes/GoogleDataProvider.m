// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GoogleDataProvider.h"

#import "Application.h"
#import "DateUtilities.h"
#import "FileUtilities.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "LookupResult.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlaying.pb.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface GoogleDataProvider()
@property (retain) NSCalendar* calendar;
@property (retain) NSDateComponents* dateComponents;
@end


@implementation GoogleDataProvider

@synthesize calendar;
@synthesize dateComponents;

- (void) dealloc {
    self.calendar = nil;
    self.dateComponents = nil;

    [super dealloc];
}


+ (GoogleDataProvider*) providerWithModel:(NowPlayingModel*) model {
    return [[[GoogleDataProvider alloc] initWithModel:model] autorelease];
}


- (NSDictionary*) processMovies:(NSArray*) movies {
    NSMutableDictionary* movieIdToMovieMap = [NSMutableDictionary dictionary];

    for (MovieProto* movieProto in movies) {
        NSString* identifier = movieProto.identifier;
        NSString* poster = @"";
        NSString* title = movieProto.title;
        NSString* rating = movieProto.rawRating;
        NSInteger length = movieProto.length;
        NSString* synopsis = movieProto.description;
        NSArray* genres =  [[movieProto.genre stringByReplacingOccurrencesOfString:@"_" withString:@" "] componentsSeparatedByString:@"/"];
        NSArray* directors = movieProto.directorList;
        NSArray* cast = movieProto.castList;
        NSString* releaseDateString = movieProto.releaseDate;
        NSDate* releaseDate = [DateUtilities parseIS08601Date:releaseDateString];

        NSString* imdbAddress = [NSString stringWithFormat:@"http://www.imdb.com/title/%@", movieProto.iMDbUrl];

        Movie* movie = [Movie movieWithIdentifier:identifier
                                            title:title
                                           rating:rating
                                           length:length
                                      releaseDate:releaseDate
                                      imdbAddress:imdbAddress
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


- (BOOL) hasTimeSuffix:(NSString*) time {
    return [time hasSuffix:@"am"] || [time hasSuffix:@"pm"];
}


- (BOOL) is24HourTime:(NSArray*) times {
    for (NSString* time in times) {
        if (time.length != 5 || [time rangeOfString:@":"].location != 2) {
            return NO;
        }
    }

    return YES;
}


- (BOOL) is12HourTime:(NSArray*) times {
    for (NSString* time in times) {
        if ([time rangeOfString:@":"].length == 0) {
            return NO;
        }
    }

    return YES;
}


- (NSArray*) process24HourTimes:(NSArray*) times {
    NSMutableArray* result = [NSMutableArray array];

    for (NSString* time in times) {
        NSInteger hour = [[time substringToIndex:2] intValue];
        NSInteger minute = [[time substringFromIndex:3] intValue];

        [dateComponents setHour:hour];
        [dateComponents setMinute:minute];

        NSDate* date = [calendar dateFromComponents:dateComponents];

        [result addObject:date];
    }

    return result;
}


- (NSDate*) processUnknownTime:(NSString*) showtime {
     if (![showtime hasSuffix:@"am"] && ![showtime hasSuffix:@"pm"]) {
         showtime = [NSString stringWithFormat:@"%@pm", showtime];
     }

    return [DateUtilities dateWithNaturalLanguageString:showtime];
}


- (NSArray*) process12HourTimes:(NSArray*) times {
    NSString* lastTime = [times lastObject];

    // walk backwards from the end.  switch the time when we see an AM/PM marker
    NSMutableArray* reverseArray = [NSMutableArray array];
    BOOL isPM = [lastTime hasSuffix:@"pm"];

    for (NSInteger i = times.count - 1; i >= 0; i--) {
        NSString* time = [times objectAtIndex:i];

        if ([self hasTimeSuffix:time]) {
            isPM = [time hasSuffix:@"pm"];

            // trim off the suffix
            time = [time substringToIndex:time.length - 2];
        }

        NSRange range = [time rangeOfString:@":"];

        NSInteger hour = [[time substringToIndex:range.location] intValue];
        NSInteger minute = [[time substringFromIndex:range.location + 1] intValue];

        if (isPM && hour < 12) {
            hour += 12;
        } else if (!isPM && hour == 12) {
            hour = 0;
        }

        [dateComponents setHour:hour];
        [dateComponents setMinute:minute];

        NSDate* date = [calendar dateFromComponents:dateComponents];

        [reverseArray addObject:date];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSInteger i = reverseArray.count - 1; i >= 0; i--) {
        [result addObject:[reverseArray objectAtIndex:i]];
    }

    return result;
}


- (NSArray*) processUnknownTimes:(NSArray*) times {
    NSMutableArray* result = [NSMutableArray array];
    for (NSString* time in times) {
        [result addObject:[self processUnknownTime:time]];
    }
    return result;
}


- (NSArray*) processTimes:(NSArray*) showtimes {
    if (showtimes.count == 0) {
        return [NSArray array];
    }

    NSMutableArray* times = [NSMutableArray array];
    for (ShowtimeProto* showtime in showtimes) {
        [times addObject:showtime.time];
    }

    if ([self is24HourTime:times]) {
        return [self process24HourTimes:times];
    } else if ([self is12HourTime:times] && [self hasTimeSuffix:times.lastObject]) {
        return [self process12HourTimes:times];
    } else {
        return [self processUnknownTimes:times];
    }
}


- (NSMutableDictionary*) processMovieAndShowtimesList:(NSArray*) movieAndShowtimesList
                                    movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* movieAndShowtimes in
         movieAndShowtimesList) {
        NSString* movieId = movieAndShowtimes.movieIdentifier;
        NSString* movieTitle = [[movieIdToMovieMap objectForKey:movieId] canonicalTitle];

        NSMutableArray* performances = [NSMutableArray array];
        
        NSArray* showtimes = movieAndShowtimes.showtimes.showtimesList;
        NSArray* times = [self processTimes:showtimes];

        for (NSInteger i = 0; i < showtimes.count; i++) {
            ShowtimeProto* showtime = [showtimes objectAtIndex:i];
            NSDate* time = [times objectAtIndex:i];

            NSString* url = showtime.url;

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


- (void) processTheaterAndMovieShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimes
                                theaters:(NSMutableArray*) theaters
                            performances:(NSMutableDictionary*) performances
              synchronizationInformation:(NSMutableDictionary*) synchronizationInformation
                     originatingLocation:(Location*) originatingLocation
                          filterTheaters:(NSArray*) filterTheaters
                       movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    TheaterProto* theater = theaterAndMovieShowtimes.theater;
    NSString* name = theater.name;
    if (name.length == 0) {
        return;
    }

    if (filterTheaters != nil && ![filterTheaters containsObject:name]) {
        return;
    }

    NSString* identifier = theater.identifier;
    NSString* address =    theater.streetAddress;
    NSString* city =       theater.city;
    NSString* state =      theater.state;
    NSString* postalCode = theater.postalCode;
    NSString* country =    theater.country;
    NSString* phone =      theater.phone;
    double latitude =      theater.latitude;
    double longitude =     theater.longitude;

    NSArray* movieAndShowtimesList = theaterAndMovieShowtimes.movieAndShowtimesList;

    NSMutableDictionary* movieToShowtimesMap = [self processMovieAndShowtimesList:movieAndShowtimesList
                                                                movieIdToMovieMap:movieIdToMovieMap];

    if (movieToShowtimesMap.count == 0) {
        return;
    }
    [synchronizationInformation setObject:[DateUtilities today] forKey:name];
    [performances setObject:movieToShowtimesMap forKey:name];

    Location* location = [Location locationWithLatitude:latitude
                                              longitude:longitude
                                                address:address
                                                   city:city
                                                  state:state
                                             postalCode:postalCode
                                                country:country];

    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                           phoneNumber:phone
                                              location:location
                                   originatingLocation:originatingLocation
                                           movieTitles:movieToShowtimesMap.allKeys]];
}


- (NSArray*) processTheaterAndMovieShowtimes:(NSArray*) theaterAndMovieShowtimes
                         originatingLocation:(Location*) originatingLocation
                              filterTheaters:(NSArray*) filterTheaters
                           movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];
    NSMutableDictionary* synchronizationInformation = [NSMutableDictionary dictionary];

    for (TheaterListingsProto_TheaterAndMovieShowtimesProto* proto in theaterAndMovieShowtimes) {
        [self processTheaterAndMovieShowtimes:proto
                                     theaters:theaters
                                 performances:performances
                   synchronizationInformation:synchronizationInformation
                          originatingLocation:originatingLocation
                               filterTheaters:filterTheaters
                            movieIdToMovieMap:movieIdToMovieMap];
    }

    return [NSArray arrayWithObjects:theaters, performances, synchronizationInformation, nil];
}


- (LookupResult*) processTheaterListings:(TheaterListingsProto*) element
                     originatingLocation:(Location*) originatingLocation
                            filterTheaters:(NSArray*) filterTheaters {
                                self.calendar = [NSCalendar currentCalendar];
                                self.dateComponents = [[[NSDateComponents alloc] init] autorelease];

    NSArray* movieProtos = element.moviesList;
    NSArray* theaterAndMovieShowtimes = element.theaterAndMovieShowtimesList;

    NSDictionary* movieIdToMovieMap = [self processMovies:movieProtos];

    NSArray* theatersAndPerformances = [self processTheaterAndMovieShowtimes:theaterAndMovieShowtimes
                                                         originatingLocation:originatingLocation
                                                                filterTheaters:filterTheaters
                                                           movieIdToMovieMap:movieIdToMovieMap];

    NSMutableArray* movies = [NSMutableArray arrayWithArray:movieIdToMovieMap.allValues];
    NSMutableArray* theaters = [theatersAndPerformances objectAtIndex:0];
    NSMutableDictionary* performances = [theatersAndPerformances objectAtIndex:1];
    NSMutableDictionary* synchronizationInformation = [theatersAndPerformances objectAtIndex:2];

    return [LookupResult resultWithMovies:movies
                                 theaters:theaters
                             performances:performances
               synchronizationInformation:synchronizationInformation];
}


- (LookupResult*) lookupLocation:(Location*) location
                    filterTheaters:(NSArray*) filterTheaters {
    if (location.postalCode == nil) {
        return nil;
    }

    NSString* country = location.country.length == 0 ? [LocaleUtilities isoCountry]
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
                         [LocaleUtilities isoLanguage],
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
                             filterTheaters:filterTheaters];

    }
    @catch (NSException * e) {
    }

    return nil;
}


- (NSString*) displayName {
    return @"Google";
}

@end