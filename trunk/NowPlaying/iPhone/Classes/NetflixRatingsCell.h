//
//  NetflixRatingsCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractMovieDetailsCell.h"

@interface NetflixRatingsCell : AbstractMovieDetailsCell {
}

- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model
               movie:(Movie*) movie;

@end
