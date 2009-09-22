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

#import "ChangeRatingArguments.h"

@interface ChangeRatingArguments()
@property (copy) NSString* rating;
@property (retain) Movie* movie;
@property (retain) id<NetflixChangeRatingDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation ChangeRatingArguments

@synthesize rating;
@synthesize movie;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.rating = nil;
  self.movie = nil;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithRating:(NSString*) rating_
               movie:(Movie*) movie_
            delegate:(id<NetflixChangeRatingDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.rating = rating_;
    self.movie = movie_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (ChangeRatingArguments*) argumentsWithRating:(NSString*) rating
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixChangeRatingDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[ChangeRatingArguments alloc] initWithRating:rating movie:movie delegate:delegate account:account] autorelease];
}

@end
