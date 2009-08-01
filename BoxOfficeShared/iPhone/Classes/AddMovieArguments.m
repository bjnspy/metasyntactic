//
//  MoveMovieArguments.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddMovieArguments.h"

@interface AddMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property NSInteger position;
@property (retain) id<NetflixAddMovieDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation AddMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize position;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.position = 0;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
            position:(NSInteger) position_
            delegate:(id<NetflixAddMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.queue = queue_;
    self.movie = movie_;
    self.position = position_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (AddMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  position:(NSInteger) position
                                  delegate:(id<NetflixAddMovieDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[AddMovieArguments alloc] initWithQueue:queue movie:movie position:position delegate:delegate account:account] autorelease];
}

@end
