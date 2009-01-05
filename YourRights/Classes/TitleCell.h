//
//  TitleCell.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface TitleCell : UITableViewCell {
@private 
    NSString* title;
    UILabel* label;
}

- (id) initWithTitle:(NSString*) title;
+ (CGFloat) height:(NSString*) text;

@end
