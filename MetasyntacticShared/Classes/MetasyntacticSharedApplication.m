// Copyright 2010 Cyrus Najmabadi
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

#import "MetasyntacticSharedApplication.h"

//#import "../External/PinchMedia/Beacon.h"
#import "Pulser.h"

@implementation MetasyntacticSharedApplication

static id<MetasyntacticSharedApplicationDelegate> delegate = nil;

static Pulser* minorRefreshPulser = nil;
static Pulser* majorRefreshPulser = nil;

+ (void) setSharedApplicationDelegate:(id<MetasyntacticSharedApplicationDelegate>) delegate_ {
  delegate = delegate_;

  [majorRefreshPulser release];
  [minorRefreshPulser release];
  majorRefreshPulser = [[Pulser pulserWithTarget:delegate action:@selector(majorRefresh) pulseInterval:3] retain];
  minorRefreshPulser = [[Pulser pulserWithTarget:delegate action:@selector(minorRefresh) pulseInterval:3] retain];

  NSString* pinchCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PinchMediaApplicationCode"];
  if (pinchCode.length > 0) {
//    [Beacon initAndStartBeaconWithApplicationCode:pinchCode
//                                  useCoreLocation:NO
//                                      useOnlyWiFi:NO];
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
