//
//  MoveMovieArguments.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface MoveMovieArguments : NSObject {
@private
  Queue* queue;
  Movie* movie;
  id<NetflixMoveMovieDelegate> delegate;
  NetflixAccount* account;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) Movie* movie;
@property (readonly, retain) id<NetflixMoveMovieDelegate> delegate;
@property (readonly, retain) NetflixAccount* account;

+ (MoveMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixMoveMovieDelegate>) delegate
                                   account:(NetflixAccount*) account;

@end
