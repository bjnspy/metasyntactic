//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "BackgroundInvocation.h"

#import "GlobalActivityIndicator.h"

@implementation BackgroundInvocation

@synthesize gate;
@synthesize visible;
@synthesize lowPriority;

- (void) dealloc {
    self.gate = nil;
    self.visible = NO;
    self.lowPriority = NO;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument_
                 gate:(NSLock*) gate_
              visible:(BOOL) visible_
          lowPriority:(BOOL) lowPriority_ {
    if (self = [super initWithTarget:target_ selector:selector_ argument:argument_]) {
        self.gate = gate_;
        self.visible = visible_;
        self.lowPriority = lowPriority_;
    }

    return self;
}


+ (BackgroundInvocation*) invocationWithTarget:(id) target
                                      selector:(SEL) selector
                                      argument:(id) argument
                                          gate:(NSLock*) gate
                                       visible:(BOOL) visible
                                   lowPriority:(BOOL) lowPriority {
    return [[[BackgroundInvocation alloc] initWithTarget:target
                                                selector:selector
                                                argument:argument
                                                    gate:gate
                                                 visible:visible
                                             lowPriority:lowPriority] autorelease];
}


- (void) run {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    {
        if (lowPriority) {
            [NSThread setThreadPriority:0.0];
        }

        [gate lock];
        [GlobalActivityIndicator addBackgroundTask:visible];
        {
            [target performSelector:selector withObject:argument];
        }
        [GlobalActivityIndicator removeBackgroundTask:visible];
        [gate unlock];
    }
    [autoreleasePool release];
}


@end