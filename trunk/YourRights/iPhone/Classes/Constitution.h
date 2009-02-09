//
//  Constitution.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Constitution : NSObject {
@private
    NSString* country;
    NSString* preamble;
    NSArray* articles;
    NSArray* amendments;
    MultiDictionary* signers;
}

@property (readonly, copy) NSString* country;
@property (readonly, copy) NSString* preamble;
@property (readonly, retain) NSArray* articles;
@property (readonly, retain) NSArray* amendments;
@property (readonly, retain) MultiDictionary* signers;

+ (Constitution*) constitutionWithCountry:(NSString*) country
                                 preamble:(NSString*) preamble
                                 articles:(NSArray*) articles
                               amendments:(NSArray*) amendments
                                  signers:(MultiDictionary*) signers;

@end
