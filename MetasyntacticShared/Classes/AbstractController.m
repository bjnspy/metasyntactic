//
//  AbstractController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractController.h"

#import "AbstractApplication.h"
#import "AbstractModel.h"
#import "MetasyntacticSharedApplication.h"

@implementation AbstractController

- (void) start:(AbstractModel*) model {
  [model tryShowWriteReviewRequest];
}

@end
