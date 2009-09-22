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
@property BOOL force;
@property (retain) NSArray* currentMovies;
@property (retain) NSArray* currentTheaters;
@end

@implementation LookupRequest

@synthesize searchDate;
@synthesize delegate;
@synthesize context;
@synthesize force;
@synthesize currentMovies;
@synthesize currentTheaters;

- (void) dealloc {
  self.searchDate = nil;
  self.delegate = nil;
  self.context = nil;
  self.force = NO;
  self.currentMovies = nil;
  self.currentTheaters = nil;

  [super dealloc];
}


- (id) initWithSearchDate:(NSDate*) searchDate__
                 delegate:(id<DataProviderUpdateDelegate>) delegate__
                  context:(id) context__
                    force:(BOOL) force__
            currentMovies:(NSArray*) currentMovies__
          currentTheaters:(NSArray*) currentTheaters__ {
  if ((self = [super init])) {
    self.searchDate = searchDate__;
    self.delegate = delegate__;
    self.context = context__;
    self.force = force__;
    self.currentMovies = currentMovies__;
    self.currentTheaters = currentTheaters__;
  }

  return self;
}


+ (LookupRequest*) requestWithSearchDate:(NSDate*) searchDate
                                delegate:(id<DataProviderUpdateDelegate>) delegate
                                 context:(id) context
                                   force:(BOOL) force
                           currentMovies:(NSArray*) currentMovies
                         currentTheaters:(NSArray*) currentTheaters {
  return [[[LookupRequest alloc] initWithSearchDate:searchDate
                                           delegate:delegate
                                            context:context
                                              force:force
                                      currentMovies:currentMovies
                                    currentTheaters:currentTheaters] autorelease];
}

@end
