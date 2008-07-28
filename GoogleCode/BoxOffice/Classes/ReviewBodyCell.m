//
//  ReviewBodyCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ReviewBodyCell.h"
#import "Application.h"
#import "FontCache.h"

@implementation ReviewBodyCell

@synthesize label;

- (void) dealloc {
    self.label = nil;

    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.label.font = [FontCache helvetica14];
        self.label.lineBreakMode = UILineBreakModeWordWrap;
        self.label.numberOfLines = 0;

        [self.contentView addSubview:label];
    }
    return self;
}

- (void) setReview:(Review*) review {
    CGRect rect = CGRectMake(10, 5, review.link ? 255 : 285, [review heightWithFont:[FontCache helvetica14]] - 10);
    self.label.frame = rect;
    self.label.text = review.text;
}

@end
