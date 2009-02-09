//
//  Constitution.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Constitution.h"

@interface Constitution()
@property (copy) NSString* country;
@property (copy) NSString* preamble;
@property (retain) NSArray* articles;
@property (retain) NSArray* amendments;
@property (retain) NSArray* signers;
@end

@implementation Constitution

@synthesize country;
@synthesize preamble;
@synthesize articles;
@synthesize amendments;
@synthesize signers;

- (void) dealloc {
    self.country = nil;
    self.preamble = nil;
    self.articles = nil;
    self.amendments = nil;
    self.signers = nil;
    
    [super dealloc];
}


- (id) initWithCountry:(NSString*) country_
              preamble:(NSString*) preamble_
              articles:(NSArray*) articles_
            amendments:(NSArray*) amendments_ 
               signers:(NSArray*) signers_ {
    if (self = [super init]) {
        self.country = country_;
        self.preamble = preamble_;
        self.articles = articles_;
        self.amendments = amendments_;
        self.signers = signers_;
    }
    
    return self;
}


+ (Constitution*) constitutionWithCountry:(NSString*) country_
                                 preamble:(NSString*) preamble_
                                 articles:(NSArray*) articles_
                               amendments:(NSArray*) amendments_ 
                                  signers:(NSArray*) signers_ {
    return [[[Constitution alloc] initWithCountry:country_
                                         preamble:preamble_
                                         articles:articles_
                                       amendments:amendments_
                                          signers:signers_] autorelease];
}

@end
