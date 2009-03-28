//
//  UITableViewCell+Utilities.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef IPHONE_OS_VERSION_3
typedef enum {
    UITableViewCellStyleDefault,
    UITableViewCellStyleSubtitle,
    UITableViewCellStyleValue1,
    UITableViewCellStyleValue2,
} UITableViewCellStyle;

@interface UITableViewCell(UITableViewCellUtilities)
- (id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString*) reuseIdentifier;
@end
#endif