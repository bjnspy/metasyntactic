//
//  DeclarationOfIndependence.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface DeclarationOfIndependence : NSObject {
@private
    NSString* text;
    MultiDictionary* signers;
    NSDate* date;
}

@property (readonly, copy) NSString* text;
@property (readonly, retain) MultiDictionary* signers;
@property (readonly, retain) NSDate* date;

+ (DeclarationOfIndependence*) declarationWithText:(NSString*) text
                                           signers:(MultiDictionary*) signers
                                              date:(NSDate*) date;

@end
