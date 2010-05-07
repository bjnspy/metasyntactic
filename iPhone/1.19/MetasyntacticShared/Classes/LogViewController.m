// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
