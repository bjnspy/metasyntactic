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

#import "StyleSheet.h"

#import "UIColor+Utilities.h"

@interface StyleSheet()
@property BOOL disabled;
@end


@implementation StyleSheet

static StyleSheet* styleSheet;

+ (void) initialize {
  if (self == [StyleSheet class]) {
    styleSheet = [[StyleSheet alloc] init];
  }
}

@synthesize disabled;

- (void) dealloc {
  self.disabled = NO;
  [super dealloc];
}


+ (void) enableTheming {
  styleSheet.disabled = NO;
}


+ (void) disableTheming {
  styleSheet.disabled = YES;
}


+ (UIBarStyle) barStyleFromString:(NSString*) string {
  if ([@"UIBarStyleBlack" isEqual:string]) {
    return UIBarStyleBlack;
  } else {
    return UIBarStyleDefault;
  }
}


+ (UIBarStyle) navigationBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UINavigationBarStyle"]];
}


+ (UIBarStyle) searchBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISearchBarStyle"]];
}


+ (UIBarStyle) toolBarStyle {
  return [self barStyleFromString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIToolBarStyle"]];
}


+ (BOOL) toolBarTranslucent {
  return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIToolBarTranslucent"] boolValue];
}


+ (UIColor*) tableViewGroupedHeaderColor {
  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UITableViewGroupedHeaderColor"]];
}


+ (UIColor*) tableViewGroupedFooterColor {
  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UITableViewGroupedFooterColor"]];
}


- (UIColor*) tableViewSearchHeaderBackgroundColor {
  if (!disabled) {
    UIColor* result = [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UITableViewSearchHeaderBackgroundColor"]];
    if (result != nil) {
      return result;
    }
  }

  return RGBUIColor(226, 231, 237);
}


+ (UIColor*) tableViewSearchHeaderBackgroundColor {
  return [styleSheet tableViewSearchHeaderBackgroundColor];
}


- (UIColor*) navigationBarTintColor {
  if (self.disabled) {
    return nil;
  }

  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UINavigationBarTintColor"]];
}


+ (UIColor*) navigationBarTintColor {
  return [styleSheet navigationBarTintColor];
}


- (UIColor*) segmentedControlTintColor {
  if (self.disabled) {
    return nil;
  }

  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISegmentedControlTintColor"]];
}


+ (UIColor*) segmentedControlTintColor {
  return [styleSheet segmentedControlTintColor];
}


- (UIColor*) searchBarTintColor {
  if (self.disabled) {
    return nil;
  }

  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISearchBarTintColor"]];
}


+ (UIColor*) searchBarTintColor {
  return [styleSheet searchBarTintColor];
}


+ (UIColor*) actionButtonTextColor {
  return [UIColor fromHexString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ActionButtonTextColor"]];
}


+ (UIStatusBarStyle) statusBarStyle {
  id value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIStatusBarStyle"];
  if ([@"UIStatusBarStyleBlackOpaque" isEqual:value]) {
    return UIStatusBarStyleBlackOpaque;
  } else if ([@"UIStatusBarStyleBlackTranslucent" isEqual:value]) {
    return UIStatusBarStyleBlackTranslucent;
  } else {
    return UIStatusBarStyleDefault;
  }
}

@end
