//
//  AbstractImageCell.h
//  PocketFlix
//
//  Created by Cyrus Najmabadi on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

typedef enum {
    Loading,
    NotFound,
    Loaded
} ImageState;


@interface AbstractImageCell : UITableViewCell {
@protected
    Model* model;
    
    ImageState state;
    UIImageView* imageLoadingView;
    UIImageView* imageView;
    
    UIActivityIndicatorView* activityView;
    
    UILabel* titleLabel;
    CGFloat titleWidth;
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_;

- (void) loadImage;
- (void) clearImage;

// @protected
- (NSArray*) allLabels;

- (UILabel*) createTitleLabel:(NSString*) title yPosition:(NSInteger) yPosition;
- (UILabel*) createValueLabel:(NSInteger) yPosition forTitle:(UILabel*) titleLabel;

@end
