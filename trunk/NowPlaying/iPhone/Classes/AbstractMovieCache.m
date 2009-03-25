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

#import "AbstractMovieCache.h"

#import "AppDelegate.h"
#import "OperationQueue.h"

@interface AbstractMovieCache()
@property (retain) NSMutableSet* updatedMovies_;
@end


@implementation AbstractMovieCache

@synthesize updatedMovies_;

property_wrapper(NSMutableSet*, updatedMovies, UpdatedMovies);

- (void) dealloc {
    self.updatedMovies = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.updatedMovies = [NSMutableSet set];
    }

    return self;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearUpdatedMovies];
}


- (void) clearUpdatedMovies {
    [gate lock];
    {
        [self.updatedMovies removeAllObjects];
    }
    [gate unlock];
}


- (BOOL) checkMovie:(Movie*) movie {
    BOOL result;
    [gate lock];
    {
        if (![self.updatedMovies containsObject:movie]) {
            [self.updatedMovies addObject:movie];
            result = NO;
        } else {
            result = YES;
        }
    }
    [gate unlock];
    return result;
}


- (void) updateMovieDetails:(Movie*) movie {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) processMovie:(Movie*) movie {
    if ([self checkMovie:movie]) {
        return;
    }

    [self updateMovieDetails:movie];
}

@end