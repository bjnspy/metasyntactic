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

#import "NowPlayingAppDelegate.h"

@implementation GlobalActivityIndicator

static NSLock* gate = nil;
static UIActivityIndicatorView* activityIndicatorView = nil;
static UIView* activityView = nil;
static GlobalActivityIndicator* indicator = nil;

static NSInteger totalBackgroundTaskCount = 0;
static NSInteger visibleBackgroundTaskCount = 0;

+ (void) initialize {
    if (self == [GlobalActivityIndicator class]) {
        gate = [[NSRecursiveLock alloc] init];

        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect frame = activityIndicatorView.frame;
        frame.size.width += 4;

        activityView = [[UIView alloc] initWithFrame:frame];
        [activityView addSubview:activityIndicatorView];

        indicator = [[GlobalActivityIndicator alloc] init];
    }
}


+ (UIView*) activityView {
    return activityView;
}


- (void) startIndicator {
    [activityIndicatorView startAnimating];
}


- (void) stopIndicator {
    [activityIndicatorView stopAnimating];
}


+ (void) addBackgroundTask:(BOOL) isVisible {
    [gate lock];
    {
        totalBackgroundTaskCount++;

        if (isVisible) {
            visibleBackgroundTaskCount++;

            if (visibleBackgroundTaskCount == 1) {
                [indicator performSelectorOnMainThread:@selector(startIndicator) withObject:nil waitUntilDone:NO];
            }
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

            if (visibleBackgroundTaskCount == 0) {
                [indicator performSelectorOnMainThread:@selector(stopIndicator) withObject:nil waitUntilDone:NO];
            }
        }

        [NowPlayingAppDelegate minorRefresh];
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