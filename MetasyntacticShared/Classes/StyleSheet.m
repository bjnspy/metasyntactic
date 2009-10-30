//
//  StyleSheet.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleSheet.h"

#import "UIColor+Utilities.h"

@implementation StyleSheet

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

@end
