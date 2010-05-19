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

#import "MetasyntacticSharedApplication.h"

#import "ColorCache.h"
#import "NSArray+Utilities.h"
#import "StyleSheet.h"
#import "UIColor+Utilities.h"
#import "ViewControllerUtilities.h"

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

  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = RGBUIColor(113, 120, 128);
  } else {
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
  }
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


+ (NSInteger) width {
  CGRect rect = [[UIScreen mainScreen] bounds];
  return MIN(rect.size.width, rect.size.height);
}


+ (UILabel*) createTitleLabel {
  return [self createTitleLabel:@""
                       maxWidth:[self width]
                 forceMultiLine:NO];
}


+ (UILabel*) createMultiLineTitleLabel {
  return [self createTitleLabel:@""
                       maxWidth:[self width]
                 forceMultiLine:YES];
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

  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
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
