//
//  SearchResult.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"


@implementation SearchResult

@synthesize element;
@synthesize searchId;

- (void) dealloc {
    self.element = nil;
    [super dealloc];
}

- (id) initWithElement:(XmlElement*) element_ searchId:(NSInteger) searchId_ {
    if (self = [super init]) {
        self.element = element_;
        self.searchId = searchId_;
    }
    
    return self;
}

+ (SearchResult*) resultWithElement:(XmlElement*) element searchId:(NSInteger) searchId {
    return [[[SearchResult alloc] initWithElement:element searchId:searchId] autorelease];
}

@end
