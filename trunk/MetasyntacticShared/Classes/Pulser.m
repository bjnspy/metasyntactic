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

#import "Pulser.h"

@interface Pulser()
@property (retain) id target;
@property SEL action;
@property NSTimeInterval pulseInterval;
@property (retain) NSDate* lastPulseTime;
@end


@implementation Pulser

@synthesize target;
@synthesize action;
@synthesize pulseInterval;
@synthesize lastPulseTime;

- (void) dealloc {
  self.target = nil;
  self.action = nil;
  self.pulseInterval = 0;
  self.lastPulseTime = nil;

  [super dealloc];
}


- (id) initWithTarget:(id) target_
               action:(SEL) action_
        pulseInterval:(NSTimeInterval) pulseInterval_ {
  if ((self = [super init])) {
    self.target = target_;
    self.action = action_;
    self.pulseInterval = pulseInterval_;
    self.lastPulseTime = [NSDate dateWithTimeIntervalSince1970:1];
  }

  return self;
}


+ (Pulser*) pulserWithTarget:(id) target
                      action:(SEL) action
               pulseInterval:(NSTimeInterval) pulseInterval {
  return [[[Pulser alloc] initWithTarget:target
                                  action:action
                           pulseInterval:pulseInterval] autorelease];
}


- (NSDate*) addTimeInterval:(NSTimeInterval) interval {
  return nil;
}


- (void) tryPulse:(NSDate*) date {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(tryPulse:) withObject:date waitUntilDone:NO];
    return;
  }

  if ([date compare:lastPulseTime] == NSOrderedAscending) {
    // we sent out a pulse after this one.  just disregard this pulse
    //NSLog(@"Pulse at '%@' < last pulse at '%@'.  Disregarding.", date, lastPulseTime);
    return;
  }

  NSDate* now = [NSDate date];
  NSDate* nextViablePulseTime = [(id)lastPulseTime addTimeInterval:pulseInterval];
  if ([now compare:nextViablePulseTime] == NSOrderedAscending) {
    // too soon since the last pulse.  wait until later.
    //NSLog(@"Pulse at '%@' too soon since last pulse at '%@'.  Will perform later.", date, lastPulseTime);
    NSTimeInterval waitTime = ABS([date timeIntervalSinceDate:nextViablePulseTime]) + 1;
    waitTime = MIN(waitTime, pulseInterval);
    [self performSelector:@selector(tryPulse:) withObject:date afterDelay:waitTime];
    return;
  }

  // ok, actually pulse.
  self.lastPulseTime = now;
  //NSLog(@"Pulse at '%@' being performed at '%@'.", date, lastPulseTime);
  [target performSelectorOnMainThread:action withObject:nil waitUntilDone:NO];
}


- (void) forcePulse {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(forcePulse) withObject:nil waitUntilDone:NO];
    return;
  }

  self.lastPulseTime = [NSDate date];
  //NSLog(@"Forced pulse at '%@'.", lastPulseTime);
  [target performSelector:action];
}


- (void) tryPulse {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(tryPulse) withObject:nil waitUntilDone:NO];
    return;
  }

  [self tryPulse:[NSDate date]];
}

@end
