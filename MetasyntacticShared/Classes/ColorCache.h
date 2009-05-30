//
//  ColorCache.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ColorCache : NSObject {

}

+ (UIColor*) tintColor;
+ (UIColor*) netflixRed;
+ (UIColor*) helpBlue;
+ (UIColor*) footerColor;
+ (UIColor*) commandColor;
+ (UIColor*) darkDarkGray;
+ (UIColor*) netflixYellow;
+ (UIColor*) starYellow;

+ (UIColor*) fromString:(NSString*) string;

@end
