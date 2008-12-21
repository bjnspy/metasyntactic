//
//  BackgroundInvocation2.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BackgroundInvocation2.h"


@interface BackgroundInvocation2()
@property (retain) id argument2;
@end


@implementation BackgroundInvocation2

@synthesize argument2;

- (void) dealloc {
    self.argument2 = nil;
    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_
                 gate:(NSLock*) gate_
              visible:(BOOL) visible_ {
    if (self = [super initWithTarget:target_
                            selector:selector_
                            argument:argument1_
                                gate:gate_
                             visible:visible_]) {
        self.argument2 = argument2_;
    }
    
    return self;
}


+ (BackgroundInvocation2*) invocationWithTarget:(id) target
                                       selector:(SEL) selector
                                       argument:(id) argument1
                                       argument:(id) argument2
                                           gate:(NSLock*) gate
                                        visible:(BOOL) visible {
    return [[[BackgroundInvocation2 alloc] initWithTarget:target
                                                 selector:selector
                                                 argument:argument1
                                                 argument:argument2
                                                     gate:gate
                                                  visible:visible] autorelease];
}


- (void) invokeSelector {
    [target performSelector:selector withObject:argument withObject:argument2];
}

@end