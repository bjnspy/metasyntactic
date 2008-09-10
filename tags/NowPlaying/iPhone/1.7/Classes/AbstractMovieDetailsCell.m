// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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