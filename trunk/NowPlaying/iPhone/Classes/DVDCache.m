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

#import "DVDCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Movie.h"
#import "ThreadingUtilities.h"

@implementation DVDCache

@synthesize gate;
@synthesize dvdData;
@synthesize blurayData;

- (void) dealloc {
    self.gate = nil;
    self.dvdData = nil;
    self.blurayData = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
    }
    
    return self;
}


+ (DVDCache*) cache {
    return [[[DVDCache alloc] init] autorelease];
}


- (NSString*) dvdFile {
    return [[Application dvdFolder] stringByAppendingPathComponent:@"DVD.plist"];
}


- (NSString*) blurayFile {
    return [[Application dvdFolder] stringByAppendingPathComponent:@"Blu-ray.plist"];
}


- (NSArray*) decodeArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
    }
    
    return result;
}


- (NSArray*) loadDvd {
    NSArray* encodedMovies = [FileUtilities readObject:[self dvdFile]];
    return [self decodeArray:encodedMovies];
}


- (NSArray*) loadBluray {
    NSArray* encodedMovies = [FileUtilities readObject:[self blurayFile]];
    return [self decodeArray:encodedMovies];
}


- (NSArray*) dvdMovies {
    if (dvdData == nil) {
        self.dvdData = [self loadDvd];
    }
    
    return dvdData;
}


- (NSArray*) blurayMovies {
    if (blurayData == nil) {
        self.blurayData = [self loadBluray];
    }
    
    return blurayData;
}


- (void) updateMovies {
    [ThreadingUtilities performSelector:@selector(updateMoviesBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:gate 
                                visible:YES];
}


- (void) updateDetails {    
    NSArray* arguments = [NSArray arrayWithObjects:self.dvdMovies, self.blurayMovies, nil];
    [ThreadingUtilities performSelector:@selector(updateDetailsBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate 
                                visible:YES];
}


- (void) update {
    [self updateMovies];
    [self updateDetails];
}


- (void) updateMoviesBackgroundEntryPoint {
    
}


- (void) updateDetailsBackgroundEntryPoint:(NSArray*) movies {
    
}


- (NSString*) posterFile:(Movie*) movie {
    return [[[Application dvdPostersFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingPathExtension:@"plist"];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    return [UIImage imageWithData:[FileUtilities readObject:[self posterFile:movie]]];
}

@end