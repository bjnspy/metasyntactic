// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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


- (void) startNetworkIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void) stopIndicator {
    [activityIndicatorView stopAnimating];
}


- (void) stopNetworkIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

        if (totalBackgroundTaskCount == 1) {
            [indicator performSelectorOnMainThread:@selector(startNetworkIndicator) withObject:nil waitUntilDone:NO];
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

        if (totalBackgroundTaskCount == 0) {
            [indicator performSelectorOnMainThread:@selector(stopNetworkIndicator) withObject:nil waitUntilDone:NO];
        }
        
        [NowPlayingAppDelegate refresh];
    }
    [gate unlock];
}

@end