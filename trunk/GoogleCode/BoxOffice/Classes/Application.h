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
+ (NSString*) reviewsFolder;
+ (NSString*) trailersFolder;
+ (NSString*) documentsFolder;
+ (NSString*) dataFolder;
+ (NSString*) searchFolder;

+ (NSString*) movieMapFile;
+ (NSString*) moviesFile;
+ (NSString*) theatersFile;

+ (NSString*) formatShortTime:(NSDate*) date;
+ (NSString*) formatShortDate:(NSDate*) date;
+ (NSString*) formatLongDate:(NSDate*) date;
+ (NSString*) formatFullDate:(NSDate*) date;

+ (UIColor*) commandColor;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (DifferenceEngine*) differenceEngine;

+ (NSString*) searchHost;
+ (NSMutableArray*) hosts;

+ (unichar) starCharacter;
+ (NSString*) starString;

@end
