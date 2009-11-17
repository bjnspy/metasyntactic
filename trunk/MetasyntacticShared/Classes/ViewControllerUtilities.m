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

#import "MetasyntacticSharedApplication.h"

#import "ColorCache.h"
#import "StyleSheet.h"
#import "ViewControllerUtilities.h"
#import "NSArray+Utilities.h"

@implementation ViewControllerUtilities

static UIFont* regularTitleFont = nil;
static UIFont* minimumTitleFont = nil;

+ (void) initialize {
  if (self == [ViewControllerUtilities class]) {
    regularTitleFont = [[UIFont boldSystemFontOfSize:20] retain];
    minimumTitleFont = [[UIFont boldSystemFontOfSize:12] retain];
  }
}


+ (BOOL) hasLeftBarItem:(UIViewController*) controller {
    if (controller.navigationItem.leftBarButtonItem != nil ||
        controller.navigationItem.backBarButtonItem != nil) {
      return YES;
    }

  UINavigationController* navController = controller.navigationController;
  if (navController == nil) {
    return NO;
  }

  if (navController.viewControllers.count == 0) {
    return NO;
  }

  return controller != navController.viewControllers.firstObject;
}


+ (UILabel*) createTitleLabel:(NSString*) title
                     maxWidth:(NSInteger) maxWidth
               forceMultiLine:(BOOL) forceMultiLine {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];

  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.shadowColor = [UIColor darkGrayColor];
  label.textAlignment = UITextAlignmentCenter;
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  label.lineBreakMode = UILineBreakModeMiddleTruncation;
  label.text = title;

  CGSize size = [title sizeWithFont:minimumTitleFont];
  if (size.width > maxWidth || forceMultiLine) {
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:14];
  } else {
    label.adjustsFontSizeToFitWidth = YES;
    label.font = regularTitleFont;
    label.minimumFontSize = 12;
  }

  return label;
}


+ (UILabel*) createTitleLabel {
  return [self createTitleLabel:@"" maxWidth:320 forceMultiLine:NO];
}


+ (UILabel*) createMultiLineTitleLabel {
  return [self createTitleLabel:@"" maxWidth:320 forceMultiLine:YES];
}


+ (void) setupTitleLabel:(UIViewController*) controller {
  UIView* currentView = controller.navigationItem.titleView;
  if (currentView != nil && ![currentView isKindOfClass:[UILabel class]]) {
    return;
  }

  NSString* title = controller.title;
  if (title.length == 0) {
    controller.navigationItem.titleView = nil;
    return;
  }

  if (UIInterfaceOrientationIsLandscape(controller.interfaceOrientation)) {
    controller.navigationItem.titleView = nil;
    return;
  }

  NSInteger maxWidth = 320;
  const BOOL hasLeftBarItem = [self hasLeftBarItem:controller];
  if (hasLeftBarItem) {
    maxWidth -= 85;
  }
  if (controller.navigationItem.rightBarButtonItem != nil) {
    maxWidth -= 85;
  }

  CGSize size = [title sizeWithFont:regularTitleFont];
  if (size.width <= maxWidth) {
    controller.navigationItem.titleView = nil;
    return;
  }

  UILabel* label = [self createTitleLabel:title maxWidth:maxWidth forceMultiLine:NO];

  controller.navigationItem.titleView = label;
}


+ (UILabel*) groupedFooterLabel:(NSString*) text {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:15];

  UIColor* textColor = [StyleSheet tableViewGroupedFooterColor];

  if (textColor == nil) {
    label.textColor = [ColorCache footerColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
  } else {
    label.textColor = textColor;
  }

  label.textAlignment = UITextAlignmentCenter;
  label.text = text;
  return label;
}


+ (UILabel*) groupedFooterLabel {
  return [self groupedFooterLabel:@""];
}

@end
