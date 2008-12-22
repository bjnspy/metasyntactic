//
//  NetflixCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractPosterCell.h"

@interface NetflixCell : AbstractPosterCell {
@private
    UILabel* directorTitleLabel;
    UILabel* castTitleLabel;
    UILabel* genreTitleLabel;
    UILabel* ratedTitleLabel;
    UILabel* netflixTitleLabel;
    
    UILabel* directorLabel;
    UILabel* castLabel;
    UILabel* genreLabel;
    UILabel* ratedLabel;
    UILabel* netflixLabel;

    BOOL userRating;
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model;

@end
