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

@synthesize label;
@synthesize model;

- (void) dealloc {
    self.label = nil;
    self.model = nil;
    [super dealloc];
}

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier 
                    model:(BoxOfficeModel*) aModel {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = aModel;
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:label];
    }
    
    return self;
}

- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}

- (void) setMovie:(Movie*) movie {
    int ratingValue = [self.model rankingForMovie:movie];
    
    if (ratingValue >= 0 && ratingValue <= 100) {
        if (ratingValue >= 60) {
            if (self.image != [Application freshImage]) {
                self.image = [Application freshImage];
                
                label.font = [UIFont boldSystemFontOfSize:15];
                label.textColor = [UIColor whiteColor];
                label.frame = CGRectMake(10, 8, 32, 32);
            }
        } else {
            if (self.image != [Application rottenImage]) {
                self.image = [Application rottenImage];
                
                label.font = [UIFont boldSystemFontOfSize:16];
                label.textColor = [UIColor blackColor];
                label.frame = CGRectMake(8, 7, 30, 32);
            }
        }
        
        label.text = [NSString stringWithFormat:@"%d", ratingValue];
        self.text = movie.title;
    } else {
        label.text = nil;
        self.image = nil;
        self.text = [NSString stringWithFormat:@"N/A  %@", movie.title];
    }
}


@end
