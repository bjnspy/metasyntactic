//
//  AbstracPosterCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

typedef enum {
    Loading,
    NotFound,
    Loaded
} ImageState;


@interface AbstractPosterCell : UITableViewCell {
@protected
    NowPlayingModel* model;
    Movie* movie;

    ImageState state;
    UIImageView* imageLoadingView;
    UIImageView* imageView;

    UIActivityIndicatorView* activityView;
}

@property (retain) Movie* movie;

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_;

- (void) loadImage;
- (void) clearImage;

@end
