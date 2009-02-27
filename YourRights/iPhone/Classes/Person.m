//
//  Person.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

Person* person(NSString* name, NSString* link) {
    return [Person personWithName:name link:link];
}

@interface Person()
@property (copy) NSString* name;
@property (copy) NSString* link;
@end


@implementation Person

@synthesize name;
@synthesize link;

- (void) dealloc {
    self.name = nil;
    self.link = nil;
    
    [super dealloc];
}


- (id) initWithName:(NSString*) name_
               link:(NSString*) link_ {
    if (self = [super init]) {
        self.name = name_;
        self.link = link_;
    }
    
    return self;
}


+ (Person*) personWithName:(NSString*) name link:(NSString*) link {
    return [[[Person alloc] initWithName:name link:link] autorelease];
}

@end