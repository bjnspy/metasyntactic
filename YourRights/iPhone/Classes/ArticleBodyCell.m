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

#import "ArticleBodyCell.h"

#import "FontCache.h"
#import "Item.h"
#import "Utilities.h"

@interface ArticleBodyCell()
@property (retain) Item* item;
@property (retain) UILabel* label;
@end


@implementation ArticleBodyCell

@synthesize item;
@synthesize label;

- (void) dealloc {
    self.item = nil;
    self.label = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        label.font = [FontCache helvetica14];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;

        [self.contentView addSubview:label];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    label.text = item.description;

    double width = self.frame.size.width;
    width -= 40;
    if (item.link.length != 0) {
        width -= 25;
    }

    CGRect rect = CGRectMake(10, 5, width, [ArticleBodyCell height:item] - 10);
    label.frame = rect;
}


+ (CGFloat) height:(Item*) item {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    width -= 40;
    if (item.link.length != 0) {
        width -= 25;
    }

    CGSize size = CGSizeMake(width, 2000);
    size = [item.description sizeWithFont:[FontCache helvetica14]
            constrainedToSize:size
            lineBreakMode:UILineBreakModeWordWrap];

    return size.height + 10;
}

@end