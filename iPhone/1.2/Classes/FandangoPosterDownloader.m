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


+ (void) createMovieMapWorker:(NSString*) postalCode {
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


+ (void) createMovieMap:(NSString*) postalCode {
    if (postalCode.length == 0) {
        return;
    }

    if([postalCode isEqual:lastPostalCode]) {
        return;
    }

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        [self createMovieMapWorker:postalCode];
    }
    [pool release];
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