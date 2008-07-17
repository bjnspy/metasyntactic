//
//  ReviewTitleCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ReviewTitleCell.h"
#import "Application.h"

@implementation ReviewTitleCell

@synthesize authorLabel;
@synthesize sourceLabel;

- (void)dealloc {
    self.authorLabel = nil;
    self.sourceLabel = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.authorLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.sourceLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        
        self.authorLabel.font = [UIFont boldSystemFontOfSize:14];
        self.sourceLabel.font = [UIFont boldSystemFontOfSize:12];
        
        [self.contentView addSubview:authorLabel];
        [self.contentView addSubview:sourceLabel];
    }
    return self;
}

- (void) setReview:(Review*) review {
    if (review.positive && self.image != [Application freshImage]) {
        self.image = [Application freshImage];
    } else if (!review.positive && self.image != [Application rottenFullImage]) {
        self.image = [Application rottenFullImage];
    }
    
    authorLabel.text = review.author;
    sourceLabel.text = review.source;
    
    [authorLabel sizeToFit];
    [sourceLabel sizeToFit];
    
    CGRect frame;
    
    frame = authorLabel.frame;
    frame.origin.y = 5;
    frame.origin.x = 50;
    authorLabel.frame = frame;
    
    frame = sourceLabel.frame;
    frame.origin.y = 23;
    frame.origin.x = 50;
    sourceLabel.frame = frame;    
}


@end
