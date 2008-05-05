//
//  MovieTitleAndRatingTableViewCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTitleAndRatingTableViewCell : UITableViewCell {
    Movie* movie;
    
    UIImageView* imageView;
    UILabel* label;
}

@property (retain) Movie* movie;
@property (retain) UIImageView* imageView;
@property (retain) UILabel* label;

- (id) initWithFrame:(CGRect) frame
               movie:(Movie*) movie_;

@end
