//
//  NetflixMovieTitleCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieTitleCell.h"

@interface NetflixMovieTitleCell : MovieTitleCell {
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model
               style:(UITableViewStyle) style;

@end