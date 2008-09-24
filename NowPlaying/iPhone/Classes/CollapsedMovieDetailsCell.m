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

#import "CollapsedMovieDetailsCell.h"

#import "Movie.h"

@implementation CollapsedMovieDetailsCell

@synthesize ratingAndRuntimeLabel;

- (void) dealloc {
    self.ratingAndRuntimeLabel = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame model:model_ movie:movie_]) {
        self.ratingAndRuntimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        ratingAndRuntimeLabel.font = [UIFont boldSystemFontOfSize:14];
        ratingAndRuntimeLabel.text = movie.ratingAndRuntimeString;
        ratingAndRuntimeLabel.textAlignment = UITextAlignmentCenter;
        [ratingAndRuntimeLabel sizeToFit];

        [self.contentView addSubview:ratingAndRuntimeLabel];

        self.image = [UIImage imageNamed:@"RightDisclosureTriangle.png"];
    }

    return self;
}


- (CGFloat) height:(UITableView*) tableView {
    return tableView.rowHeight - 14;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame = ratingAndRuntimeLabel.frame;
    frame.origin.y = (int)((self.contentView.frame.size.height - frame.size.height) / 2.0);
    frame.origin.x = (int)((self.contentView.frame.size.width - frame.size.width) / 2.0);
    ratingAndRuntimeLabel.frame = frame;
}


@end