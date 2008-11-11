// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TheaterNameCell.h"

#import "Application.h"
#import "NowPlayingModel.h"
#import "Theater.h"

@interface TheaterNameCell()
@property (retain) NowPlayingModel* model;
@property (retain) UILabel* nameLabel;
@property (retain) UILabel* addressLabel;
@end


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
               model:(NowPlayingModel*) model_ {
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

    for (UILabel* label in [NSArray arrayWithObjects:nameLabel, addressLabel, nil]) {
        CGRect frame = label.frame;
        frame.size.width = MIN(frame.size.width, self.contentView.frame.size.width - frame.origin.x);
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

    [nameLabel sizeToFit];
    [addressLabel sizeToFit];
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