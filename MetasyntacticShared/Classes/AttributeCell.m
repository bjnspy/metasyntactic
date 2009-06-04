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

#import "AttributeCell.h"

#import "ColorCache.h"

@interface AttributeCell()
#ifndef IPHONE_OS_VERSION_3
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;
#endif
@end


@implementation AttributeCell

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

+ (UIFont*) keyFont {
    return [UIFont boldSystemFontOfSize:12.0];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
#ifndef IPHONE_OS_VERSION_3
    if ((self = [super initWithFrame:[UIScreen mainScreen].bounds
                    reuseIdentifier:reuseIdentifier])) {
        self.textLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.detailTextLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];

        textLabel.textColor = [ColorCache commandColor];
        textLabel.font = [AttributeCell keyFont];
        textLabel.textAlignment = UITextAlignmentRight;

        detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
        detailTextLabel.adjustsFontSizeToFitWidth = YES;
        detailTextLabel.minimumFontSize = 10.0;

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:detailTextLabel];
    }

    return self;
#else
    if ((self = [super initWithStyle:UITableViewCellStyleValue2
                    reuseIdentifier:reuseIdentifier])) {
    }
    return self;
#endif
}


#ifndef IPHONE_OS_VERSION_3
- (void) layoutSubviews {
    [super layoutSubviews];

    [textLabel sizeToFit];
    [detailTextLabel sizeToFit];

    {
        CGRect frame = textLabel.frame;
        frame.origin.y = floor((self.contentView.frame.size.height - textLabel.frame.size.height) / 2);
        frame.size.width = 60;
        textLabel.frame = frame;
    }

    {
        CGRect frame = detailTextLabel.frame;
        frame.origin.y = floor((self.contentView.frame.size.height - detailTextLabel.frame.size.height) / 2);
        frame.origin.x = 70;
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        detailTextLabel.frame = frame;
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        textLabel.textColor = [UIColor whiteColor];
        detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        textLabel.textColor = [ColorCache commandColor];
        detailTextLabel.textColor = [UIColor blackColor];
    }
}
#endif

@end
