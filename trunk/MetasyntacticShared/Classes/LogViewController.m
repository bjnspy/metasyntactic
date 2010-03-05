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
@property (retain) NSArray* datesAndLogs;
@end


@implementation LogViewController

@synthesize datesAndLogs;

- (void) dealloc {
  self.datesAndLogs = nil;
  [super dealloc];
}


+ (UIViewController*) controller {
  return [[[LogViewController alloc] init] autorelease];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Logs", nil);
    self.datesAndLogs = [Logger datesAndLogs];
  }
  
  return self;
}


- (void) loadView {
  [super loadView];
  
  NSMutableString* logs = [NSMutableString string];
  for (NSArray* dateAndLog in datesAndLogs) {
    if (logs.length > 0) {
      [logs appendString:@"\n\n"];
    }
    
    NSDate* date = [dateAndLog firstObject];
    NSString* log = [dateAndLog lastObject];
    [logs appendFormat:@"%@: %@", date, log];
  }
  
  UITextView* textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
  textView.editable = NO;
  textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  textView.text = logs;
  textView.font = [UIFont boldSystemFontOfSize:12];

  [self.view addSubview:textView];  
}

@end
