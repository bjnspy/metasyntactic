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

#import "AbstractPosterDownloader.h"

#import "Application.h"
#import "Movie.h"

@interface AbstractPosterDownloader()
@property (retain) NSDictionary* movieNameToPosterMap;
@property (retain) NSLock* gate;
@end

@implementation AbstractPosterDownloader

@synthesize movieNameToPosterMap;
@synthesize gate;

- (void) dealloc {
    self.movieNameToPosterMap = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


- (NSDictionary*) createMapWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) indexFile {
    NSString* name = [NSString stringWithFormat:@"%@.plist", NSStringFromClass([self class])];
    return [[Application moviesPostersDirectory] stringByAppendingPathComponent:name];
}


- (BOOL) tooSoon {
    NSDate* modificationDate = [FileUtilities modificationDate:[self indexFile]];
    if (modificationDate == nil) {
        return NO;
    }

    return ABS([modificationDate timeIntervalSinceNow]) < THREE_DAYS;
}


- (NSDictionary*) createMap {
    NSDictionary* existingMap = [FileUtilities readObject:[self indexFile]];
    if (existingMap.count > 0 && [self tooSoon]) {
        // we had a usable existing map.  use that for now.
        return existingMap;
    }

    // We either didn't have a map, or too much time has passed.
    // try to get an up to date map.

    NSDictionary* currentMap = [self createMapWorker];
    if (currentMap.count > 0) {
        // we got a good map.  store it for the future.
        [FileUtilities writeObject:currentMap toFile:[self indexFile]];
        return currentMap;
    }

    // we didn't get a new map.  use the old one if it has usable data.
    if (existingMap.count > 0) {
        return existingMap;
    }

    // no good date.  just return an empty map.
    return [NSDictionary dictionary];
}


- (NSData*) downloadWorker:(Movie*) movie {
    if (movieNameToPosterMap == nil) {
        self.movieNameToPosterMap = [self createMap];
    }

    NSString* key = [[DifferenceEngine engine] findClosestMatch:movie.canonicalTitle.lowercaseString inArray:movieNameToPosterMap.allKeys];
    if (key == nil) {
        return nil;
    }

    NSString* posterUrl = [movieNameToPosterMap objectForKey:key];
    return [NetworkUtilities dataWithContentsOfAddress:posterUrl];
}


- (NSData*) download:(Movie*) movie {
    NSData* result;
    [gate lock];
    {
        result = [self downloadWorker:movie];
    }
    [gate unlock];
    return result;
}

@end