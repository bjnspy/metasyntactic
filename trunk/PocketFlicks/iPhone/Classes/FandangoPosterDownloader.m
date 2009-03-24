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

static NSDictionary* movieNameToPosterMap = nil;
static NSLock* gate;

+ (void) initialize {
    if (self == [FandangoPosterDownloader class]) {
        gate = [[NSLock alloc] init];
    }
}

+ (void) processFandangoElement:(XmlElement*) element {
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
        return;
    }

    movieNameToPosterMap = [map retain];
}


+ (void) createMovieMapWorker {
    if (movieNameToPosterMap != nil) {
        return;
    }

    NSString* postalCode = @"10009";
    NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                                   fromDate:[DateUtilities today]];

    NSString* url = [NSString stringWithFormat:
                     @"http://%@.appspot.com/LookupTheaterListings?q=%@&date=%d-%d-%d&provider=Fandango",
                     [Application host],
                     postalCode,
                     components.year,
                     components.month,
                     components.day];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url];

    [self processFandangoElement:element];
}


+ (void) createMovieMap {
    [gate lock];
    {
        [self createMovieMapWorker];
    }
    [gate unlock];
}


+ (NSData*) download:(Movie*) movie {
    [self createMovieMap];

    if (movieNameToPosterMap == nil) {
        return nil;
    }

    NSString* key = [[DifferenceEngine engine] findClosestMatch:movie.canonicalTitle inArray:movieNameToPosterMap.allKeys];
    if (key == nil) {
        return nil;
    }

    NSString* posterUrl = [movieNameToPosterMap objectForKey:key];
    return [NetworkUtilities dataWithContentsOfAddress:posterUrl];
}

@end