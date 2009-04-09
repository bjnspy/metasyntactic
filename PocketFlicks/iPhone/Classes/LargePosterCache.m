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

#import "AppDelegate.h"
#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "ImageUtilities.h"
#import "Model.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"

@interface LargePosterCache()
@property (retain) NSMutableDictionary* yearToMovieNames;
@property (retain) NSLock* yearToMovieNamesGate;
@property BOOL updated;
@end

@implementation LargePosterCache

@synthesize yearToMovieNames;
@synthesize yearToMovieNamesGate;
@synthesize updated;

const int START_YEAR = 1912;

- (void) dealloc {
    self.yearToMovieNames = nil;
    self.yearToMovieNamesGate = nil;
    self.updated = NO;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.yearToMovieNames = [NSMutableDictionary dictionary];
        self.yearToMovieNamesGate = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


+ (LargePosterCache*) cache {
    return [[[LargePosterCache alloc] init] autorelease];
}


- (Model*) model {
    return [Model model];
}


- (NSString*) posterFilePath:(Movie*) movie
                       index:(NSInteger) index {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.displayTitle];
    sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d", index];
    return [[[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Movie*) movie
                            index:(NSInteger) index {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.displayTitle];
    sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d-small", index];
    return [[[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"png"];
}


- (UIImage*) posterForMovie:(Movie*) movie
                      index:(NSInteger) index {
    NSString* path = [self posterFilePath:movie index:index];
    NSData* data = [FileUtilities readData:path];
    UIImage* image = [UIImage imageWithData:data];

    CGSize size = image.size;
    if (size.height >= size.width && image.size.height > (FULL_SCREEN_POSTER_HEIGHT + 1)) {
        NSData* resizedData = [ImageUtilities scaleImageData:data
                                                    toHeight:FULL_SCREEN_POSTER_HEIGHT];
        image = [UIImage imageWithData:data];
        [FileUtilities writeData:resizedData toFile:path];
    } else if (size.width >= size.height && image.size.width > (FULL_SCREEN_POSTER_HEIGHT + 1)) {
        NSData* resizedData = [ImageUtilities scaleImageData:data
                                                    toHeight:FULL_SCREEN_POSTER_WIDTH];
        image = [UIImage imageWithData:data];
        [FileUtilities writeData:resizedData toFile:path];
    }

    return image;
}


- (UIImage*) smallPosterForMovie:(Movie*) movie
                           index:(NSInteger) index {
    NSData* smallPosterData;
    NSString* smallPosterPath = [self smallPosterFilePath:movie
                                                    index:index];

    if ([FileUtilities size:smallPosterPath] == 0 && index == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:movie index:index]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];
        [FileUtilities writeData:smallPosterData
                          toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }

    return [UIImage imageWithData:smallPosterData];
}


- (BOOL) posterExistsForMovie:(Movie*) movie
                        index:(NSInteger) index {
    NSString* path = [self posterFilePath:movie index:index];
    return [FileUtilities fileExists:path];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");
    return [self posterForMovie:movie index:0];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    NSAssert([NSThread isMainThread], @"");
    return [self smallPosterForMovie:movie index:0];
}


- (NSString*) indexFile:(NSInteger) year {
    NSString* file = [NSString stringWithFormat:@"%d-Index.plist", year];
    return [[Application largeMoviesPostersIndexDirectory] stringByAppendingPathComponent:file];
}


- (NSString*) mapFile:(NSInteger) year {
    NSString* file = [NSString stringWithFormat:@"%d-Map.plist", year];
    return [[Application largeMoviesPostersIndexDirectory] stringByAppendingPathComponent:file];
}


- (void) ensureIndexWorker:(NSInteger) year
             updateIfStale:(BOOL) updateIfStale {
    NSString* indexFile = [self indexFile:year];
    if ([FileUtilities fileExists:indexFile]) {
        if (!updateIfStale) {
            return;
        }

        NSDate* modificationDate = [FileUtilities modificationDate:indexFile];
        if (modificationDate != nil) {
            if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
                return;
            }
        }
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings?provider=imp&year=%d", [Application host], year];
    NSString* result = [NetworkUtilities stringWithContentsOfAddress:address];
    if (result.length == 0) {
        return;
    }

    NSMutableDictionary* titleToPosters = [NSMutableDictionary dictionary];

    for (NSString* row in [result componentsSeparatedByString:@"\n"]) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];

        if (columns.count < 2) {
            continue;
        }

        NSString* title = [[Movie makeDisplay:[columns objectAtIndex:0]] lowercaseString];
        NSArray* posters = [columns subarrayWithRange:NSMakeRange(1, columns.count - 1)];

        if (title.length == 0) {
            continue;
        }

        [titleToPosters setObject:posters forKey:title];
    }

    if (titleToPosters.count > 0) {
        [FileUtilities writeObject:titleToPosters.allKeys toFile:indexFile];
        [FileUtilities writeObject:titleToPosters toFile:[self mapFile:year]];
    }
}


- (void) ensureIndex:(NSInteger) year
       updateIfStale:(BOOL) updateIfStale {
    [self ensureIndexWorker:year updateIfStale:updateIfStale];
    NSArray* array = [FileUtilities readObject:[self indexFile:year]];

    if (array.count > 0) {
        [yearToMovieNamesGate lock];
        {
            [yearToMovieNames setObject:array forKey:[NSNumber numberWithInt:year]];
        }
        [yearToMovieNamesGate unlock];
        [self clearUpdatedMovies];
    }
}


- (NSInteger) yearForDate:(NSDate*) date {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    NSInteger year = components.year;

    return year;
}


- (NSInteger) currentYear {
    NSDate* date = [DateUtilities today];
    return [self yearForDate:date];
}


- (void) update {
    if (updated) {
        return;
    }
    self.updated = YES;

    [ThreadingUtilities backgroundSelector:@selector(ensureIndices) onTarget:self gate:nil visible:NO];
}


- (void) ensureIndices {
    NSInteger year = self.currentYear;
    for (NSInteger i = year + 1; i >= START_YEAR; i--) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            BOOL updateIfStale = (i >= (year - 1) && i <= (year + 1));
            [self ensureIndex:i updateIfStale:updateIfStale];
        }
        [pool release];
    }
}


- (NSArray*) posterNames:(Movie*) movie year:(NSInteger) year {
    NSArray* movieNames;
    [yearToMovieNamesGate lock];
    {
        movieNames = [yearToMovieNames objectForKey:[NSNumber numberWithInt:year]];
    }
    [yearToMovieNamesGate unlock];

    NSString* lowercaseTitle = movie.displayTitle.lowercaseString;
    if ([movieNames containsObject:lowercaseTitle]) {
        NSDictionary* dictionary = [FileUtilities readObject:[self mapFile:year]];
        return [dictionary objectForKey:lowercaseTitle];
    }

    for (NSString* key in movieNames) {
        if ([DifferenceEngine substringSimilar:key other:lowercaseTitle]) {
            NSDictionary* dictionary = [FileUtilities readObject:[self mapFile:year]];
            return [dictionary objectForKey:key];
        }
    }

    return [NSArray array];
}


- (NSArray*) posterUrlsNoLock:(Movie*) movie year:(NSInteger) year {
    NSArray* result = [self posterNames:movie year:year];
    if (result.count == 0) {
        return result;
    }

    NSMutableArray* urls = [NSMutableArray array];
    for (NSString* name in result) {
        NSString* url = [NSString stringWithFormat:@"http://www.impawards.com/%d/posters/%@", year, name];
        [urls addObject:url];
    }
    return urls;
}


- (NSArray*) posterUrlsNoLock:(Movie*) movie {
    NSDate* date = movie.releaseDate;
    if (date != nil) {
        NSInteger releaseYear = [self yearForDate:date];

        NSArray* result;
        if ((result = [self posterUrlsNoLock:movie year:releaseYear]).count > 0 ||
            (result = [self posterUrlsNoLock:movie year:releaseYear - 1]).count > 0 ||
            (result = [self posterUrlsNoLock:movie year:releaseYear - 2]).count > 0 ||
            (result = [self posterUrlsNoLock:movie year:releaseYear + 1]).count > 0 ||
            (result = [self posterUrlsNoLock:movie year:releaseYear + 2]).count > 0) {
            return result;
        }
    } else {
        NSInteger currentYear = self.currentYear;
        for (NSInteger i = currentYear + 1; i >= START_YEAR; i--) {
            NSArray* result = [self posterUrlsNoLock:movie year:i];
            if (result.count > 0) {
                return result;
            }
        }
    }

    return [NSArray array];
}


- (NSArray*) posterUrls:(Movie*) movie {
    NSAssert(![NSThread isMainThread], @"");

    NSArray* array;
    [dataGate lock];
    {
        array = [self posterUrlsNoLock:movie];
    }
    [dataGate unlock];
    return array;
}


- (void) downloadPosterForMovieWorker:(Movie*) movie
                                 urls:(NSArray*) urls
                                index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    if (index < 0 || index >= urls.count) {
        return;
    }

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        NSData* data = [NetworkUtilities dataWithContentsOfAddress:[urls objectAtIndex:index]];
        if (data != nil) {
            [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
            [AppDelegate minorRefresh];
        }
    }
    [pool release];
}


- (void) downloadPosterForMovie:(Movie*) movie
                           urls:(NSArray*) urls
                          index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    [dataGate lock];
    {
        if (![FileUtilities fileExists:[self posterFilePath:movie index:index]]) {
            [self downloadPosterForMovieWorker:movie urls:urls index:index];
        }
    }
    [dataGate unlock];
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
    NSInteger count;
    [dataGate lock];
    {
        NSArray* urls = [self posterUrlsNoLock:movie];
        count = urls.count;
    }
    [dataGate unlock];
    return count;
}


- (BOOL) allPostersDownloadedForMovie:(Movie*) movie {
    NSInteger posterCount = [self posterCountForMovie:movie];

    for (NSInteger i = 0; i < posterCount; i++) {
        if (![FileUtilities fileExists:[self posterFilePath:movie index:i]]) {
            return NO;
        }
    }

    return YES;
}

@end