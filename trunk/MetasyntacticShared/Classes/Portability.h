//
//  Portability.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_0
typedef enum {
  UIUserInterfaceIdiomPhone,           // iPhone and iPod touch style UI
  UIUserInterfaceIdiomPad,             // iPad style UI
} UIUserInterfaceIdiom;

typedef enum {
  UIStatusBarAnimationNone,
  UIStatusBarAnimationFade,
  UIStatusBarAnimationSlide,
} UIStatusBarAnimation;

#define UI_USER_INTERFACE_IDIOM() (UIUserInterfaceIdiomPhone)

@interface UIApplication(Portability)

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

@end

#endif
