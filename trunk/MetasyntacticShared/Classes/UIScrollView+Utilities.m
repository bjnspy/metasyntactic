//
//  UITableView+Utilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIScrollView+Utilities.h"

@implementation UIScrollView(Utilities)

- (BOOL) isMoving {
  return self.dragging || self.decelerating || self.tracking;
}

@end
