//
//  MetasyntacticStockImages.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MetasyntacticStockImages.h"


@implementation MetasyntacticStockImages

static UIImage* leftArrow;
static UIImage* rightArrow;
static UIImage* navigateBack;
static UIImage* navigateForward;

+ (void) initialize {
  if (self == [MetasyntacticStockImages class]) {
    leftArrow = [[UIImage imageNamed:@"LeftArrow.png"] retain];
    rightArrow = [[UIImage imageNamed:@"RightArrow.png"] retain];
    navigateBack = [[UIImage imageNamed:@"Navigate-Back.png"] retain];
    navigateForward = [[UIImage imageNamed:@"Navigate-Forward.png"] retain];
  }
}


+ (UIImage*) leftArrow {
  return leftArrow;
}


+ (UIImage*) rightArrow {
  return rightArrow;
}


+ (UIImage*) navigateBack {
  return navigateBack;
}


+ (UIImage*) navigateForward {
  return navigateForward;
}

@end
