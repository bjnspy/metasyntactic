//
//  MoveMovieArguments.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
