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

#import "AmazonCache.h"

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

@interface AmazonCache()
@end


@implementation AmazonCache

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
}


+ (AmazonCache*) cacheWithModel:(Model*) model {
    return [[[AmazonCache alloc] initWithModel:model] autorelease];
}


- (NSString*) amazonFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application amazonDirectory] stringByAppendingPathComponent:name];
}


- (void) update:(NSArray*) movies {
    [self addPrimaryMovies:movies];
}


- (void) updateMovie:(Movie*) movie {
    [self addPrimaryMovie:movie];
}


- (void) updateMovieDetails:(Movie*) movie {
    NSString* path = [self amazonFile:movie];
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
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupAmazonListings?q=%@", [Application host], [StringUtilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* amazonAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (amazonAddress == nil) {
        return;
    }
    
    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:amazonAddress toFile:path];
    if (amazonAddress.length > 0) {
        [AppDelegate minorRefresh];
    }
}


- (NSString*) amazonAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self amazonFile:movie]];
}

@end