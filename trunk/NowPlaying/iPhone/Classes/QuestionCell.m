//
//  QuestionCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuestionCell.h"

#import "UITableViewCell+Utilities.h"

@interface QuestionCell()
@property (retain) UILabel* contentLabel;
@end


@implementation QuestionCell

@synthesize contentLabel;

- (void) dealloc {
    self.contentLabel = nil;
    [super dealloc];
}


+ (UIFont*) contentFont {
    return [UIFont systemFontOfSize:16];
}


- (id) initWithQuestion:(BOOL) question_
        reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        question = question_;
        self.backgroundColor = [UIColor colorWithRed:219.0/256.0 green:226.0/256.0 blue:237.0/256.0 alpha:1];

        self.contentLabel = [[[UILabel alloc] init] autorelease];
        contentLabel.font = [QuestionCell contentFont];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        contentLabel.backgroundColor = [UIColor clearColor];
        [contentLabel sizeToFit];

        [self.contentView addSubview:contentLabel];

        if (question) {
            UIImage* image = [UIImage imageNamed:@"QuestionBalloon.png"];
            UIImage* stretchedImage = [image stretchableImageWithLeftCapWidth:25 topCapHeight:18];
            self.backgroundView = [[[UIImageView alloc] initWithImage:stretchedImage] autorelease];
        } else {
            UIImage* image = [UIImage imageNamed:@"AnswerBalloon.png"];
            UIImage* stretchedImage = [image stretchableImageWithLeftCapWidth:25 topCapHeight:18];
            self.backgroundView = [[[UIImageView alloc] initWithImage:stretchedImage] autorelease];
        }

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}


- (void) setText:(NSString*) text {
    contentLabel.text = text;
}


+ (CGFloat) height:(BOOL) question text:(NSString*) text {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    width -= 50;

    CGSize contentSize = [text sizeWithFont:[self contentFont]
                          constrainedToSize:CGSizeMake(width, 2000)
                              lineBreakMode:UILineBreakModeWordWrap];

    return contentSize.height + 4 + 8;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGFloat height = [QuestionCell height:question text:contentLabel.text];

    CGRect contentFrame = contentLabel.frame;
    contentFrame.origin.y = 4;
    contentFrame.origin.x = question ? 15 : 20;
    contentFrame.size.width = self.contentView.frame.size.width - 30;
    contentFrame.size.height = height - 12;

    contentLabel.frame = contentFrame;
}

@end