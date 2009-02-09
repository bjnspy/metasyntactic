//
//  Amendment.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Amendment.h"

#import "Section.h"

@interface Amendment()
@property (copy) NSString* synopsis;
@property NSInteger year;
@property (retain) NSArray* sections;
@end


@implementation Amendment

@synthesize synopsis;
@synthesize year;
@synthesize sections;

- (void) dealloc {
    self.synopsis = nil;
    self.year = 0;
    self.sections = nil;

    [super dealloc];
}


- (id) initWithSynopsis:(NSString*) synopsis_
                   year:(NSInteger) year_
               sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.synopsis = synopsis_;
        self.year = year_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                            sections:(NSArray*) sections { 
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                       sections:sections] autorelease];
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                text:(NSString*) text {
    NSArray* sections = [NSArray arrayWithObject:[Section sectionWithText:text]];
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                       sections:sections] autorelease];
}

@end
