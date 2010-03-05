//
//  LogViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AbstractViewController.h"

@interface LogViewController : AbstractViewController {
@private
  NSArray* datesAndLogs;
}

+ (UIViewController*) controller;

@end
