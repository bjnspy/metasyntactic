//
//  LogViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LogViewController.h"

#import "Logger.h"
#import "MetasyntacticSharedApplication.h"
#import "NSArray+Utilities.h"


@interface LogViewController()
@end


@implementation LogViewController

- (void) dealloc {
  [super dealloc];
}


+ (UIViewController*) controller {
  return [[[LogViewController alloc] init] autorelease];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Logs", nil);
  }
  
  return self;
}


- (void) loadView {
  [super loadView];
  
  NSString* logs = [Logger logs];
  if (logs.length == 0) {
    logs = LocalizedString(@"No Logs", nil);
  }

  UITextView* textView = [[[UITextView alloc] initWithFrame:self.view.bounds] autorelease];
  textView.editable = NO;
  textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  textView.text = logs;
  textView.textColor = [UIColor darkGrayColor];
  textView.font = [UIFont boldSystemFontOfSize:12];

  [self.view addSubview:textView];  
}

@end
