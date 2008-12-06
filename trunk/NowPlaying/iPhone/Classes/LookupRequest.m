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

#import "LookupRequest.h"

@interface LookupRequest()
@property (retain) NSDate* searchDate;
@property (retain) id<DataProviderUpdateDelegate> delegate;
@property (retain) id context;
@property (retain) NSArray* currentMovies;
@property (retain) NSArray* currentTheaters;
@end

@implementation LookupRequest

@synthesize searchDate;
@synthesize delegate;
@synthesize context;
@synthesize currentMovies;
@synthesize currentTheaters;

- (void) dealloc {
    self.searchDate = nil;
    self.delegate = nil;
    self.context = nil;
    self.currentMovies = nil;
    self.currentTheaters = nil;

    [super dealloc];
}


- (id) initWithSearchDate:(NSDate*) searchDate_
                 delegate:(id<DataProviderUpdateDelegate>) delegate_
                 context:(id) context_
            currentMovies:(NSArray*) currentMovies_
          currentTheaters:(NSArray*) currentTheaters_ {
    if (self = [super init]) {
        self.searchDate = searchDate_;
        self.delegate = delegate_;
        self.context = context_;
        self.currentMovies = currentMovies_;
        self.currentTheaters = currentTheaters_;
    }

    return self;
}


+ (LookupRequest*) requestWithSearchDate:(NSDate*) searchDate
                                delegate:(id<DataProviderUpdateDelegate>) delegate
                                context:(id) context
                           currentMovies:(NSArray*) currentMovies
                         currentTheaters:(NSArray*) currentTheaters {
    return [[[LookupRequest alloc] initWithSearchDate:searchDate
                                             delegate:delegate
                                             context:context
                                        currentMovies:currentMovies
                                      currentTheaters:currentTheaters] autorelease];
}

@end