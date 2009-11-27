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

#import "MetasyntacticSharedApplication.h"

#import "../External/PinchMedia/Beacon.h"
#import "Pulser.h"

@implementation MetasyntacticSharedApplication

static id<MetasyntacticSharedApplicationDelegate> delegate = nil;

static Pulser* minorRefreshPulser = nil;
static Pulser* majorRefreshPulser = nil;

+ (void) setSharedApplicationDelegate:(id<MetasyntacticSharedApplicationDelegate>) delegate_ {
  delegate = delegate_;

  [majorRefreshPulser release];
  [minorRefreshPulser release];
  majorRefreshPulser = [[Pulser pulserWithTarget:delegate action:@selector(majorRefresh) pulseInterval:5] retain];
  minorRefreshPulser = [[Pulser pulserWithTarget:delegate action:@selector(minorRefresh) pulseInterval:3] retain];

  NSString* pinchCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PinchMediaApplicationCode"];
  if (pinchCode.length > 0) {
    [Beacon initAndStartBeaconWithApplicationCode:pinchCode
                                  useCoreLocation:NO
                                      useOnlyWiFi:NO];
  }
}


+ (NSString*) localizedString:(NSString*) key {
  return [delegate localizedString:key];
}


+ (void) saveNavigationStack:(UINavigationController*) controller {
  [delegate saveNavigationStack:controller];
}


+ (BOOL) notificationsEnabled {
  return [delegate notificationsEnabled];
}


+ (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
  if ([delegate respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
    return [delegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
  }
  
  return NO;
}


+ (NSString*) cacheDirectory {
  if ([delegate respondsToSelector:@selector(cacheDirectory)]) {
    return [delegate cacheDirectory];
  }

  return @"";
}


+ (void) minorRefresh:(BOOL) force {
  if (force) {
    [minorRefreshPulser forcePulse];
  } else {
    [minorRefreshPulser tryPulse];
  }
}


+ (void) majorRefresh:(BOOL) force {
  if (force) {
    [majorRefreshPulser forcePulse];
  } else {
    [majorRefreshPulser tryPulse];
  }
}


+ (void) majorRefresh {
  [self majorRefresh:NO];
}


+ (void) minorRefresh {
  [self minorRefresh:NO];
}

@end
