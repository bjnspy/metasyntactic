//
//  Portability.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

typedef enum {
  UserInterfaceIdiomPhone,           // iPhone and iPod touch style UI
  UserInterfaceIdiomPad,             // iPad style UI
} UserInterfaceIdiom;

typedef enum {
  StatusBarAnimationNone,
  StatusBarAnimationFade,
  StatusBarAnimationSlide,
} StatusBarAnimation;

@interface Portability : NSObject
{

}

+ (UserInterfaceIdiom) userInterfaceIdiom;
+ (void)setApplicationStatusBarHidden:(BOOL)hidden withAnimation:(StatusBarAnimation)animation;

@end

