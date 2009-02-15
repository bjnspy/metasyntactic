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

#import "WikipediaCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "AppDelegate.h"
#import "Model.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@interface WikipediaCache()
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) LinkedSet* normalMovies;
@end


@implementation WikipediaCache

@synthesize prioritizedMovies;
@synthesize normalMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;
    self.normalMovies = nil;
    
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.normalMovies = [LinkedSet set];
        
        [ThreadingUtilities backgroundSelector:@selector(updateAddressBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }
    
    return self;
}


+ (WikipediaCache*) cacheWithModel:(Model*) model {
    return [[[WikipediaCache alloc] initWithModel:model] autorelease];
}


- (NSString*) wikipediaFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application wikipediaDirectory] stringByAppendingPathComponent:name];
}


- (void) update:(NSArray*) movies {
    [gate lock];
    {
        [normalMovies addObjectsFromArray:movies];
        [gate signal];
    }
    [gate unlock];
}


- (void) updateMovie:(Movie*) movie {
    [gate lock];
    {
        [normalMovies addObject:movie];
        [gate signal];
    }
    [gate unlock];
}


- (void) updateAddress:(Movie*) movie {
    NSString* path = [self wikipediaFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:path];
    
    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:path];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }
        
        // we have a sentinel.  only update if it's been long enough
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupWikipediaListings?q=%@", [Application host], [StringUtilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* wikipediaAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (wikipediaAddress == nil) {
        return;
    }
    
    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:wikipediaAddress toFile:path];
    if (wikipediaAddress.length > 0) {
        [AppDelegate minorRefresh];
    }
}


- (void) updateAddressBackgroundEntryPoint {
    while (YES) {
        Movie* movie = nil;
        BOOL isPriority = NO;
        [gate lock];
        {
            NSInteger count = prioritizedMovies.count;   
            while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                   (movie = [normalMovies removeLastObjectAdded]) == nil) {
                [gate wait];
            }
            isPriority = count != prioritizedMovies.count;
        }
        [gate unlock];
        
        [self updateAddress:movie];
        
        if (!isPriority) {
            [NSThread sleepForTimeInterval:0.25];
        }
    }
}


- (void) prioritizeMovie:(Movie*) movie {
    [gate lock];
    {
        [prioritizedMovies addObject:movie];
        [gate signal];
    }
    [gate unlock];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self wikipediaFile:movie]];
}

@end