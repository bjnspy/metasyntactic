//
//  BoxOfficeController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "XmlElement.h"
#import "Theater.h"

@class BoxOfficeAppDelegate;

@interface BoxOfficeController : NSObject {
    BoxOfficeAppDelegate* appDelegate;
    NSLock* quickLookupLock;
    NSLock* fullLookupLock;
}

//@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) NSLock* quickLookupLock;
@property (retain) NSLock* fullLookupLock;

- (void) setZipcode:(NSString*) zipcode;
- (void) setSearchRadius:(NSInteger) radius;

+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate;

@end
