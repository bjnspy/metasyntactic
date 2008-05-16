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
    NSLock* movieLookupLock;
    NSLock* theaterLookupLock;
    NSLock* ticketLookupLock;
}

//@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) NSLock* movieLookupLock;
@property (retain) NSLock* theaterLookupLock;
@property (retain) NSLock* ticketLookupLock;

- (void) setZipcode:(NSString*) zipcode;
- (void) setSearchRadius:(NSInteger) radius;

+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate;

@end
