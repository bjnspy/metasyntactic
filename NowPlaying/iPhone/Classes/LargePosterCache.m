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

#import "LargePosterCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "Movie.h"
#import "ThreadingUtilities.h"

@implementation LargePosterCache

@synthesize gate;
@synthesize indexData;

- (void) dealloc {
    self.gate = nil;
    self.indexData = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


+ (LargePosterCache*) cache {
    return [[[LargePosterCache alloc] init] autorelease];
}


- (void) update {
    [ThreadingUtilities performSelector:@selector(updateBackgroundEntryPoint) onTarget:self inBackgroundWithArgument:nil gate:gate visible:NO];
}


- (void) deleteObsoletePosters {
    for (NSString* path in [FileUtilities directoryContentsPaths:[Application largePostersDirectory]]) {
        if (![path hasSuffix:@"jpg"]) {
            continue;
        }
        
        NSDate* lastModifiedDate = [FileUtilities modificationDate:path];
            
        if (lastModifiedDate != nil) {
            if (ABS([lastModifiedDate timeIntervalSinceNow]) > ONE_MONTH) {
                [FileUtilities removeItem:path];
            }
        }
    }
}


- (void) updateBackgroundEntryPoint {
    [self deleteObsoletePosters];
}


- (NSString*) posterFilePath:(Movie*) movie index:(NSInteger) index {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d", index];
    return [[[Application largePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (UIImage*) posterForMovie:(Movie*) movie
                      index:(NSInteger) index {
    NSString* path = [self posterFilePath:movie index:index];
    NSData* data = [FileUtilities readData:path];
    return [UIImage imageWithData:data];
}


- (BOOL) posterExistsForMovie:(Movie*) movie
                        index:(NSInteger) index {
    NSString* path = [self posterFilePath:movie index:index];
    return [FileUtilities fileExists:path];
}


- (UIImage*) firstPosterForMovie:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");
    return [self posterForMovie:movie index:0];
}


- (NSString*) indexFile {
    return [[Application largePostersDirectory] stringByAppendingPathComponent:@"Index.plist"];
}


- (NSDictionary*) loadIndex {
    NSDictionary* result = [FileUtilities readObject:self.indexFile];
    if (result == nil) {
        return [NSDictionary dictionary];
    }

    return result;
}


- (NSDictionary*) index {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }

    return indexData;
}


- (void) ensureIndex {
    NSString* file = self.indexFile;
    NSDate* modificationDate = [FileUtilities modificationDate:file];
    if (modificationDate != nil) {
        if (ABS([modificationDate timeIntervalSinceNow]) < ONE_WEEK) {
            return;
        }
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings?provider=imp", [Application host]];
    NSString* result = [NetworkUtilities stringWithContentsOfAddress:address
                                                           important:NO];
    if (result.length == 0) {
        return;
    }

    NSMutableDictionary* index = [NSMutableDictionary dictionary];
    for (NSString* row in [result componentsSeparatedByString:@"\n"]) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];

        if (columns.count < 2) {
            continue;
        }

        NSArray* posters = [columns subarrayWithRange:NSMakeRange(1, columns.count - 1)];
        [index setObject:posters forKey:[columns objectAtIndex:0]];
    }

    if (index.count > 0) {
        [FileUtilities writeObject:index toFile:file];
        self.indexData = index;
    }
}


- (NSArray*) posterUrlsWorker:(Movie*) movie {
    [self ensureIndex];

    NSDictionary* index = self.index;

    DifferenceEngine* engine = [DifferenceEngine engine];
    NSString* title = [engine findClosestMatch:movie.canonicalTitle inArray:index.allKeys];

    if (title.length == 0) {
        return [NSArray array];
    }

    NSArray* urls = [index objectForKey:title];
    return urls;
}


- (NSArray*) posterUrls:(Movie*) movie {
    NSAssert(![NSThread isMainThread], @"");

    NSArray* array;
    [gate lock];
    {
        array = [self posterUrlsWorker:movie];
    }
    [gate unlock];
    return array;
}


- (void) downloadPosterForMovieWorker:(Movie*) movie
                                 urls:(NSArray*) urls
                                index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    if (index < 0 || index >= urls.count) {
        return;
    }

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:[urls objectAtIndex:index]
                                                     important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
        [NowPlayingAppDelegate refresh];
    }
}


- (void) downloadPosterForMovie:(Movie*) movie
                           urls:(NSArray*) urls
                          index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    [gate lock];
    {
        if (![FileUtilities fileExists:[self posterFilePath:movie index:index]]) {
            [self downloadPosterForMovieWorker:movie urls:urls index:index];
        }
    }
    [gate unlock];
}


- (void) downloadFirstPosterForMovie:(Movie*) movie {
    NSArray* urls = [self posterUrls:movie];
    [self downloadPosterForMovie:movie urls:urls index:0];
}


- (void) downloadAllPostersForMovie:(Movie*) movie {
    NSArray* urls = [self posterUrls:movie];
    for (int i = 0; i < urls.count; i++) {
        [self downloadPosterForMovie:movie urls:urls index:i];
    }
}


- (NSInteger) posterCountForMovie:(Movie*) movie {
    NSAssert(![NSThread isMainThread], @"");
    NSInteger count;
    [gate lock];
    {
        NSArray* urls = [self posterUrls:movie];
        count = urls.count;
    }
    [gate unlock];
    return count;
}


@end