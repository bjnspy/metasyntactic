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

#import "DecisionCell.h"

#import "Decision.h"
#import "GreatestHitsViewController.h"

@interface DecisionCell()
@property (retain) Decision* decision;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* synopsisLabel;
@property (retain) UILabel* categoryLabel;
@end


@implementation DecisionCell

@synthesize decision;
@synthesize titleLabel;
@synthesize synopsisLabel;
@synthesize categoryLabel;

- (void)dealloc {
    self.decision = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 0, 20)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.synopsisLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 26, 0, 12)] autorelease];
        synopsisLabel.font = [UIFont systemFontOfSize:12];
        synopsisLabel.textColor = [UIColor darkGrayColor];
        synopsisLabel.numberOfLines = 0;
        synopsisLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        self.categoryLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        categoryLabel.font = [UIFont systemFontOfSize:12];
        categoryLabel.textColor = [UIColor darkGrayColor];
        categoryLabel.textAlignment = UITextAlignmentRight;
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:synopsisLabel];
        [self.contentView addSubview:categoryLabel];
    }
    return self;
}


+ (CGFloat) width:(Decision*) decision {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    width -= 35;
    
    return width;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [DecisionCell width:decision];

    CGRect titleFrame = titleLabel.frame;
    titleFrame.size.width = width;
    titleLabel.frame = titleFrame;
    
    CGSize size = [synopsisLabel.text sizeWithFont:synopsisLabel.font constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:synopsisLabel.lineBreakMode];
    CGRect synopsisFrame = synopsisLabel.frame;
    synopsisFrame.size = size;
    synopsisLabel.frame = synopsisFrame;
    
    CGRect categoryFrame = categoryLabel.frame;
    categoryFrame.origin.y = synopsisFrame.origin.y + synopsisFrame.size.height;
    categoryFrame.size.width = width;
    categoryLabel.frame = categoryFrame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        titleLabel.textColor = [UIColor whiteColor];
        synopsisLabel.textColor = [UIColor whiteColor];
        categoryLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.textColor = [UIColor blackColor];
        synopsisLabel.textColor = [UIColor darkGrayColor];
        categoryLabel.textColor = [UIColor darkGrayColor];
    }
}

- (void) setDecision:(Decision*) decision_ owner:(GreatestHitsViewController*) owner {
    self.decision = decision_;
    
    if ([owner sortingByCategory]) {
        categoryLabel.text = @"";
    } else {
        categoryLabel.text = [Decision categoryString:decision.category];
    }
    [categoryLabel sizeToFit];
    
    synopsisLabel.text = decision.synopsis;
    
    if ([owner sortingByYear]) {
        titleLabel.text = decision.title;
    } else {
        titleLabel.text = [NSString stringWithFormat:@"%@ (%d)", decision.title, decision.year];
    }
    [titleLabel sizeToFit];
    
    [self setNeedsLayout];
}



+ (CGFloat) height:(Decision*) decision owner:(GreatestHitsViewController*) owner {
    CGFloat width = [self width:decision];
    CGSize size = [decision.synopsis sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = 26/*top of title */ + size.height + 4/*+2 on the top and bottom*/;
    if (![owner sortingByCategory]) {
        height += 14/*categoryLabel*/;
    }
    
    return height;
}

@end