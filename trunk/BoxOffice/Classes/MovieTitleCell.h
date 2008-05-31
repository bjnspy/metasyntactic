//
//  MovieTitleCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"

@interface MovieTitleCell : UITableViewCell {
    UILabel* label;
}

@property (retain) UILabel* label;

- (void) setMovie:(Movie*) movie;

@end
