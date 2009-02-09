//
//  Section.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Section.h"

@interface Section()
@property (copy) NSString* text;
@end


@implementation Section

@synthesize text;

- (void) dealloc {
    self.text = nil;
    [super dealloc];
}


- (id) initWithText:(NSString*) text_ {
    if (self = [super init]) {
        self.text = text_;
    }
    
    return self;
}


+ (Section*) sectionWithText:(NSString*) text {
    return [[[Section alloc] initWithText:text] autorelease];
}

@end
