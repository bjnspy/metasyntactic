//
//  ReviewTitleCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ReviewTitleCell.h"
#import "Application.h"
#import "ImageCache.h"
#import "FontCache.h"

@implementation ReviewTitleCell

@synthesize model;
@synthesize authorLabel;
@synthesize sourceLabel;
@synthesize scoreLabel;

- (void) dealloc {
    self.model = nil;
    self.scoreLabel = nil;
    self.authorLabel = nil;
    self.sourceLabel = nil;
    
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_
               frame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.authorLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.sourceLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.scoreLabel  = [[[UILabel alloc] initWithFrame:frame] autorelease];
        
        self.authorLabel.font = [UIFont boldSystemFontOfSize:14];
        self.sourceLabel.font = [UIFont systemFontOfSize:12];
        
        scoreLabel.textColor = [UIColor blackColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        
        [self.contentView addSubview:authorLabel];
        [self.contentView addSubview:sourceLabel];
        [self.contentView addSubview:scoreLabel];
    }
    return self;
}

- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}

- (void) setRottenTomatoesImage:(NSInteger) score {
    self.scoreLabel.text = nil;
    self.scoreLabel.frame = CGRectZero;
    if (score >= 60) {
        self.image = [ImageCache freshImage];
    } else {
        self.image = [ImageCache rottenFullImage];
    }    
}

- (void) setMetacriticImage:(NSInteger) score {
    if (score >= 0 && score <= 40) {
        self.image = [ImageCache redRatingImage];
    } else if (score > 40 && score <= 60) {
        self.image = [ImageCache yellowRatingImage];
    } else if (score > 60 && score <= 100) {
        self.image = [ImageCache greenRatingImage];
    } else {
        self.scoreLabel.text = nil;
        self.scoreLabel.frame = CGRectZero;
        self.image = [ImageCache unknownRatingImage];
    } 

    if (score >= 0 && score <= 100) {
        CGRect frame;
        if (score == 100) {
            scoreLabel.font = [UIFont boldSystemFontOfSize:15];
            frame = CGRectMake(10, 6, 30, 30);
        } else {
            scoreLabel.font = [FontCache boldSystem18];
            frame = CGRectMake(10, 7, 30, 30);
        }
        
        scoreLabel.frame = frame;
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
}

- (void) setReviewImage:(Review*) review {
    int score = review.score;
    
    if ([self.model rottenTomatoesRatings]) {
        [self setRottenTomatoesImage:score];
    } else {
        [self setMetacriticImage:score];
    }
}

- (void) setReview:(Review*) review {
    [self setReviewImage:review];
    
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
