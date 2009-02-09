//
//  Article.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Article.h"

@interface Article()
@property (copy) NSString* title;
@property (copy) NSString* link;
@property (retain) NSArray* sections;
@end


@implementation Article

@synthesize title;
@synthesize link;
@synthesize sections;

- (void) dealloc {
    self.title = nil;
    self.link = nil;
    self.sections = nil;
    
    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ 
                link:(NSString*) link_
            sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.title = title_;
        self.link = link_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Article*) articleWithTitle:(NSString*) title
                         link:(NSString*) link
                     sections:(NSArray*) sections {
    return [[[Article alloc] initWithTitle:title
                                      link:link
                                  sections:sections] autorelease];
}

@end
