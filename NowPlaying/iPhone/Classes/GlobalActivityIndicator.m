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
#import "TappableActivityIndicatorView.h"

@implementation GlobalActivityIndicator

static NSLock* gate = nil;
static TappableActivityIndicatorView* activityIndicatorView = nil;

static NSInteger totalBackgroundTaskCount = 0;
static NSInteger visibleBackgroundTaskCount = 0;

static UIViewController<InfoViewControllerDelegate>* viewController = nil;

+ (UIView*) activityView {
    return activityIndicatorView;
}


+ (void) forceUpdate {
    if (viewController == nil) {
        return;
    }
    
    [gate lock];
    {
        if (visibleBackgroundTaskCount > 0) {
            [activityIndicatorView startAnimating];
            viewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView] autorelease];
        } else {
            [activityIndicatorView stopAnimating];
            UIButton* infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
            [infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            infoButton.contentMode = UIViewContentModeCenter;
            CGRect frame = infoButton.frame;
            frame.size.width += 4;
            infoButton.frame = frame;
            viewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
        }
    }
    [gate unlock];
}


+ (void) tryUpdate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forceUpdate) object:nil];
    [self performSelector:@selector(forceUpdate) withObject:nil afterDelay:2];
}


+ (void) showInfo:(id) sender {
    if (viewController != nil) {
        [viewController showInfo];
    }
}


+ (void) setCurrentViewController:(UIViewController<InfoViewControllerDelegate>*) controller {
    [controller retain];
    [viewController release];
    viewController = controller;
    
    [self forceUpdate];
}


+ (void) initialize {
    if (self == [GlobalActivityIndicator class]) {
        gate = [[NSRecursiveLock alloc] init];

        activityIndicatorView = [[TappableActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.delegate = self;
        [activityIndicatorView startAnimating];        
        
        activityIndicatorView.contentMode = UIViewContentModeCenter;
        CGRect frame = activityIndicatorView.frame;
        frame.size.width += 4;
        activityIndicatorView.frame = frame;
    }
}


+ (void) imageView:(TappableActivityIndicatorView*) imageView
         wasTapped:(NSInteger) tapCount {
    [self showInfo:nil];
}


+ (void) addBackgroundTask:(BOOL) isVisible {
    [gate lock];
    {
        totalBackgroundTaskCount++;
        
        if (isVisible) {
            visibleBackgroundTaskCount++;
        }
        
        [self performSelectorOnMainThread:@selector(tryUpdate) withObject:nil waitUntilDone:NO];

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