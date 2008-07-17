//
//  ReviewTitleCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewTitleCell : UITableViewCell {
    UILabel* authorLabel;
    UILabel* sourceLabel;
}

@property (retain) UILabel* authorLabel;
@property (retain) UILabel* sourceLabel;

- (void) setReview:(Review*) review;

@end
