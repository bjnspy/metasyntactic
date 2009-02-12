// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "BackgroundInvocation.h"

#import "AppDelegate.h"
#import "GlobalActivityIndicator.h"

@interface BackgroundInvocation()
@property (retain) id<NSLocking> gate;
@property BOOL visible;
@end


@implementation BackgroundInvocation

@synthesize gate;
@synthesize visible;

- (void) dealloc {
    self.gate = nil;
    self.visible = NO;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument_
                 gate:(id<NSLocking>) gate_
              visible:(BOOL) visible_ {
    if (self = [super initWithTarget:target_ selector:selector_ argument:argument_]) {
        self.gate = gate_;
        self.visible = visible_;
    }

    return self;
}


+ (BackgroundInvocation*) invocationWithTarget:(id) target
                                      selector:(SEL) selector
                                      argument:(id) argument
                                          gate:(id<NSLocking>) gate
                                       visible:(BOOL) visible {
    return [[[BackgroundInvocation alloc] initWithTarget:target
                                                selector:selector
                                                argument:argument
                                                    gate:gate
                                                 visible:visible] autorelease];
}


- (void) invokeSelector {
    [target performSelector:selector withObject:argument];
}


- (void) runWorker {
    NSString* className = NSStringFromClass([target class]);
    NSString* selectorName = NSStringFromSelector(selector);
    NSString* name = [NSString stringWithFormat:@"%@-%@", className, selectorName];
    [[NSThread currentThread] setName:name];

    if (visible) {
        [NSThread setThreadPriority:0.25];
    } else {
        [NSThread setThreadPriority:0.0];
    }

    [gate lock];
    [GlobalActivityIndicator addBackgroundTask:visible];
    {
        [self invokeSelector];
    }
    [GlobalActivityIndicator removeBackgroundTask:visible];
    [gate unlock];

    [AppDelegate minorRefresh];
}


- (void) run {
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    {
        [self runWorker];
    }
    [autoreleasePool release];
}

@end