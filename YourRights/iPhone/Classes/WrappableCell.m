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

#import "WrappableCell.h"

@interface WrappableCell()
@property (retain) NSString* title;
@property (retain) UILabel* label;
@end

@implementation WrappableCell

@synthesize title;
@synthesize label;

- (void)dealloc {
    self.title = nil;
    self.label = nil;

    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ {
    if (self = [super initWithFrame:CGRectZero]) {
        self.title = title_;

        self.label = [[[UILabel alloc] init] autorelease];
        label.text = title;
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.font = [UIFont boldSystemFontOfSize:20];

        [self.contentView addSubview:label];
    }

    return self;
}


- (void) setFont:(UIFont*) font {
    label.font = font;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;

    CGFloat height =  [WrappableCell height:title accessoryType:self.accessoryType font:label.font] - 20;
    label.frame = CGRectMake(10, 10, frame.size.width - 20, height);
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected && self.selectionStyle != UITableViewCellSelectionStyleNone) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
}


+ (CGFloat)  height:(NSString*) text
      accessoryType:(UITableViewCellAccessoryType) accessoryType
               font:(UIFont*) font {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    width -= 20; // normal content view

    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        width -= 10;
    }

    CGSize size = CGSizeMake(width, 20000);
    size = [text sizeWithFont:font
            constrainedToSize:size
                lineBreakMode:UILineBreakModeWordWrap];

    return size.height + 20;
}


+ (CGFloat) height:(NSString*) text accessoryType:(UITableViewCellAccessoryType) accessoryType {
    return [self height:text accessoryType:accessoryType font:[UIFont boldSystemFontOfSize:20]];
}


@end