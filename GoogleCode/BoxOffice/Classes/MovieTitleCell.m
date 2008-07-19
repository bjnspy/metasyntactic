//
//  MovieTitleCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieTitleCell.h"
#import "Application.h"

@implementation MovieTitleCell

@synthesize scoreLabel;
@synthesize titleLabel;
@synthesize ratingLabel;
@synthesize model;

- (void) dealloc {
    self.scoreLabel = nil;
    self.titleLabel = nil;
    self.ratingLabel = nil;
    self.model = nil;
    
    [super dealloc];
}

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier 
                    model:(BoxOfficeModel*) model_ 
                    style:(UITableViewStyle) style_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        style = style_;
        
        self.scoreLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 16;
        titleLabel.textColor = [UIColor blackColor];
        
        self.ratingLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        ratingLabel.font = [UIFont systemFontOfSize:12];
        ratingLabel.textColor = [UIColor grayColor];
        
        {
            CGRect frame = CGRectMake(50, 25, 250, 12);
            
            if (style == UITableViewStyleGrouped) {
                frame.origin.x += 10;
                frame.size.width -= 20;
            }
            
            self.ratingLabel.frame = frame;
            
            frame.origin.y = 5;
            frame.size.height = 20;
            self.titleLabel.frame = frame;
        }
        
        [self addSubview:titleLabel];
        [self addSubview:scoreLabel];
        [self addSubview:ratingLabel];
    }
    
    return self;
}

- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}

- (void) setMovie:(Movie*) movie {
    
    int score = [self.model scoreForMovie:movie];
    
    if (score >= 0 && score <= 100) {
        if (score >= 60) {
            if (self.image != [Application freshImage]) {
                self.image = [Application freshImage];
                
                scoreLabel.font = [UIFont boldSystemFontOfSize:15];
                scoreLabel.textColor = [UIColor whiteColor];
                
                CGRect frame = CGRectMake(10, 8, 32, 32);
                if (style == UITableViewStyleGrouped) {
                    frame.origin.x += 10;
                }
                
                scoreLabel.frame = frame;
            }
        } else {
            if (self.image != [Application rottenFadedImage]) {
                self.image = [Application rottenFadedImage];
                
                scoreLabel.font = [UIFont boldSystemFontOfSize:17];
                scoreLabel.textColor = [UIColor blackColor];
                
                CGRect frame = CGRectMake(9, 6, 30, 32);
                if (style == UITableViewStyleGrouped) {
                    frame.origin.x += 10;
                }
                
                scoreLabel.frame = frame;
            }
        }
        
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    } else {
        self.scoreLabel.text = nil;
        self.image = [Application unknownImage];
    }
    
    self.ratingLabel.text = [movie ratingAndRuntimeString];
    self.titleLabel.text = movie.title;
}

- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        ratingLabel.textColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.textColor = [UIColor blackColor];
        ratingLabel.textColor = [UIColor grayColor];
    }
}


@end
