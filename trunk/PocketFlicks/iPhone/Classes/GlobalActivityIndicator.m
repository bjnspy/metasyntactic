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

#import "GlobalActivityIndicator.h"

#import "AppDelegate.h"
#import "Pulser.h"

@implementation GlobalActivityIndicator

static id target = nil;
static SEL startIndicatorSelector = 0;
static SEL stopIndicatorSelector = 0;

static NSLock* gate;

static BOOL firstTime = YES;
static NSInteger totalBackgroundTaskCount;
static NSInteger visibleBackgroundTaskCount;


+ (void) initialize {
    if (self == [GlobalActivityIndicator class]) {
        gate = [[NSRecursiveLock alloc] init];
    }
}


+ (void)           setTarget:(id) target_
      startIndicatorSelector:(SEL) startIndicatorSelector_
       stopIndicatorSelector:(SEL) stopIndicatorSelector_ {
    [gate lock];
    {
        target = target_;
        startIndicatorSelector = startIndicatorSelector_;
        stopIndicatorSelector = stopIndicatorSelector_;
    }
    [gate unlock];
}


+ (void) forceUpdate {
    [gate lock];
    {
        if (visibleBackgroundTaskCount > 0) {
            firstTime = NO;
            if (target != nil) {
                [target performSelector:startIndicatorSelector];
            }
        } else {
            if (target != nil) {
                [target performSelector:stopIndicatorSelector];
            }
        }
    }
    [gate unlock];
}


+ (void) tryUpdate {
    [self performSelector:@selector(forceUpdate)
               withObject:nil
               afterDelay:3];
}


+ (void) addBackgroundTask:(BOOL) isVisible {
    [gate lock];
    {
        totalBackgroundTaskCount++;

        if (isVisible) {
            visibleBackgroundTaskCount++;
        }

        if (visibleBackgroundTaskCount > 0 && firstTime) {
            [self performSelectorOnMainThread:@selector(forceUpdate) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(tryUpdate) withObject:nil waitUntilDone:NO];
        }
    }
    [gate unlock];
}


+ (void) removeBackgroundTask:(BOOL) isVisible {
    [gate lock];
    {
        totalBackgroundTaskCount--;

        if (isVisible) {
            visibleBackgroundTaskCount--;
        }

        [self performSelectorOnMainThread:@selector(tryUpdate) withObject:nil waitUntilDone:NO];
    }
    [gate unlock];
}


+ (BOOL) hasVisibleBackgroundTasks {
    BOOL result;
    [gate lock];
    {
        result = visibleBackgroundTaskCount > 0;
    }
    [gate unlock];
    return result;
}


+ (BOOL) hasBackgroundTasks {
    BOOL result;
    [gate lock];
    {
        result = totalBackgroundTaskCount > 0;
    }
    [gate unlock];
    return result;
}

@end