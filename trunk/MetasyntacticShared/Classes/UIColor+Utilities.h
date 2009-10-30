//
//  UIColor+Utilities.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define RGBUIColor(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1]
#define RGBAUIColor(r,g,b,a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)/255.]

@interface UIColor(UIColorUtilities)
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;

- (NSString*) toHexString;
+ (UIColor*) fromHexString:(NSString*) string;
@end
