// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "ReviewTitleCell.h"

#import "BoxOfficeModel.h"
#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Review.h"

@implementation ReviewTitleCell

@synthesize model;
@synthesize authorLabel;
@synthesize scoreLabel;
@synthesize sourceLabel;

- (void) dealloc {
    self.model = nil;
    self.authorLabel = nil;
    self.scoreLabel = nil;
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

        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        [self.contentView addSubview:authorLabel];
        [self.contentView addSubview:sourceLabel];
        [self addSubview:scoreLabel];
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
        CGRect frame = CGRectMake(20, 7, 30, 30);
        if (score == 100) {
            scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        } else {
            scoreLabel.font = [FontCache boldSystem19];
        }

        scoreLabel.textColor = [ColorCache darkDarkGray];
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
