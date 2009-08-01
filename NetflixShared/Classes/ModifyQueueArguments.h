//
//  ModifyQueueArguments.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ModifyQueueArguments : NSObject {
@private
  Queue* queue;
  NSSet* deletedMovies;
  NSSet* reorderedMovies;
  NSArray* moviesInOrder;
  id<NetflixModifyQueueDelegate> delegate;
  NetflixAccount* account;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) NSSet* deletedMovies;
@property (readonly, retain) NSSet* reorderedMovies;
@property (readonly, retain) NSArray* moviesInOrder;
@property (readonly, retain) id<NetflixModifyQueueDelegate> delegate;
@property (readonly, retain) NetflixAccount* account;

+ (ModifyQueueArguments*) argumentsWithQueue:(Queue*) queue
                             deletedMovies:(NSSet*) deletedMovies
                           reorderedMovies:(NSSet*) reorderedMovies
                                     moviesInOrder:(NSArray*) moviesInOrder
                                  delegate:(id<NetflixModifyQueueDelegate>) delegate
                                   account:(NetflixAccount*) account;

@end
