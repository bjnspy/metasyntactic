//
//  DeclarationOfIndependence.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DeclarationOfIndependence.h"

@interface DeclarationOfIndependence()
@property (copy) NSString* text;
@property (retain) MultiDictionary* signers;
@property (retain) NSDate* date;
@end

@implementation DeclarationOfIndependence

@synthesize text;
@synthesize signers;
@synthesize date;

- (void) dealloc {
    self.text = nil;
    self.signers = nil;
    self.date = nil;
    
    [super dealloc];
}


- (id) initWithText:(NSString*) text_
            signers:(MultiDictionary*) signers_
               date:(NSDate*) date_ {
    if (self = [super init]) {
        self.text = text_;
        self.signers = signers_;
        self.date = date_;
    }
    
    return self;
}


+ (DeclarationOfIndependence*) declarationWithText:(NSString*) text_
                                           signers:(MultiDictionary*) signers_ 
                                              date:(NSDate*) date_ {
    return [[[DeclarationOfIndependence alloc] initWithText:text_
                                                    signers:signers_
                                                       date:date_] autorelease];
}

@end