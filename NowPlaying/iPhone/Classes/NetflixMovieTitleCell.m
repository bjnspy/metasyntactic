//
//  NetflixMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixMovieTitleCell.h"


@implementation NetflixMovieTitleCell

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_
               style:(UITableViewStyle) style_ {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier
                              model:model_
                              style:style_]) {
    }
    
    return self;
}


- (void) setScore:(Movie*) movie {
}


- (BOOL) noScores {
    return YES;
}

@end
