//
//  AttributeCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingCell : UITableViewCell {
    UILabel* valueLabel;
}

@property (retain) UILabel* valueLabel;

- (void) setKey:(NSString*) key
          value:(NSString*) value;

@end
