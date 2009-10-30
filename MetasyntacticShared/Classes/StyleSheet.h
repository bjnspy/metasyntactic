//
//  StyleSheet.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StyleSheet : NSObject {

}

+ (UIBarStyle) navigationBarStyle;
+ (UIBarStyle) searchBarStyle;
+ (UIBarStyle) toolBarStyle;
+ (BOOL) toolBarTranslucent;
+ (UIColor*) tableViewGroupedHeaderColor;

@end
