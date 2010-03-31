//
//  Portability.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "Portability.h"
//
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30200
//
//@implementation UIApplication(Portability)
//
//- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
//  [self setStatusBarHidden:hidden animated:animation != UIStatusBarAnimationNone];
//}
//
//@end
//
//#endif

@implementation Portability

- (void) setStatusBarHidden:(BOOL) hidden
                   animated:(BOOL) animated {
}

- (void) setStatusBarHidden:(BOOL) hidden
              withAnimation:(UIStatusBarAnimation) animation {
}


- (UIUserInterfaceIdiom) userInterfaceIdiom {
  return UIUserInterfaceIdiomPhone;
}


+ (UIUserInterfaceIdiom) userInterfaceIdiom {
  id device = [UIDevice currentDevice];
  if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
    return [device userInterfaceIdiom];
  } else {
    return UIUserInterfaceIdiomPhone;
  }
}


+ (void)setApplicationStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
  id application = [UIApplication sharedApplication];
  if ([application respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
    [application setStatusBarHidden:hidden withAnimation:animation];
  } else {
    [application setStatusBarHidden:hidden animated:animation != UIStatusBarAnimationNone];
  }
}

@end
