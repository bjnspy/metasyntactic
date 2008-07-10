//
//  AutoresizingTableViewCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/15/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AutoresizingCell.h"
#import "Application.h"

@implementation AutoresizingCell

@synthesize label;

- (void) dealloc {
    self.label = nil;
    [super dealloc];
}
 
- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        
        label.textAlignment = UITextAlignmentCenter;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:label];    
    }
    
    return self;
}

- (void) layoutSubviews {
    CGRect bounds = self.bounds;
    self.label.frame = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
}

@end
