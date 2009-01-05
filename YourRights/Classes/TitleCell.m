//
//  TitleCell.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TitleCell.h"

@interface TitleCell()
@property (retain) NSString* title;
@property (retain) UILabel* label;
@end

@implementation TitleCell

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


- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    
    label.frame = CGRectMake(10, 10, frame.size.width - 20, [TitleCell height:title] - 20);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
}


+ (CGFloat) height:(NSString*) title {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    width -= 20; // normal content view
    width -= 10; // the disclosure indicator
    
    CGSize size = CGSizeMake(width, 2000);
    size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20]
            constrainedToSize:size
            lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height + 20;
}


@end
