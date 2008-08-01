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

+ (NSString*) dataFolder;
+ (NSString*) documentsFolder;
+ (NSString*) locationsFolder;
+ (NSString*) postersFolder;
+ (NSString*) searchFolder;
+ (NSString*) supportFolder;
+ (NSString*) tempFolder;
+ (NSString*) ratingsFolder;
+ (NSString*) trailersFolder;
+ (NSString*) reviewsFolder;
+ (NSString*) providerReviewsFolder:(NSString*) provider;

+ (NSString*) movieMapFile;
+ (NSString*) ratingsFile:(NSString*) ratingsProvider;

+ (void) deleteFolders;

+ (NSString*) uniqueTemporaryFolder;

+ (void) openBrowser:(NSString*) address;
+ (void) openMap:(NSString*) address;
+ (void) makeCall:(NSString*) phoneNumber;

+ (DifferenceEngine*) differenceEngine;

+ (NSString*) searchHost;
+ (NSString*) host;

+ (unichar) starCharacter;
+ (NSString*) starString;

+ (void) createDirectory:(NSString*) path;
+ (NSString*) sanitizeFileName:(NSString*) name;

@end
