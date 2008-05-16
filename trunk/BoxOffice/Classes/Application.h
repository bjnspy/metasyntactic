//
//  Application.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//


@interface Application : NSObject {
}

+ (void) initialize;

+ (NSString*) supportFolder;
+ (NSString*) postersFolder;
+ (NSString*) documentsFolder;
+ (NSString*) formatDate:(NSDate*) date;
+ (UIColor*) commandColor;
+ (UIImage*) freshImage;
+ (UIImage*) rottenImage;

+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

@end
