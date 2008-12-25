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

#import "ThreadingUtilities.h"

#import "BackgroundInvocation.h"
#import "BackgroundInvocation2.h"
#import "Invocation2.h"
#import "PriorityMutex.h"

@implementation ThreadingUtilities

+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                   argument:(id) argument1
                   argument:(id) argument2
                       gate:(NSLock*) gate
                    visible:(BOOL) visible {
    BackgroundInvocation2* invocation = [BackgroundInvocation2 invocationWithTarget:target
                                                                           selector:selector
                                                                           argument:argument1
                                                                           argument:argument2
                                                                               gate:gate
                                                                            visible:visible];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                   argument:(id) argument
                       gate:(NSLock*) gate
                    visible:(BOOL) visible {
    BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                         selector:selector
                                                                         argument:argument
                                                                             gate:gate
                                                                          visible:visible];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                       gate:(NSLock*) gate
                    visible:(BOOL) visible {
    [self backgroundSelector:selector
                    onTarget:target
                    argument:nil
                        gate:gate
                     visible:visible];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target
                   argument:(id) argument {
    [target performSelectorOnMainThread:selector withObject:argument waitUntilDone:NO];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target
                   argument:(id) argument1
                   argument:(id) argument2 {
    Invocation2* invocation = [Invocation2 invocationWithTarget:target
                                                       selector:selector
                                                       argument:argument1
                                                       argument:argument2];
    [invocation performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
}

@end