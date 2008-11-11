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

#import "Invocation.h"

@interface Invocation()
@property (retain) id target;
@property SEL selector;
@property (retain) id argument;
@end


@implementation Invocation

@synthesize target;
@synthesize selector;
@synthesize argument;

- (void) dealloc {
    self.target = nil;
    self.selector = nil;
    self.argument = nil;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument_ {
    if (self = [super init]) {
        self.target = target_;
        self.selector = selector_;
        self.argument = argument_;
    }

    return self;
}


+ (Invocation*) invocationWithTarget:(id) target
                            selector:(SEL) selector
                            argument:(id) argument {
    return [[[Invocation alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument] autorelease];
}


- (void) run {
    [target performSelector:selector withObject:argument];
}


@end