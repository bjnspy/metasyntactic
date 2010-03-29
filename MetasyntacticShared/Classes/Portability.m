//
//  Portability.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Portability.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30200

@implementation UIApplication(Portability)

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
  [self setStatusBarHidden:hidden animated:animation != UIStatusBarAnimationNone];
}

@end

#endif
