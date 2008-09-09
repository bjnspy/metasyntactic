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

#import "ColorCache.h"
#import "Movie.h"

@implementation CollapsedMovieDetailsCell

@synthesize ratingAndRuntimeLabel;
@synthesize clickToExpandLabel;

- (void) dealloc {
    self.ratingAndRuntimeLabel = nil;
    self.clickToExpandLabel = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame model:model_ movie:movie_]) {
        self.ratingAndRuntimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 4, 0, 0)] autorelease];
        ratingAndRuntimeLabel.font = [UIFont boldSystemFontOfSize:14];
        ratingAndRuntimeLabel.text = movie.ratingAndRuntimeString;
        ratingAndRuntimeLabel.textAlignment = UITextAlignmentCenter;
        [ratingAndRuntimeLabel sizeToFit];

        self.clickToExpandLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 24, 0, 0)] autorelease];
        clickToExpandLabel.font = [UIFont systemFontOfSize:10];
        clickToExpandLabel.textColor = [ColorCache commandColor];
        clickToExpandLabel.textAlignment = UITextAlignmentCenter;
        clickToExpandLabel.text = NSLocalizedString(@"tap for more details", nil);
        [clickToExpandLabel sizeToFit];

        [self.contentView addSubview:ratingAndRuntimeLabel];
        [self.contentView addSubview:clickToExpandLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame;

    frame = ratingAndRuntimeLabel.frame;
    frame.origin.x = (int)((self.contentView.frame.size.width - frame.size.width) / 2);
    ratingAndRuntimeLabel.frame = frame;

    frame = clickToExpandLabel.frame;
    frame.origin.x = (int)((self.contentView.frame.size.width - frame.size.width) / 2);
    clickToExpandLabel.frame = frame;
}


@end
