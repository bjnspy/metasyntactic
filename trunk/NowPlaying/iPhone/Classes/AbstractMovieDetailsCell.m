//
//  AbstractMovieDetailsCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 9/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractMovieDetailsCell.h"

@implementation AbstractMovieDetailsCell

@synthesize model;
@synthesize movie;


- (void) dealloc {
    self.model = nil;
    self.movie = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame]) {
        self.model = model_;
        self.movie = movie_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}


- (CGFloat) height:(UITableView*) tableView {
    return tableView.rowHeight;
}

@end
