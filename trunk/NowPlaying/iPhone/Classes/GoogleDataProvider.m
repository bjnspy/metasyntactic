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


- (NSArray*) processXmlArray:(XmlElement*) element {
    if (element == nil) {
        return [NSArray array];
    }

    NSMutableArray* cast = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSString* value = [child attributeValue:@"value"];
        if (value.length > 0) {
            [cast addObject:child.text];
        }
    }
    return cast;
}


- (NSDictionary*) processMoviesElement:(XmlElement*) moviesElement {
    NSMutableDictionary* movieIdToMovieMap = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in moviesElement.children) {
        NSString* identifier = [movieElement attributeValue:@"identifier"];
        NSString* poster = @"";
        NSString* title = [movieElement attributeValue:@"title"];
        NSString* rating = [movieElement attributeValue:@"rawRatings"];
        NSString* length = [movieElement attributeValue:@"length"];
        NSString* synopsis = [movieElement attributeValue:@"description"];
        NSArray* genres = [[[movieElement attributeValue:@"genre"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] componentsSeparatedByString:@"/"];
        NSArray* directors = [self processXmlArray:[movieElement element:@"Directors"]];
        NSArray* cast = [self processXmlArray:[movieElement element:@"Cast"]];
        NSString* releaseDateString = [movieElement attributeValue:@"releaseDate"];
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


/*
 - <Movies>
 - <Movie identifier="0xcf14c60de331541L">
 - <Showtimes vendor="f">
 <Showtime time="2:45" />
 <Showtime mobileUrl="http://mobile.fandango.com/tms.asp?a=11586&m=66653&t=AABQG&d=2008-09-15+17:15" time="5:15" url="http://www.google.com/url?q=http://www.fandango.com/redirect.aspx%3Ftid%3DAABQG%26tmid%3D66653%26date%3D2008-09-15%2B17:15%26a%3D11584%26source%3Dgoogle&sa=X&oi=moviesf&ii=6" />
 <Showtime mobileUrl="http://mobile.fandango.com/tms.asp?a=11586&m=66653&t=AABQG&d=2008-09-15+19:45" time="7:45" url="http://www.google.com/url?q=http://www.fandango.com/redirect.aspx%3Ftid%3DAABQG%26tmid%3D66653%26date%3D2008-09-15%2B19:45%26a%3D11584%26source%3Dgoogle&sa=X&oi=moviesf&ii=6" />
 <Showtime mobileUrl="http://mobile.fandango.com/tms.asp?a=11586&m=66653&t=AABQG&d=2008-09-15+22:10" time="10:10pm" url="http://www.google.com/url?q=http://www.fandango.com/redirect.aspx%3Ftid%3DAABQG%26tmid%3D66653%26date%3D2008-09-15%2B22:10%26a%3D11584%26source%3Dgoogle&sa=X&oi=moviesf&ii=6" />
 </Showtimes>
 </Movie>

 */

- (NSMutableDictionary*) processMovieShowtimes:(XmlElement*) moviesElement
                             movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    for (XmlElement* movieElement in moviesElement.children) {
        NSString* movieId = [movieElement attributeValue:@"identifier"];
        NSString* movieTitle = [[movieIdToMovieMap objectForKey:movieId] canonicalTitle];

        XmlElement* showtimesElement = [movieElement element:@"Showtimes"];
        NSString* vendor = [Utilities nonNilString:[showtimesElement attributeValue:@"vendor"]];

        NSMutableArray* performances = [NSMutableArray array];

        for (XmlElement* showtimeElement in showtimesElement.children) {
            NSString* time = [showtimeElement attributeValue:@"time"];
            time = [Theater processShowtime:time];

            NSString* url = [showtimeElement attributeValue:@"mobileUrl"];
            if (url.length == 0) {
                url = [showtimeElement attributeValue:@"url"];
            }

            Performance* performance = [Performance performanceWithIdentifier:vendor
                                                                         time:time
                                                                          url:url];

            [performances addObject:performance.dictionary];
        }

        [dictionary setObject:performances forKey:movieTitle];
    }

    return dictionary;
}


- (void) processTheaterElement:(XmlElement*) theaterElement
                      theaters:(NSMutableArray*) theaters
                  performances:(NSMutableDictionary*) performances
           synchronizationData:(NSMutableDictionary*) synchronizationData
         originatingPostalCode:(NSString*) originatingPostalCode
                  theaterNames:(NSArray*) theaterNames
             movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSString* name = [theaterElement attributeValue:@"name"];
    if (name.length == 0) {
        return;
    }

    if (theaterNames != nil && ![theaterNames containsObject:name]) {
        return;
    }

    NSString* identifier = [Utilities nonNilString:[theaterElement attributeValue:@"identifier"]];
    NSString* address =    [Utilities nonNilString:[theaterElement attributeValue:@"streetAddress"]];
    NSString* city =       [Utilities nonNilString:[theaterElement attributeValue:@"city"]];
    NSString* state =      [Utilities nonNilString:[theaterElement attributeValue:@"state"]];
    NSString* postalCode = [Utilities nonNilString:[theaterElement attributeValue:@"postalCode"]];
    NSString* phone =      [Utilities nonNilString:[theaterElement attributeValue:@"phone"]];
    double latitude = [[theaterElement attributeValue:@"latitude"] doubleValue];
    double longitude = [[theaterElement attributeValue:@"longitude"] doubleValue];

    NSString* fullAddress;
    if ([address hasSuffix:@"."]) {
        fullAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", address, city, state, postalCode];
    } else {
        fullAddress = [NSString stringWithFormat:@"%@. %@, %@ %@", address, city, state, postalCode];
    }

    XmlElement* moviesElement = [theaterElement element:@"Movies"];
    NSMutableDictionary* movieToShowtimesMap = [self processMovieShowtimes:moviesElement
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

    [performances setObject:movieToShowtimesMap forKey:name];
    [theaters addObject:[Theater theaterWithIdentifier:identifier
                                                  name:name
                                               address:fullAddress
                                           phoneNumber:phone
                                              latitude:latitude
                                             longitude:longitude
                                          sellsTickets:NO
                                           movieTitles:movieToShowtimesMap.allKeys
                                 originatingPostalCode:originatingPostalCode]];
}


- (NSArray*) processTheaterElements:(NSArray*) theaterElements
                         postalCode:(NSString*) postalCode
                       theaterNames:(NSArray*) theaterNames
                  movieIdToMovieMap:(NSDictionary*) movieIdToMovieMap {
    NSMutableArray* theaters = [NSMutableArray array];
    NSMutableDictionary* performances = [NSMutableDictionary dictionary];
    NSMutableDictionary* synchronizationData = [NSMutableDictionary dictionary];

    for (XmlElement* theaterElement in theaterElements) {
        [self processTheaterElement:theaterElement
                           theaters:theaters
                       performances:performances
                synchronizationData:synchronizationData
              originatingPostalCode:postalCode
                       theaterNames:theaterNames
                  movieIdToMovieMap:movieIdToMovieMap];
    }

    return [NSArray arrayWithObjects:theaters, performances, synchronizationData, nil];
}


- (LookupResult*) processTheaterListingsElement:(XmlElement*) element
                                     postalCode:(NSString*) postalCode
                                   theaterNames:(NSArray*) theaterNames {
    XmlElement* moviesElement = [element element:@"Movies"];
    NSArray* theaterElements = [element elements:@"Theater"];

    NSDictionary* movieIdToMovieMap = [self processMoviesElement:moviesElement];

    NSArray* theatersAndPerformances = [self processTheaterElements:theaterElements
                                                         postalCode:postalCode
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

    return nil;
}


- (LookupResult*) lookupLocationWorker:(Location*) location
                    theaterNames:(NSArray*) theaterNames {
    if (location.postalCode == nil) {
        [self reportUnknownLocation];
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
                         @"http://metaboxoffice6.appspot.com/LookupTheaterListings?country=%@&language=%@&postalcode=%@&day=%d&format=xml&latitude=%d&longitude=%d",
                         country,
                         [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                         [Utilities stringByAddingPercentEscapes:location.postalCode],
                         day,
                         (int)(location.latitude * 1000000),
                         (int)(location.longitude * 1000000)];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES];

    if (element != nil) {
        return [self processTheaterListingsElement:element
                                        postalCode:location.postalCode
                                      theaterNames:theaterNames];
    }

    return nil;
}


- (NSString*) displayName {
    return @"Google";
}


- (NSString*) ticketingUrlForTheater:(Theater*) theater
                               movie:(Movie*) movie
                         performance:(Performance*) performance
                                date:(NSDate*) date {
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


@end