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

#import "MainThreadGate.h"

@interface MainThreadGate()
@property (retain) NSCondition* condition;
@end


@implementation MainThreadGate

@synthesize condition;

- (void) dealloc {
    self.condition = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.condition = [[[NSCondition alloc] init] autorelease];
    }

    return self;
}


+ (MainThreadGate*) gate {
    return [[[MainThreadGate alloc] init] autorelease];
}


- (void) lock {
    [condition lock];
    {
        if ([NSThread isMainThread]) {
            NSAssert(!mainThreadRunning, @"");
            mainThreadRunning = YES;
        } else {
            while (mainThreadRunning || backgroundThreadRunning) {
                [condition wait];
            }
            backgroundThreadRunning = YES;
        }
    }
    [condition unlock];
}


- (void) unlock {
    [condition lock];
    {
        NSAssert(mainThreadRunning || backgroundThreadRunning, @"");

        if ([NSThread isMainThread]) {
            mainThreadRunning = NO;
        } else {
            backgroundThreadRunning = NO;
        }

        [condition signal];
    }
    [condition unlock];
}

@end