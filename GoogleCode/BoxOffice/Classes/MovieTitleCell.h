//
//  MovieTitleCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"
#import "BoxOfficeModel.h"

@interface MovieTitleCell : UITableViewCell {
    BoxOfficeModel* model;
    UITableViewStyle style;
    UILabel* scoreLabel;
    UILabel* titleLabel;
    UILabel* ratingLabel;
}

@property (retain) BoxOfficeModel* model;
@property (retain) UILabel* scoreLabel;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* ratingLabel;

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier 
                    model:(BoxOfficeModel*) model 
                    style:(UITableViewStyle) style;

- (void) setMovie:(Movie*) movie;

    
@end
