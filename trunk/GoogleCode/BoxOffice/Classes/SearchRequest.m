//
//  SearchRequest.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchRequest.h"


@implementation SearchRequest

@synthesize text;
@synthesize searchId;

- (void) dealloc {
    self.text = nil;
    [super dealloc];
}

- (id) initWithText:(NSString*) text_ searchId:(NSInteger) searchId_ {
    if (self = [super init]) {
        self.text = text_;
        self.searchId = searchId_;
    }
    
    return self;
}

+ (SearchRequest*) requestWithText:(NSString*) text searchId:(NSInteger) searchId {
    return [[[SearchRequest alloc] initWithText:text searchId:searchId] autorelease];
}


@end