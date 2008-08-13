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

#import "TrailerCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "Movie.h"
#import "Utilities.h"

@implementation TrailerCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (TrailerCache*) cache {
    return [[[TrailerCache alloc] init] autorelease];
}


- (NSString*) trailerFileName:(NSString*) title {
    return [[Application sanitizeFileName:title] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailerFilePath:(NSString*) title {
    return [[Application trailersFolder] stringByAppendingPathComponent:[self trailerFileName:title]];
}


- (void) deleteObsoleteTrailers:(NSArray*) movies {
    NSArray* contents = [[NSFileManager defaultManager] directoryContentsAtPath:[Application trailersFolder]];
    NSMutableSet* set = [NSMutableSet setWithArray:contents];

    for (Movie* movie in movies) {
        NSString* filePath = [self trailerFileName:movie.canonicalTitle];
        [set removeObject:filePath];
    }

    for (NSString* filePath in set) {
        NSString* fullPath = [[Application trailersFolder] stringByAppendingPathComponent:filePath];

        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    }
}


- (NSArray*) getOrderedMovies:(NSArray*) movies {
    NSMutableArray* moviesWithoutTrailers = [NSMutableArray array];
    NSMutableArray* moviesWithTrailers = [NSMutableArray array];

    for (Movie* movie in movies) {
        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self trailerFilePath:movie.canonicalTitle]
                                                                                 error:NULL] objectForKey:NSFileModificationDate];

        if (downloadDate == nil) {
            [moviesWithoutTrailers addObject:movie];
        } else {
            NSTimeInterval span = [downloadDate timeIntervalSinceNow];
            if (ABS(span) > (24 * 60 * 60)) {
                [moviesWithTrailers addObject:movie];
            }
        }
    }

    return [NSArray arrayWithObjects:moviesWithoutTrailers, moviesWithTrailers, nil];
}


- (void) update:(NSArray*) movies {
    [self deleteObsoleteTrailers:movies];

    NSArray* orderedMovies = [self getOrderedMovies:movies];

    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:orderedMovies];
}


- (NSString*) getValue:(NSString*) key fromArray:(NSArray*) array {
    for (int i = 0; i < array.count - 2; i++) {
        if ([[array objectAtIndex:i] isEqual:key]) {
            return [array objectAtIndex:(i + 2)];
        }
    }

    return nil;
}


- (void) findTrailers:(NSString*) movieTitle
             indexUrl:(NSString*) indexUrl {
    NSString* contents = [Utilities stringWithContentsOfAddress:indexUrl];

    NSMutableArray* urls = [NSMutableArray array];
    while (contents != nil) {
        NSRange endRange = [contents rangeOfString:@".m4v</string>"];
        if (endRange.length == 0) {
            break;
        }

        NSRange startRange = [contents rangeOfString:@"<string>" options:NSBackwardsSearch range:NSMakeRange(0, endRange.location)];
        if (startRange.length == 0) {
            break;
        }

        NSRange extractRange;
        extractRange.location = NSMaxRange(startRange);
        extractRange.length = endRange.location - extractRange.location;
        extractRange.length += 4;  // ".m4v"

        [urls addObject:[contents substringWithRange:extractRange]];
        contents = [contents substringFromIndex:NSMaxRange(endRange)];
    }

    if (urls.count) {
        [Utilities writeObject:urls toFile:[self trailerFilePath:movieTitle]];
    }
}


- (NSString*) massage:(NSString*) value {
    while (true) {
        NSRange range = [value rangeOfString:@"\\u"];
        if (range.length <= 0) {
            break;
        }

        range.length += 4;
        value = [value stringByReplacingCharactersInRange:range withString:@""];
    }

    return value;
}


- (void) processJsonRow:(NSString*) row
           moviesTitles:(NSArray*) movieTitles
                 engine:(DifferenceEngine*) engine {

    NSArray* values = [row componentsSeparatedByString:@"\""];
    NSString* titleValue = [self getValue:@"title" fromArray:values];
    NSString* locationValue = [self getValue:@"location" fromArray:values];

    if (titleValue == nil || locationValue == nil) {
        return;
    }

    titleValue = [self massage:titleValue];
    locationValue = [self massage:locationValue];

    NSString* movieTitle = [engine findClosestMatch:titleValue inArray:movieTitles];
    if (movieTitle == nil) {
        return;
    }

    NSArray* locations = [locationValue componentsSeparatedByString:@"/"];
    NSString* indexUrl = [NSString stringWithFormat:@"http://www.apple.com/moviesxml/s/%@/%@/index.xml",
                          [locations objectAtIndex:2],
                          [locations objectAtIndex:3]];

    [self findTrailers:movieTitle indexUrl:indexUrl];
}


- (void) downloadTrailers:(NSArray*) movies {
    NSString* jsonFeed = [Utilities stringWithContentsOfAddress:@"http://www.apple.com/trailers/home/feeds/studios.json"];
    if (jsonFeed == nil) {
        return;
    }
    
    NSMutableArray* movieTitles = [NSMutableArray array];

    for (Movie* movie in movies) {
        [movieTitles addObject:movie.canonicalTitle];
    }

    DifferenceEngine* engine = [DifferenceEngine engine];

    NSArray* rows = [jsonFeed componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        [self processJsonRow:row moviesTitles:movieTitles engine:engine];

        [autoreleasePool release];
    }
}


- (void) backgroundEntryPoint:(NSArray*) arguments {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];

        for (NSArray* movies in arguments) {
            [self downloadTrailers:movies];
        }
    }
    [gate unlock];
    [autoreleasePool release];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [NSArray arrayWithContentsOfFile:[self trailerFilePath:movie.canonicalTitle]];
    if (trailers == nil) {
        return [NSArray array];
    }

    return trailers;
}


@end
