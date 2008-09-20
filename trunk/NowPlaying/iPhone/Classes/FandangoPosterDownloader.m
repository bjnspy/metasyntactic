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

#import "FandangoPosterDownloader.h"

#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "XmlElement.h"

@implementation FandangoPosterDownloader

static NSString* lastPostalCode = nil;
static NSDictionary* movieNameToPosterMap = nil;


+ (NSDictionary*) processFandangoElement:(XmlElement*) element {
    NSMutableDictionary* map = [NSMutableDictionary dictionary];

    XmlElement* dataElement = [element element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];

    for (XmlElement* movieElement in moviesElement.children) {
        NSString* poster = [movieElement attributeValue:@"posterhref"];
        NSString* title = [movieElement element:@"title"].text;

        if (poster.length == 0 || title.length == 0) {
            continue;
        }

        title = [Movie makeCanonical:title];

        [map setObject:poster forKey:title];
    }

    if (map.count == 0) {
        return nil;
    }

    [movieNameToPosterMap release];
    movieNameToPosterMap = map;
    [movieNameToPosterMap retain];

    return map;
}


+ (NSString*) trimPostalCode:(NSString*) postalCode {
    NSMutableString* trimmed = [NSMutableString string];
    for (NSInteger i = 0; i < postalCode.length; i++) {
        unichar c = [postalCode characterAtIndex:i];
        if (isalnum(c)) {
            [trimmed appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return trimmed;
}


+ (void) createMovieMap:(NSString*) postalCode {
    if (postalCode.length == 0) {
        return;
    }

    if([postalCode isEqual:lastPostalCode]) {
        return;
    }

    NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                   fromDate:[DateUtilities today]];

    NSString* url = [NSString stringWithFormat:
                     @"http://%@.appspot.com/LookupTheaterListings?q=%@&date=%d-%d-%d&provider=Fandango",
                     [Application host],
                     [self trimPostalCode:postalCode],
                     components.year,
                     components.month,
                     components.day];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url
                                                           important:YES];

    NSDictionary* result = [self processFandangoElement:element];

    if (result.count > 0) {
        [lastPostalCode release];
        lastPostalCode = [[NSString stringWithString:postalCode] retain];
    }
}

+ (NSData*) download:(Movie*) movie
        postalCode:(NSString*) postalCode {
    [self createMovieMap:postalCode];

    if (movieNameToPosterMap == nil) {
        return nil;
    }

    NSString* key = [[DifferenceEngine engine] findClosestMatch:movie.canonicalTitle inArray:movieNameToPosterMap.allKeys];
    if (key == nil) {
        return nil;
    }

    NSString* posterUrl = [movieNameToPosterMap objectForKey:key];
    return [NetworkUtilities dataWithContentsOfAddress:posterUrl important:NO];
}

@end