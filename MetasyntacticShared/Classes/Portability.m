//
//  Portability.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@implementation Portability

- (void) setStatusBarHidden:(BOOL) hidden
                   animated:(BOOL) animated {
}

- (void) setStatusBarHidden:(BOOL) hidden
              withAnimation:(StatusBarAnimation) animation {
}


- (UserInterfaceIdiom) userInterfaceIdiom {
  return UserInterfaceIdiomPhone;
}


+ (UserInterfaceIdiom) userInterfaceIdiom {
  id device = [UIDevice currentDevice];
  if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
    return [device userInterfaceIdiom];
  } else {
    return UserInterfaceIdiomPhone;
  }
}


+ (void)setApplicationStatusBarHidden:(BOOL)hidden
                        withAnimation:(StatusBarAnimation)animation {
  id application = [UIApplication sharedApplication];
  if ([application respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
    [application setStatusBarHidden:hidden withAnimation:animation];
  } else {
    [application setStatusBarHidden:hidden animated:animation != StatusBarAnimationNone];
  }
}

@end
