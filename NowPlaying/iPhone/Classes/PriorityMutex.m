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

#import "PriorityMutex.h"

@interface PriorityMutex()
@property (retain) NSCondition* gate;
@end

@implementation PriorityMutex

@synthesize gate;


- (void) dealloc {
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSCondition alloc] init] autorelease];

        highTaskRunningCount = 0;
    }

    return self;
}


+ (PriorityMutex*) mutex {
    return [[[PriorityMutex alloc] init] autorelease];
}


- (void) lockHigh {
    [gate lock];
    {
        highTaskRunningCount++;
    }
    [gate unlock];
}


- (void) unlockHigh {
    [gate lock];
    {
        highTaskRunningCount--;
        if (highTaskRunningCount == 0) {
            // wake up all a low pri thread that is waiting
            // don't wake them all up as we don't want to
            // move right back into a condition where all the
            // low pri threads are consuming all the resources
            [gate signal];
        }
    }
    [gate unlock];
}


- (void) lockLow {
    [gate lock];
    {
        while (highTaskRunningCount > 0) {
            [gate wait];
        }
    }
    [gate unlock];
}


- (void) unlockLow {
    [gate lock];
    {
        // wake up other low pri hreads that might have been waiting.
        [gate signal];
    }
    [gate unlock];
}

@end