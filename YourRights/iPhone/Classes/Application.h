//
//  Application.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Application : NSObject {

}

+ (NSString*) name;
+ (NSString*) nameAndVersion;

+ (void) moveItemToTrash:(NSString*) path;

+ (NSString*) rssDirectory;
+ (NSString*) tempDirectory;
+ (NSString*) trashDirectory;

@end
