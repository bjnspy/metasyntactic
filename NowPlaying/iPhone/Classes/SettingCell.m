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

#import "SettingCell.h"

#import "ColorCache.h"
//#import "UITableViewCell+Utilities.h"


@interface SettingCell()
@property (retain) UILabel* separatorLine;
@property (copy) NSString* value;
#ifndef IPHONE_OS_VERSION_3
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;
#endif
@end


@implementation SettingCell

@synthesize separatorLine;
@synthesize value;
@synthesize placeholder;
#ifndef IPHONE_OS_VERSION_3
@synthesize textLabel;
@synthesize detailTextLabel;
#endif

- (void) dealloc {
    self.separatorLine = nil;
    self.placeholder = nil;
    self.value = nil;
#ifndef IPHONE_OS_VERSION_3
    self.textLabel = nil;
    self.detailTextLabel = nil;
#endif

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:reuseIdentifier]) {
        self.separatorLine = [[[UILabel alloc] init] autorelease];

#ifndef IPHONE_OS_VERSION_3
        self.textLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        textLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:textLabel];

        self.detailTextLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        detailTextLabel.textColor = [ColorCache commandColor];
        detailTextLabel.adjustsFontSizeToFitWidth = YES;
        detailTextLabel.minimumFontSize = 12;
        [self.contentView addSubview:detailTextLabel];
#endif
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect separatorFrame = CGRectMake(0, -1, self.contentView.frame.size.width, 1);
    separatorLine.frame = separatorFrame;

#ifndef IPHONE_OS_VERSION_3
    [textLabel sizeToFit];
    [detailTextLabel sizeToFit];

    CGRect frame = detailTextLabel.frame;
    frame.origin.y = floor((self.contentView.frame.size.height - frame.size.height) / 2);
    frame.origin.x = self.contentView.frame.size.width - frame.size.width;
    frame.size.width = MIN(frame.size.width,
                           self.contentView.frame.size.width - frame.origin.x);

    if (self.accessoryType == UITableViewCellAccessoryNone) {
        frame.origin.x -= 10;
    }

    detailTextLabel.frame = frame;

    frame = textLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = floor((self.contentView.frame.size.height - frame.size.height) / 2);
    textLabel.frame = frame;

    [self.contentView bringSubviewToFront:detailTextLabel];
#endif
}


- (void) setValueColor {
    if (value.length > 0) {
        self.detailTextLabel.textColor = [ColorCache commandColor];
    } else {
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
}


- (void) setCellValue:(NSString*) text {
    self.value = text;

    if (value.length > 0) {
        self.detailTextLabel.text = value;
    } else {
        self.detailTextLabel.text = placeholder;
    }

    [self setValueColor];
}


- (void) setHidesSeparator:(BOOL) hideSeparator {
    [separatorLine removeFromSuperview];
    if (hideSeparator) {
        [self.contentView addSubview:separatorLine];
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        [self setValueColor];
    }
}

@end