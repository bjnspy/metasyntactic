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
    UILabel* label;
}

@property (retain) BoxOfficeModel* model;
@property (retain) UILabel* label;

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier 
                    model:(BoxOfficeModel*) model;

- (void) setMovie:(Movie*) movie;

@end
