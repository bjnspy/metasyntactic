//
//  NorthAmericaDataProvider.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NorthAmericaDataProvider.h"
#import "Application.h"
#import "Utilities.h"
#import "Movie.h"
#import "Theater.h"
#import "Performance.h"
#import "DateUtilities.h"

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

- (NSDictionary*) processShowtimes:(XmlElement*) moviesElement {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in [moviesElement children]) {
        NSString* movieId = [movieElement attributeValue:@"id"];

        XmlElement* performancesElement = [movieElement element:@"performances"];

        NSMutableArray* performances = [NSMutableArray array];

        for (XmlElement* performanceElement in [performancesElement children]) {
            NSString* showId = [performanceElement attributeValue:@"showid"];
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

- (void) processTheaterElement:(XmlElement*) theaterElement theaters:(NSMutableArray*) theaters performances:(NSMutableDictionary*) performances {
    NSString* identifier = [theaterElement attributeValue:@"id"];
    NSString* name = [[theaterElement element:@"name"] text];
    NSString* address = [[theaterElement element:@"address1"] text];
    NSString* city = [[theaterElement element:@"city"] text];
    NSString* state = [[theaterElement element:@"state"] text];
    NSString* postalCode = [[theaterElement element:@"postalcode"] text];
    NSString* phone = [[theaterElement element:@"phonenumber"] text];
    NSString* sellsTickets = [theaterElement attributeValue:@"iswired"];

    NSString* fullAddress;
    if ([address hasSuffix:@"."]) {
        fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, postalCode];
    } else {
        fullAddress = [NSString stringWithFormat:@"%@. %@, %@ %@", address, city, state, postalCode];
    }

    XmlElement* moviesElement = [theaterElement element:@"movies"];
    NSDictionary* movieToShowtimesMap = [self processShowtimes:moviesElement];

    if (movieToShowtimesMap.count == 0) {
        return;
    }

    [performances setObject:movieToShowtimesMap forKey:identifier];
    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                               address:fullAddress
                                           phoneNumber:phone
                                          sellsTickets:sellsTickets
                                      movieIdentifiers:[movieToShowtimesMap allKeys]]];
}

- (NSArray*) processTheaters:(XmlElement*) theatersElement {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];

    for (XmlElement* theaterElement in [theatersElement children]) {
        [self processTheaterElement:theaterElement theaters:theaters performances:performances];
    }

    return [NSArray arrayWithObjects:theaters, performances, nil];
}

- (NSArray*) processMovies:(XmlElement*) moviesElement {
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

- (LookupResult*) processElement:(XmlElement*) element {
    XmlElement* dataElement = [element element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];

    NSArray* movies = [self processMovies:moviesElement];
    NSArray* theatersAndPerformances = [self processTheaters:theatersElement];
    NSArray* theaters = [theatersAndPerformances objectAtIndex:0];
    NSDictionary* performances = [theatersAndPerformances objectAtIndex:1];

    return [LookupResult resultWithMovies:movies theaters:theaters performances:performances];
}

- (LookupResult*) lookupWorker {
    if (![Utilities isNilOrEmpty:self.model.postalCode]) {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                       fromDate:[self.model searchDate]];

        NSString* urlString =[NSString stringWithFormat:
                              @"http://%@.appspot.com/LookupTheaterListings?q=%@&date=%d-%d-%d",
                              [Application host],
                              self.model.postalCode,
                              [components year],
                              [components month],
                              [components day]];

        XmlElement* element = [Utilities downloadXml:urlString];

        if (element != nil) {
            return [self processElement:element];
        }
    }

    return nil;
}

- (NSString*) displayName {
    return @"North America";
}

@end
