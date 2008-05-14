//
//  Application.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


@interface Application : NSObject {
}

+ (void) initialize;

+ (NSString*) supportFolder;
+ (NSString*) postersFolder;
+ (NSString*) documentsFolder;
+ (NSString*) formatDate:(NSDate*) date;
+ (UIColor*) lightBlueTextColor;

@end
