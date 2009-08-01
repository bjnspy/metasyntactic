//
//  MoveMovieArguments.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MoveMovieArguments.h"

@interface MoveMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property (retain) id<NetflixMoveMovieDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation MoveMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
            delegate:(id<NetflixMoveMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.queue = queue_;
    self.movie = movie_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (MoveMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixMoveMovieDelegate>) delegate
                                    account:(NetflixAccount*) account {
  return [[[MoveMovieArguments alloc] initWithQueue:queue movie:movie delegate:delegate account:account] autorelease];
}

@end
