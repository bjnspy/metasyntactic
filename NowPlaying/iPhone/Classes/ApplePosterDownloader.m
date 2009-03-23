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

#import "ApplePosterDownloader.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "Movie.h"
#import "NetworkUtilities.h"

@implementation ApplePosterDownloader

static NSDictionary* movieNameToPosterMap = nil;

+ (void) createMap {
    if (movieNameToPosterMap != nil) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings", [Application host]];
    NSString* index = [NetworkUtilities stringWithContentsOfAddress:url];
    if (index == nil) {
        return;
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    NSArray* rows = [index componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];

        if (columns.count >= 2) {
            NSString* movieName = [Movie makeCanonical:[columns objectAtIndex:0]];
            NSString* posterUrl = [columns objectAtIndex:1];

            [result setObject:posterUrl forKey:movieName];
        }
    }

    movieNameToPosterMap = result;
    [movieNameToPosterMap retain];
}

+ (NSData*) download:(Movie*) movie {
    [self createMap];
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