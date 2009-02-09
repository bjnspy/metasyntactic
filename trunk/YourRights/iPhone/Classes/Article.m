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
@property (retain) NSArray* sections;
@end


@implementation Article

@synthesize title;
@synthesize sections;

- (void) dealloc {
    self.title = nil;
    self.sections = nil;
    
    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ 
            sections:(NSArray*) sections_ {
    if (self = [super init]) {
        self.title = title_;
        self.sections = sections_;
    }
    
    return self;
}


+ (Article*) articleWithTitle:(NSString*) title
                     sections:(NSArray*) sections {
    return [[[Article alloc] initWithTitle:title
                                  sections:sections] autorelease];
}

@end
