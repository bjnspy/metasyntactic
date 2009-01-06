//
//  DecisionCell.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DecisionCell.h"

#import "Decision.h"

@interface DecisionCell()
@property (retain) Decision* decision;
@property (retain) UILabel* yearLabel;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* synopsisLabel;
@property (retain) UILabel* categoryLabel;
@end


@implementation DecisionCell

@synthesize decision;
@synthesize yearLabel;
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
 
        
        [self.contentView addSubview:titleLabel];
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
        
    CGRect frame = self.contentView.frame;
    
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size.width = frame.size.width - 10;
    titleLabel.frame = titleFrame;
/*
    
    for (UILabel* label in self.valueLabels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7 + titleWidth + 5);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
 */
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        titleLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.textColor = [UIColor blackColor];
    }
}

- (void) setDecision:(Decision*) decision_ owner:(id) owner {
    self.decision = decision_;
    
    if ([owner sortingByYear]) {
        titleLabel.text = decision.title;
    } else {
        titleLabel.text = [NSString stringWithFormat:@"%@ (%d)", decision.title, decision.year];
    }
    [titleLabel sizeToFit];
    
    [self setNeedsLayout];
}


+ (CGFloat) height:(Decision*) decision {
    return 100;
}

@end