//
//  Invocation2.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Invocation2.h"

@interface Invocation2()
@property (retain) id argument2;
@end

@implementation Invocation2

@synthesize argument2;

- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_ {
    if (self = [super initWithTarget:target_ selector:selector_ argument:argument1_]) {
        self.argument2 = argument2_;
    }
    
    return self;
}


+ (Invocation2*) invocationWithTarget:(id) target
                             selector:(SEL) selector
                             argument:(id) argument1
                             argument:(id) argument2 {
    return [[[Invocation2 alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument1
                                      argument:argument2] autorelease];
}


- (void) run {
    [target performSelector:selector withObject:argument withObject:argument2];
}

@end
