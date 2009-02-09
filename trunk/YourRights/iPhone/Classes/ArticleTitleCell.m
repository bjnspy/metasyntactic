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

#import "ArticleTitleCell.h"

#import "Item.h"

@interface ArticleTitleCell()
@property (retain) Model* model;
@property (retain) UILabel* titleLabel;
@end

@implementation ArticleTitleCell

@synthesize model;
@synthesize titleLabel;

- (void) dealloc {
    self.model = nil;
    self.titleLabel = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_
               frame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.numberOfLines = 0;

        [self.contentView addSubview:titleLabel];
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect contentFrame = self.contentView.frame;

    CGRect frame;

    frame = titleLabel.frame;
    frame.size.width = contentFrame.size.width - 16;
    frame.size.height = contentFrame.size.height - 10;
    titleLabel.frame = frame;
}


- (void) setItem:(Item*) item {
    titleLabel.text = item.title;

    CGRect frame;

    frame = titleLabel.frame;
    frame.origin.y = 7;
    frame.origin.x = 8;
    titleLabel.frame = frame;
}

@end