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
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Amendment

@synthesize synopsis;
@synthesize year;
@synthesize link;
@synthesize sections;

- (void) dealloc {
    self.synopsis = nil;
    self.year = 0;
    self.link = nil;
    self.sections = nil;

    [super dealloc];
}


- (id) initWithSynopsis:(NSString*) synopsis_
                   year:(NSInteger) year_
                   link:(NSString*) link_
               sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.synopsis = synopsis_;
        self.year = year_;
        self.link = link_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                            sections:(NSArray*) sections { 
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                           link:link
                                       sections:sections] autorelease];
}


+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                text:(NSString*) text {
    NSArray* sections = [NSArray arrayWithObject:[Section sectionWithText:text]];
    return [[[Amendment alloc] initWithSynopsis:synopsis
                                           year:year
                                           link:link
                                       sections:sections] autorelease];
}

@end
