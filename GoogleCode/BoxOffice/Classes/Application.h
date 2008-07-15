//
//  Application.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "DifferenceEngine.h"

@interface Application : NSObject {
}

+ (void) initialize;

+ (NSString*) supportFolder;
+ (NSString*) postersFolder;
+ (NSString*) dataFolder;
+ (NSString*) moviesFile;
+ (NSString*) theatersFile;
+ (NSString*) documentsFolder;
+ (NSString*) formatDate:(NSDate*) date;

+ (UIColor*) commandColor;

+ (UIImage*) freshImage;
+ (UIImage*) rottenImage;
+ (UIImage*) emptyStarImage;
+ (UIImage*) filledStarImage;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (DifferenceEngine*) differenceEngine;

+ (NSString*) searchHost;
+ (NSMutableArray*) hosts;

+ (unichar) starCharacter;
+ (NSString*) starString;

@end
