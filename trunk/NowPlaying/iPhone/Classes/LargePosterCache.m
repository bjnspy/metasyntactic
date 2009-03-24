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
#import "OperationQueue.h"

@interface LargePosterCache()
@property (retain) NSMutableDictionary* yearToMovieMap_;
@property (retain) NSLock* yearToMovieMapGate_;
@property BOOL updated_;
@end

@implementation LargePosterCache

@synthesize yearToMovieMap_;
@synthesize yearToMovieMapGate_;
@synthesize updated_;

property_wrapper(NSMutableDictionary*, yearToMovieMap, YearToMovieMap);
property_wrapper(NSLock*, yearToMovieMapGate, YearToMovieMapGate);
property_wrapper(BOOL, updated, Updated);

const int START_YEAR = 1912;

- (void) dealloc {
    self.yearToMovieMap = nil;
    self.yearToMovieMapGate = nil;
    self.updated = NO;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.yearToMovieMap = [NSMutableDictionary dictionary];
        self.yearToMovieMapGate = [[[NSRecursiveLock alloc] init] autorelease];
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
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d", index];
    return [[[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Movie*) movie
                            index:(NSInteger) index {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
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
    NSString* file = [NSString stringWithFormat:@"%d.plist", year];
    return [[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:file];
}


- (NSDictionary*) ensureIndexWorker:(NSInteger) year updateIfStale:(BOOL) updateIfStale {
    NSString* file = [self indexFile:year];
    if ([FileUtilities fileExists:file]) {
        if (!updateIfStale) {
            return nil;
        }

        NSDate* modificationDate = [FileUtilities modificationDate:file];
        if (modificationDate != nil) {
            if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
                return nil;
            }
        }
    }

    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings?provider=imp&year=%d", [Application host], year];
    NSString* result = [NetworkUtilities stringWithContentsOfAddress:address];
    if (result.length == 0) {
        return nil;
    }

    NSMutableDictionary* index = [NSMutableDictionary dictionary];
    for (NSString* row in [result componentsSeparatedByString:@"\n"]) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];

        if (columns.count < 2) {
            continue;
        }

        NSArray* posters = [columns subarrayWithRange:NSMakeRange(1, columns.count - 1)];
        [index setObject:posters forKey:[[columns objectAtIndex:0] lowercaseString]];
    }

    if (index.count > 0) {
        [FileUtilities writeObject:index toFile:file];
    }

    return index;
}


- (void) ensureIndex:(NSNumber*) yearNumber updateIfStale:(NSNumber*) updateIfStaleNumber {
    NSInteger year = yearNumber.intValue;
    BOOL updateIfStale = updateIfStaleNumber.boolValue;

    NSDictionary* dictionary = [self ensureIndexWorker:year updateIfStale:updateIfStale];
    if (dictionary == nil) {
        dictionary = [FileUtilities readObject:[self indexFile:year]];
    }

    if (dictionary.count > 0) {
        [self.yearToMovieMapGate lock];
        {
            [self.yearToMovieMap setObject:dictionary forKey:[NSNumber numberWithInt:year]];
        }
        [self.yearToMovieMapGate unlock];
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
    if (self.model.userAddress.length == 0) {
        return;
    }

    if (self.updated) {
        return;
    }
    self.updated = YES;

    NSInteger year = self.currentYear;
    for (NSInteger i = year + 1; i >= START_YEAR; i--) {
        BOOL updateIfStale = (i >= (year - 1) && i <= (year + 1));
        [[AppDelegate operationQueue] performSelector:@selector(ensureIndex:updateIfStale:)
                                             onTarget:self
                                           withObject:[NSNumber numberWithInt:i]
                                           withObject:[NSNumber numberWithBool:updateIfStale]
                                                 gate:nil
                                             priority:Normal];
    }
}


- (NSArray*) posterNames:(Movie*) movie year:(NSInteger) year {
    NSDictionary* movieMap;
    [self.yearToMovieMapGate lock];
    {
        movieMap = [self.yearToMovieMap objectForKey:[NSNumber numberWithInt:year]];
    }
    [self.yearToMovieMapGate unlock];

    NSArray* result = [movieMap objectForKey:movie.canonicalTitle.lowercaseString];
    if (result.count > 0) {
        return result;
    }

    NSString* lowercaseTitle = movie.canonicalTitle.lowercaseString;
    for (NSString* key in movieMap.allKeys) {
        if ([DifferenceEngine substringSimilar:key other:lowercaseTitle]) {
            return [movieMap objectForKey:key];
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
    [self.gate lock];
    {
        array = [self posterUrlsNoLock:movie];
    }
    [self.gate unlock];
    return array;
}


- (void) downloadPosterForMovieWorker:(Movie*) movie
                                 urls:(NSArray*) urls
                                index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    if (index < 0 || index >= urls.count) {
        return;
    }

    NSData* data = [NetworkUtilities dataWithContentsOfAddress:[urls objectAtIndex:index]];
    if (data != nil) {
        [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
        [AppDelegate minorRefresh];
    }
}


- (void) downloadPosterForMovie:(Movie*) movie
                           urls:(NSArray*) urls
                          index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    [self.gate lock];
    {
        if (![FileUtilities fileExists:[self posterFilePath:movie index:index]]) {
            [self downloadPosterForMovieWorker:movie urls:urls index:index];
        }
    }
    [self.gate unlock];
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
    [self.gate lock];
    {
        NSArray* urls = [self posterUrlsNoLock:movie];
        count = urls.count;
    }
    [self.gate unlock];
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