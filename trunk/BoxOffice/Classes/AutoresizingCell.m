//
//  AutoresizingTableViewCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AutoresizingCell.h"
#import "Application.h"

@implementation AutoresizingCell

@synthesize label;

- (void)dealloc {
    self.label = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code

        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
        
        label.textAlignment = UITextAlignmentCenter;        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:label];    
    }
    
    return self;
}

@end
