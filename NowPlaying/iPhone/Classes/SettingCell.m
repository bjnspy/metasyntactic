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

@interface SettingCell()
@property (retain) UILabel* separatorLine_;
@property (retain) NSString* value_;
@property (retain) NSString* placeholder_;
@end


@implementation SettingCell

@synthesize separatorLine_;
@synthesize value_;
@synthesize placeholder_;

property_wrapper(UILabel*, separatorLine, SeparatorLine);
property_wrapper(NSString*, value, Value);
property_wrapper(NSString*, placeholder, Placeholder);

- (void) dealloc {
    self.separatorLine = nil;
    self.placeholder = nil;
    self.value = nil;

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:reuseIdentifier]) {
        self.separatorLine = [[[UILabel alloc] init] autorelease];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect separatorFrame = CGRectMake(0, -1, self.contentView.frame.size.width, 1);
    self.separatorLine.frame = separatorFrame;
}


- (void) setValueColor {
    if (self.value.length > 0) {
        self.detailTextLabel.textColor = [ColorCache commandColor];
    } else {
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
}


- (void) setCellValue:(NSString*) text {
    self.value = text;

    if (self.value.length > 0) {
        self.detailTextLabel.text = self.value;
    } else {
        self.detailTextLabel.text = self.placeholder;
    }

    [self setValueColor];
}


- (void) setHidesSeparator:(BOOL) hideSeparator {
    [self.separatorLine removeFromSuperview];
    if (hideSeparator) {
        [self.contentView addSubview:self.separatorLine];
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