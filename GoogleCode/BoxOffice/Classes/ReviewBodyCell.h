//
//  ReviewBodyCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewBodyCell : UITableViewCell {
    UILabel* label;
}

@property (retain) UILabel* label;

- (void) setReview:(Review*) review;

@end
