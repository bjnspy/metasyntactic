//
//  AttributeCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttributeCell : UITableViewCell {
    UILabel* keyLabel;
    UILabel* valueLabel;
}

@property (retain) UILabel* keyLabel;
@property (retain) UILabel* valueLabel;

- (void) setKey:(NSString*) key
          value:(NSString*) value
   hasIndicator:(BOOL)hasIndicator;

- (void) setKey:(NSString*) key
          value:(NSString*) value
   hasIndicator:(BOOL)hasIndicator
       keyWidth:(CGFloat) width;

@end
