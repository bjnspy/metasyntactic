// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
