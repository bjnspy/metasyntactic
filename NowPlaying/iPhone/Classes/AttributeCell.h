//
//  AttributeCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef IPHONE_OS_VERSION_3
@interface AttributeCell : UITableViewCell {
@private
    UILabel* textLabel;
    UILabel* detailTextLabel;
}

@property (readonly, retain) UILabel* textLabel;
@property (readonly, retain) UILabel* detailTextLabel;

@end
#endif