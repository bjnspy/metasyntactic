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
#import "DataProvider.h"

@class BoxOfficeAppDelegate;

@interface BoxOfficeController : NSObject {
    BoxOfficeAppDelegate* appDelegate;
    
    NSLock* ratingsLookupLock;
    NSLock* dataProviderLock;
}

//@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) NSLock* ratingsLookupLock;
@property (retain) NSLock* dataProviderLock;

- (BoxOfficeModel*) model;

- (void) setSearchDate:(NSDate*) searchDate;
- (void) setPostalCode:(NSString*) postalCode;
- (void) setSearchRadius:(NSInteger) radius;
- (void) setRatingsProviderIndex:(NSInteger) index;

+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate;

@end
