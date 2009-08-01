//
//  ChangeRatingArguments.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ChangeRatingArguments : NSObject {
@private
  NSString* rating;
  Movie* movie;
  id<NetflixChangeRatingDelegate> delegate;
  NetflixAccount* account;
}

@property (readonly, copy) NSString* rating;
@property (readonly, retain) Movie* movie;
@property (readonly, retain) id<NetflixChangeRatingDelegate> delegate;
@property (readonly, retain) NetflixAccount* account;

+ (ChangeRatingArguments*) argumentsWithRating:(NSString*) rating
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixChangeRatingDelegate>) delegate
                                   account:(NetflixAccount*) account;

@end
