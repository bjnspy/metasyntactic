//
//  UITableViewCell+Utilities.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef IPHONE_OS_VERSION_3
#import "UITableViewCell+Utilities.h"

@implementation UITableViewCell(UITableViewCellUtilities)
- (id) initWithStyle:(UITableViewCellStyle) style
     reuseIdentifier:(NSString*) reuseIdentifier {
    return [self initWithFrame:[UIScreen mainScreen].bounds
               reuseIdentifier:reuseIdentifier];
}
@end
#endif
