//
//  NetflixRatingsCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractMovieDetailsCell.h"
#import "NetflixChangeRatingDelegate.h"
#import "TappableImageViewDelegate.h"

@interface NetflixRatingsCell : AbstractMovieDetailsCell<TappableImageViewDelegate, NetflixChangeRatingDelegate> {
}

- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model
               movie:(Movie*) movie;

@end
