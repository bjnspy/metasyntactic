//
//  BoxOfficeController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "XmlElement.h"
#import "Theater.h"

@class BoxOfficeAppDelegate;

@interface BoxOfficeController : NSObject {
    BoxOfficeAppDelegate* appDelegate;
    NSLock* movieLookupLock;
    NSLock* theaterLookupLock;
}

// Don't retain the BoxOfficeAppDelegate.  It's retaining us.
@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) NSLock* movieLookupLock;
@property (retain) NSLock* theaterLookupLock;
 
- (void) setZipcode:(NSString*) zipcode;
- (void) setSearchRadius:(NSInteger) radius;

@end
