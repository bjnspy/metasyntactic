// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NorthAmericaDataProvider.h"
#import "Application.h"
#import "Utilities.h"
#import "Movie.h"
#import "Theater.h"
#import "Performance.h"
#import "DateUtilities.h"
#import "MultiDictionary.h"

@implementation NorthAmericaDataProvider

@synthesize model;

- (void) dealloc {
    self.model = nil;
    [super dealloc];
}

+ (NorthAmericaDataProvider*) providerWithModel:(BoxOfficeModel*) model {
    return [[[NorthAmericaDataProvider alloc] initWithModel:model] autorelease];
}

- (NSString*) providerFolder {
    return [[Application dataFolder] stringByAppendingPathComponent:@"NorthAmerica"];
}

+ (NSDictionary*) processFandangoShowtimes:(XmlElement*) moviesElement {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in [moviesElement children]) {
        NSString* movieId = [movieElement attributeValue:@"id"];

        XmlElement* performancesElement = [movieElement element:@"performances"];

        NSMutableArray* performances = [NSMutableArray array];

        for (XmlElement* performanceElement in [performancesElement children]) {
            NSString* showId = [performanceElement attributeValue:@"showid"];
            if (![Utilities isNilOrEmpty:showId]) {
                showId = [NSString stringWithFormat:@"F-%@", showId];
            }
            
            NSString* time = [performanceElement attributeValue:@"showtime"];
            time = [Theater processShowtime:time];

            Performance* performance = [Performance performanceWithIdentifier:showId
                                                                         time:time];

            [performances addObject:[performance dictionary]];
        }

        [dictionary setObject:performances forKey:movieId];
    }

    return dictionary;
}

+ (void) processFandangoTheaterElement:(XmlElement*) theaterElement
                              theaters:(NSMutableArray*) theaters
                          performances:(NSMutableDictionary*) performances
                 originatingPostalCode:(NSString*) originatingPostalCode
                            theaterIds:(NSArray*) theaterIds {
    NSString* identifier = [theaterElement attributeValue:@"id"];
    if (theaterIds != nil && ![theaterIds containsObject:identifier]) {
        return;
    }
    
    NSString* sellsTickets = [theaterElement attributeValue:@"iswired"];
    //if (![@"True" isEqual:sellsTickets]) {
    //    return;
    //}
    
    NSString* name = [[theaterElement element:@"name"] text];
    NSString* address = [[theaterElement element:@"address1"] text];
    NSString* city = [[theaterElement element:@"city"] text];
    NSString* state = [[theaterElement element:@"state"] text];
    NSString* postalCode = [[theaterElement element:@"postalcode"] text];
    NSString* phone = [[theaterElement element:@"phonenumber"] text];

    NSString* fullAddress;
    if ([address hasSuffix:@"."]) {
        fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, postalCode];
    } else {
        fullAddress = [NSString stringWithFormat:@"%@. %@, %@ %@", address, city, state, postalCode];
    }

    XmlElement* moviesElement = [theaterElement element:@"movies"];
    NSDictionary* movieToShowtimesMap = [self processFandangoShowtimes:moviesElement];

    if (movieToShowtimesMap.count == 0) {
        return;
    }

    [performances setObject:movieToShowtimesMap forKey:identifier];
    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                               address:fullAddress
                                           phoneNumber:phone
                                          sellsTickets:sellsTickets
                                      movieIdentifiers:[movieToShowtimesMap allKeys]
                                 originatingPostalCode:originatingPostalCode]];
}

+ (NSArray*) processFandangoTheaters:(XmlElement*) theatersElement
                          postalCode:(NSString*) postalCode
                          theaterIds:(NSArray*) theaterIds {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];

    for (XmlElement* theaterElement in [theatersElement children]) {
        [self processFandangoTheaterElement:theaterElement
                                   theaters:theaters
                               performances:performances
                      originatingPostalCode:postalCode
                                 theaterIds:theaterIds];
    }

    return [NSArray arrayWithObjects:theaters, performances, nil];
}

+ (NSMutableArray*) processFandangoMovies:(XmlElement*) moviesElement {
    NSMutableArray* array = [NSMutableArray array];

    for (XmlElement* movieElement in [moviesElement children]) {
        NSString* identifier = [movieElement attributeValue:@"id"];
        NSString* poster = [movieElement attributeValue:@"posterhref"];
        NSString* title = [[movieElement element:@"title"] text];
        NSString* rating = [[movieElement element:@"rating"] text];
        NSString* length = [[movieElement element:@"runtime"] text];
        NSString* synopsis = [[movieElement element:@"synopsis"] text];

        NSString* releaseDateText = [[movieElement element:@"releasedate"] text];
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
                                         synopsis:synopsis];

        [array addObject:movie];
    }

    return array;
}

+ (LookupResult*) processFandangoElement:(XmlElement*) element
                              postalCode:(NSString*) postalCode
                              theaterIds:(NSArray*) theaterIds {
    XmlElement* dataElement = [element element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];

    NSMutableArray* movies = [self processFandangoMovies:moviesElement];
    NSArray* theatersAndPerformances = [self processFandangoTheaters:theatersElement
                                                          postalCode:postalCode
                                                          theaterIds:theaterIds];
    NSMutableArray* theaters = [theatersAndPerformances objectAtIndex:0];
    NSMutableDictionary* performances = [theatersAndPerformances objectAtIndex:1];

    return [LookupResult resultWithMovies:movies
                                 theaters:theaters
                             performances:performances];
}

- (void) lookupMissingFavorites:(LookupResult*) lookupResult {
    if (lookupResult == nil) {
        return;
    }
    
    NSArray* favoriteTheaters = [self.model favoriteTheaters];
    if (favoriteTheaters.count == 0) {
        return;
    }
    
    MultiDictionary* postalCodeToMissingTheaters = [MultiDictionary dictionary];
    
    for (Theater* theater in favoriteTheaters) {
        if (![lookupResult.theaters containsObject:theater]) {
            [postalCodeToMissingTheaters addObject:theater forKey:theater.originatingPostalCode];
        }
    }
    
    NSMutableSet* movieIds = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [movieIds addObject:movie.identifier];
    }
    
    for (NSString* postalCode in postalCodeToMissingTheaters.allKeys) {
        NSArray* missingTheaters = [postalCodeToMissingTheaters objectsForKey:postalCode];
        NSMutableArray* theaterIds = [NSMutableArray array];
        for (Theater* theater in missingTheaters) {
            [theaterIds addObject:theater.identifier];
        }
        
        LookupResult* favoritesLookupResult = [self lookupPostalCode:postalCode
                                                          theaterIds:theaterIds];
        
        [lookupResult.theaters addObjectsFromArray:favoritesLookupResult.theaters];
        [lookupResult.performances addEntriesFromDictionary:favoritesLookupResult.performances];
        
        // the theater may refer to movies that we don't know about.
        for (NSString* theaterId in favoritesLookupResult.performances.allKeys) {
            for (NSString* movieId in [[favoritesLookupResult.performances objectForKey:theaterId] allKeys]) {
                if (![movieIds containsObject:movieId]) {
                    [movieIds addObject:movieId];
                    
                    for (Movie* movie in favoritesLookupResult.movies) {
                        if ([movie.identifier isEqual:movieId]) {
                            [lookupResult.movies addObject:movie];
                            break;
                        }
                    }
                }
            }
        }
    }
}

- (NSString*) trimPostalCode:(NSString*) postalCode {
    NSMutableString* trimmed = [NSMutableString string];
    for (NSInteger i = 0; i < [postalCode length]; i++) {
        unichar c = [postalCode characterAtIndex:i];
        if (isalnum(c)) {
            [trimmed appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return trimmed;
}

- (LookupResult*) lookupPostalCode:(NSString*) postalCode
                        theaterIds:(NSArray*) theaterIds {
    if (![Utilities isNilOrEmpty:postalCode]) {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                       fromDate:[self.model searchDate]];
        
        NSString* urlString = [NSString stringWithFormat:
                               @"http://%@.appspot.com/LookupTheaterListings?q=%@&date=%d-%d-%d&provider=Fandango",
                               [Application host],
                               [self trimPostalCode:postalCode],
                               [components year],
                               [components month],
                               [components day]];
        
        XmlElement* element = [Utilities downloadXml:urlString];
        
        if (element != nil) {
            return [NorthAmericaDataProvider processFandangoElement:element
                                                         postalCode:postalCode
                                                         theaterIds:theaterIds];
        }
    }
    
    return nil;
}

- (LookupResult*) lookupWorker {
    LookupResult* result = [self lookupPostalCode:self.model.postalCode theaterIds:nil];
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
                                        fromDate:[self.model searchDate]];
        NSDateComponents* timeComponents =
        [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit)
                                        fromDate:[DateUtilities dateWithNaturalLanguageString:performance.time]];
        
        NSString* url = [NSString stringWithFormat:@"https://iphone.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
                         movie.identifier,
                         theater.identifier,
                         [dateComponents year],
                         [dateComponents month],
                         [dateComponents day],
                         [timeComponents hour],
                         [timeComponents minute]];
        
        return url;
    }
    
    return nil;
}

@end
