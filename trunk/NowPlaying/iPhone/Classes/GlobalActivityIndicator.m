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

#import "ApplicationTabBarController.h"
#import "NowPlayingAppDelegate.h"

@implementation GlobalActivityIndicator

static NSLock* gate;
static UIActivityIndicatorView* activityIndicatorView = nil;
static UIView* activityView = nil;
static NSInteger backgroundTaskCount = 0;
static NowPlayingAppDelegate* appDelegate;
static GlobalActivityIndicator* indicator;

+ (void) initialize {
    if (self == [GlobalActivityIndicator class]) {
        gate = [[NSLock alloc] init];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect frame = activityIndicatorView.frame;
        frame.size.width += 4;
        
        activityView = [[UIView alloc] initWithFrame:frame];
        [activityView addSubview:activityIndicatorView];
        
        indicator = [[GlobalActivityIndicator alloc] init];
    }
}


+ (void) setAppDelegate:(NowPlayingAppDelegate*) appDelegate_ {
    appDelegate = appDelegate_;
}


+ (UIView*) activityView {
    return activityView;
}


- (void) start {
    [activityIndicatorView startAnimating];
}


- (void) stop {
    [activityIndicatorView stopAnimating];
    [appDelegate.tabBarController refresh];
}


+ (void) addBackgroundTask {
    [gate lock];
    {
        backgroundTaskCount++;
        
        if (backgroundTaskCount == 1) {
            [indicator performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        }
    }
    [gate unlock];
}


+ (void) removeBackgroundTask {
    [gate lock];
    {
        backgroundTaskCount--;
        
        if (backgroundTaskCount == 0) {
            [indicator performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
        }
    }
    [gate unlock];
}


@end
