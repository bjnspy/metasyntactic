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

#import "TheaterNameCell.h"

#import "Application.h"
#import "NowPlayingModel.h"
#import "Theater.h"

@implementation TheaterNameCell

@synthesize model;
@synthesize nameLabel;
@synthesize addressLabel;

- (void) dealloc {
    self.model = nil;
    self.nameLabel = nil;
    self.addressLabel = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(BoxOfficeModel*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;

        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 20)] autorelease];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumFontSize = 14;
        nameLabel.textColor = [UIColor blackColor];

        self.addressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 0, 14)] autorelease];
        addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.textColor = [UIColor grayColor];

        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:addressLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    for (UILabel* label in [NSArray arrayWithObjects:self.nameLabel, self.addressLabel, nil]) {
        CGRect frame = label.frame;
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}


- (void) setTheater:(Theater*) theater {
    if ([model isFavoriteTheater:theater]) {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", [Application starString], theater.name];
    } else {
        nameLabel.text = theater.name;
    }

    addressLabel.text = [model simpleAddressForTheater:theater];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        nameLabel.textColor = [UIColor whiteColor];
        addressLabel.textColor = [UIColor whiteColor];
    } else {
        nameLabel.textColor = [UIColor blackColor];
        addressLabel.textColor = [UIColor grayColor];
    }
}


@end
