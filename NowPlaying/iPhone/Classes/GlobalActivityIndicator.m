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
#import "InfoViewControllerDelegate.h"
#import "Pulser.h"
#import "NotificationCenter.h"
#import "TappableActivityIndicatorView.h"

@implementation GlobalActivityIndicator

static NSLock* gate = nil;

static BOOL firstTime = YES;
static NSInteger totalBackgroundTaskCount = 0;
static NSInteger visibleBackgroundTaskCount = 0;

+ (UIView*) activityView {
    return nil;
    //return activityIndicatorView;
}


+ (void) forceUpdate {
    [gate lock];
    {
        if (visibleBackgroundTaskCount > 0) {
            firstTime = NO;
            [[AppDelegate notificationCenter] showNotification:NSLocalizedString(@"Updating", nil)];
        } else {
            [[AppDelegate notificationCenter] hideNotification];
        }
    }
    [gate unlock];
}


+ (void) tryUpdate {
    [self performSelector:@selector(forceUpdate) withObject:nil afterDelay:2];
}


+ (void) initialize {
    if (self == [GlobalActivityIndicator class]) {
        gate = [[NSRecursiveLock alloc] init];
    }
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
        [AppDelegate minorRefresh];
    }
    [gate unlock];
}


+ (BOOL) hasVisibleBackgroundTasks {
    return visibleBackgroundTaskCount > 0;
}


+ (BOOL) hasBackgroundTasks {
    return totalBackgroundTaskCount > 0;
}

@end