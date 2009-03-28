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
#import "Model.h"
#import "Theater.h"
#import "UITableViewCell+Utilities.h"


@interface TheaterNameCell()
#ifndef IPHONE_OS_VERSION_3
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;
#endif
@end


@implementation TheaterNameCell

#ifndef IPHONE_OS_VERSION_3
@synthesize textLabel;
@synthesize detailTextLabel;
#endif

- (void) dealloc {
#ifndef IPHONE_OS_VERSION_3
    self.textLabel = nil;
    self.detailTextLabel = nil;
#endif
    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier]) {

#ifndef IPHONE_OS_VERSION_3
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 20)] autorelease];
        textLabel.font = [UIFont boldSystemFontOfSize:18];
        textLabel.textColor = [UIColor blackColor];

        self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 0, 14)] autorelease];
        detailTextLabel.font = [UIFont systemFontOfSize:12];
        detailTextLabel.textColor = [UIColor grayColor];

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:detailTextLabel];
#endif

        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumFontSize = 12;
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


#ifndef IPHONE_OS_VERSION_3
- (void) layoutSubviews {
    [super layoutSubviews];

    for (UILabel* label in [NSArray arrayWithObjects:textLabel, detailTextLabel, nil]) {
        CGRect frame = label.frame;
        frame.size.width = MIN(frame.size.width, self.contentView.frame.size.width - frame.origin.x);
        label.frame = frame;
    }
}
#endif


- (void) setTheater:(Theater*) theater {
    if ([self.model isFavoriteTheater:theater]) {
        self.textLabel.text = [NSString stringWithFormat:@"%@ %@", [Application starString], theater.name];
    } else {
        self.textLabel.text = theater.name;
    }

    self.detailTextLabel.text = [self.model simpleAddressForTheater:theater];

#ifndef IPHONE_OS_VERSION_3
    [textLabel sizeToFit];
    [detailTextLabel sizeToFit];
#endif
}


#ifndef IPHONE_OS_VERSION_3
- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        textLabel.textColor = [UIColor whiteColor];
        detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        textLabel.textColor = [UIColor blackColor];
        detailTextLabel.textColor = [UIColor grayColor];
    }
}
#endif

@end