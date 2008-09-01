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

#import "ApplePosterDownloader.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "Movie.h"
#import "Utilities.h"

@implementation ApplePosterDownloader

static NSDictionary* movieNameToPosterMap = nil;

+ (void) createMap {
    if (movieNameToPosterMap != nil) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings", [Application host]];
    NSString* index = [Utilities stringWithContentsOfAddress:url important:NO];
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
    return [Utilities dataWithContentsOfAddress:posterUrl important:NO];
}

@end