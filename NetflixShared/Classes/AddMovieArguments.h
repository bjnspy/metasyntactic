//
//  AddMovieArguments.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AddMovieArguments : NSObject {
@private
  Queue* queue;
  Movie* movie;
  NSInteger position;
  id<NetflixAddMovieDelegate> delegate;
  NetflixAccount* account;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) Movie* movie;
@property (readonly) NSInteger position;
@property (readonly, retain) id<NetflixAddMovieDelegate> delegate;
@property (readonly, retain) NetflixAccount* account;

+ (AddMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  position:(NSInteger) position
                                  delegate:(id<NetflixAddMovieDelegate>) delegate
                                   account:(NetflixAccount*) account;

@end
