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

#import "NorthAmericaDataProvider.h"

#import "AddressLocationCache.h"
#import "Application.h"
#import "DateUtilities.h"
#import "Location.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation NorthAmericaDataProvider

@synthesize model;

- (void) dealloc {
    self.model = nil;

    [super dealloc];
}


+ (NorthAmericaDataProvider*) providerWithModel:(NowPlayingModel*) model {
    return [[[NorthAmericaDataProvider alloc] initWithModel:model] autorelease];
}


- (NSString*) providerFolder {
    return [[Application dataFolder] stringByAppendingPathComponent:@"NorthAmerica"];
}


- (NSMutableDictionary*) processFandangoShowtimes:(XmlElement*) moviesElement
                                movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in moviesElement.children) {
        NSString* movieId = [movieElement attributeValue:@"id"];
        NSString* movieTitle = [[movieIdToMovieMap objectForKey:movieId] canonicalTitle];

        XmlElement* performancesElement = [movieElement element:@"performances"];

        NSMutableArray* performances = [NSMutableArray array];

        for (XmlElement* performanceElement in performancesElement.children) {
            NSString* showId = [performanceElement attributeValue:@"showid"];
            if (![Utilities isNilOrEmpty:showId]) {
                showId = [NSString stringWithFormat:@"F-%@", showId];
            }

            NSString* time = [performanceElement attributeValue:@"showtime"];
            time = [Theater processShowtime:time];

            Performance* performance = [Performance performanceWithIdentifier:showId
                                                                         time:time];

            [performances addObject:performance.dictionary];
        }

        [dictionary setObject:performances forKey:movieTitle];
    }

    return dictionary;
}


- (void) processFandangoTheaterElement:(XmlElement*) theaterElement
                              theaters:(NSMutableArray*) theaters
                          performances:(NSMutableDictionary*) performances
                 originatingPostalCode:(NSString*) originatingPostalCode
                          theaterNames:(NSArray*) theaterNames
                     movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {

    NSString* name = [theaterElement element:@"name"].text;
    if (theaterNames != nil && ![theaterNames containsObject:name]) {
        return;
    }

    NSString* identifier = [theaterElement attributeValue:@"id"];
    NSString* sellsTickets = [theaterElement attributeValue:@"iswired"];
    NSString* address =    [theaterElement element:@"address1"].text;
    NSString* city =       [theaterElement element:@"city"].text;
    NSString* state =      [theaterElement element:@"state"].text;
    NSString* postalCode = [theaterElement element:@"postalcode"].text;
    NSString* phone =      [theaterElement element:@"phonenumber"].text;

    NSString* fullAddress;
    if ([address hasSuffix:@"."]) {
        fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, postalCode];
    } else {
        fullAddress = [NSString stringWithFormat:@"%@. %@, %@ %@", address, city, state, postalCode];
    }

    XmlElement* moviesElement = [theaterElement element:@"movies"];
    NSMutableDictionary* movieToShowtimesMap = [self processFandangoShowtimes:moviesElement
                                                            movieIdToMovieMap:movieIdToMovieMap];

    if (movieToShowtimesMap.count == 0) {
        // no showtime information available.  fallback to anything we've
        // stored (but warn the user).

        NSString* performancesFile = [self performancesFile:name];
        NSDictionary* oldPerformances = [NSDictionary dictionaryWithContentsOfFile:performancesFile];

        if (oldPerformances.count > 0) {
            movieToShowtimesMap = [NSMutableDictionary dictionaryWithDictionary:oldPerformances];
        }
    }

    [performances setObject:movieToShowtimesMap forKey:name];
    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                               address:fullAddress
                                           phoneNumber:phone
                                          sellsTickets:sellsTickets
                                           movieTitles:movieToShowtimesMap.allKeys
                                 originatingPostalCode:originatingPostalCode]];
}


- (NSArray*) processFandangoTheaters:(XmlElement*) theatersElement
                          postalCode:(NSString*) postalCode
                        theaterNames:(NSArray*) theaterNames
                   movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];

    for (XmlElement* theaterElement in theatersElement.children) {
        [self processFandangoTheaterElement:theaterElement
                                   theaters:theaters
                               performances:performances
                      originatingPostalCode:postalCode
                               theaterNames:theaterNames
                          movieIdToMovieMap:movieIdToMovieMap];
    }

    return [NSArray arrayWithObjects:theaters, performances, nil];
}


- (NSArray*) processCast:(XmlElement*) element {
    if (element == nil) {
        return [NSArray array];
    }

    NSMutableArray* cast = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        [cast addObject:child.text];
    }
    return cast;
}


- (NSDictionary*) processFandangoMovies:(XmlElement*) moviesElement {
    NSMutableDictionary* movieIdToMovieMap = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in moviesElement.children) {
        NSString* identifier = [movieElement attributeValue:@"id"];
        NSString* poster = [movieElement attributeValue:@"posterhref"];
        NSString* title = [movieElement element:@"title"].text;
        NSString* rating = [movieElement element:@"rating"].text;
        NSString* length = [movieElement element:@"runtime"].text;
        NSString* synopsis = [movieElement element:@"synopsis"].text;
        NSArray* genres = [[[movieElement element:@"genre"].text stringByReplacingOccurrencesOfString:@"_" withString:@" "] componentsSeparatedByString:@", "];
        NSArray* cast = [self processCast:[movieElement element:@"cast"]];

        NSString* releaseDateText = [movieElement element:@"releasedate"].text;
        NSDate* releaseDate = nil;
        if (releaseDateText != nil) {
            releaseDate = [DateUtilities dateWithNaturalLanguageString:releaseDateText];
        }


        Movie* movie = [Movie movieWithIdentifier:identifier
                                            title:title
                                           rating:rating
                                           length:length
                                      releaseDate:releaseDate
                                           poster:poster
                                         synopsis:synopsis
                                           studio:@""
                                        directors:[NSArray array]
                                             cast:cast
                                           genres:genres];

        [movieIdToMovieMap setObject:movie forKey:identifier];
    }

    return movieIdToMovieMap;
}


- (LookupResult*) processFandangoElement:(XmlElement*) element
                              postalCode:(NSString*) postalCode
                            theaterNames:(NSArray*) theaterNames {
    XmlElement* dataElement = [element element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];

    NSDictionary* movieIdToMovieMap = [self processFandangoMovies:moviesElement];
    NSArray* theatersAndPerformances = [self processFandangoTheaters:theatersElement
                                                          postalCode:postalCode
                                                        theaterNames:theaterNames
                                                   movieIdToMovieMap:movieIdToMovieMap];

    NSMutableArray* movies = [NSMutableArray arrayWithArray:movieIdToMovieMap.allValues];
    NSMutableArray* theaters = [theatersAndPerformances objectAtIndex:0];
    NSMutableDictionary* performances = [theatersAndPerformances objectAtIndex:1];

    return [LookupResult resultWithMovies:movies
                                 theaters:theaters
                             performances:performances];
}


- (NSString*) trimPostalCode:(NSString*) postalCode {
    NSMutableString* trimmed = [NSMutableString string];
    for (NSInteger i = 0; i < postalCode.length; i++) {
        unichar c = [postalCode characterAtIndex:i];
        if (isalnum(c)) {
            [trimmed appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return trimmed;
}


- (void) reportUnknownLocation {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(reportUnknownLocation)
                               withObject:nil
                            waitUntilDone:NO];
        return;
    }

    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:NSLocalizedString(@"Could not find location.", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];

    [alert show];
}


- (LookupResult*) lookupLocation:(NSString*) location
                    theaterNames:(NSArray*) theaterNames {
    if (![Utilities isNilOrEmpty:location]) {
        Location* actualLocation = [self.model.addressLocationCache downloadAddressLocationBackgroundEntryPoint:location];
        if (actualLocation.postalCode == nil) {
            [self reportUnknownLocation];
        }

        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                       fromDate:self.model.searchDate];

        NSString* url = [NSString stringWithFormat:
                               @"http://%@.appspot.com/LookupTheaterListings?q=%@&date=%d-%d-%d&provider=Fandango",
                               [Application host],
                               [self trimPostalCode:actualLocation.postalCode],
                               components.year,
                               components.month,
                               components.day];

        XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url
                                                        important:YES];

        if (element != nil) {
            return [self processFandangoElement:element
                                     postalCode:actualLocation.postalCode
                                   theaterNames:theaterNames];
        }
    }

    return nil;
}


- (void) lookupMissingFavorites:(LookupResult*) lookupResult {
    if (lookupResult == nil) {
        return;
    }

    NSArray* favoriteTheaters = self.model.favoriteTheaters;
    if (favoriteTheaters.count == 0) {
        return;
    }

    MultiDictionary* postalCodeToMissingTheaters = [MultiDictionary dictionary];

    for (Theater* theater in favoriteTheaters) {
        if (![lookupResult.theaters containsObject:theater]) {
            [postalCodeToMissingTheaters addObject:theater forKey:theater.originatingPostalCode];
        }
    }

    NSMutableSet* movieTitles = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [movieTitles addObject:movie.canonicalTitle];
    }

    for (NSString* postalCode in postalCodeToMissingTheaters.allKeys) {
        NSArray* missingTheaters = [postalCodeToMissingTheaters objectsForKey:postalCode];
        NSMutableArray* theaterNames = [NSMutableArray array];
        for (Theater* theater in missingTheaters) {
            [theaterNames addObject:theater.name];
        }

        LookupResult* favoritesLookupResult = [self lookupLocation:postalCode
                                                      theaterNames:theaterNames];

        [lookupResult.theaters addObjectsFromArray:favoritesLookupResult.theaters];
        [lookupResult.performances addEntriesFromDictionary:favoritesLookupResult.performances];

        // the theater may refer to movies that we don't know about.
        for (NSString* theaterName in favoritesLookupResult.performances.allKeys) {
            for (NSString* movieTitle in [[favoritesLookupResult.performances objectForKey:theaterName] allKeys]) {
                if (![movieTitles containsObject:movieTitle]) {
                    [movieTitles addObject:movieTitle];

                    for (Movie* movie in favoritesLookupResult.movies) {
                        if ([movie.canonicalTitle isEqual:movieTitle]) {
                            [lookupResult.movies addObject:movie];
                            break;
                        }
                    }
                }
            }
        }
    }
}


- (LookupResult*) lookupWorker {
    LookupResult* result = [self lookupLocation:self.model.userLocation theaterNames:nil];
    [self lookupMissingFavorites:result];
    return result;
}


- (NSString*) displayName {
    return @"North America";
}


- (NSString*) ticketingUrlForTheater:(Theater*) theater
                               movie:(Movie*) movie
                         performance:(Performance*) performance
                                date:(NSDate*) date {
    if ([performance.identifier hasPrefix:@"F-"]) {
        NSDateComponents* dateComponents =
        [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                        fromDate:self.model.searchDate];
        NSDateComponents* timeComponents =
        [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit)
                                        fromDate:[DateUtilities dateWithNaturalLanguageString:performance.time]];

        NSString* url = [NSString stringWithFormat:@"https://iphone.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
                         movie.identifier,
                         theater.identifier,
                         dateComponents.year,
                         dateComponents.month,
                         dateComponents.day,
                         timeComponents.hour,
                         timeComponents.minute];

        return url;
    }

    return nil;
}


@end