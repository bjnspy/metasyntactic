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

#import "ThreadsafeValue.h"

@interface ThreadsafeValue()
@property (retain) id<NSLocking> gate;
@property (assign) id delegate;
@property SEL loadSelector;
@property SEL saveSelector;
@property (retain) id valueData;
@end

@implementation ThreadsafeValue

@synthesize gate;
@synthesize delegate;
@synthesize loadSelector;
@synthesize saveSelector;
@synthesize valueData;

- (void) dealloc {
  self.gate = nil;
  self.delegate = nil;
  self.loadSelector = nil;
  self.saveSelector = nil;
  self.valueData = nil;

  [super dealloc];
}


- (id) initWithGate:(id<NSLocking>) gate_
           delegate:(id) delegate_
       loadSelector:(SEL) loadSelector_
        saveSelector:(SEL) saveSelector_ {
  if ((self = [super init])) {
    self.gate = gate_;
    self.delegate = delegate_;
    self.loadSelector = loadSelector_;
    self.saveSelector = saveSelector_;
  }

  return self;
}


+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                         delegate:(id) delegate
                     loadSelector:(SEL) loadSelector
                     saveSelector:(SEL) saveSelector {
  return [[[ThreadsafeValue alloc] initWithGate:gate
                                      delegate:delegate
                                  loadSelector:loadSelector
                                  saveSelector:saveSelector] autorelease];
}


+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                          delegate:(id) delegate
                      loadSelector:(SEL) loadSelector {
  return [ThreadsafeValue valueWithGate:gate
                               delegate:delegate
                           loadSelector:loadSelector
                           saveSelector:nil];
}


+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate {
  return [ThreadsafeValue valueWithGate:gate delegate:nil loadSelector:nil saveSelector:nil];
}


- (id) valueNoLock {
  if (valueData == nil) {
    if (delegate != nil && loadSelector != nil) {
      self.valueData = [delegate performSelector:loadSelector];
    }
  }

  // Access through property to ensure valid value.
  return self.valueData;
}


- (id) value {
  id result;
  [gate lock];
  {
    result = [self valueNoLock];
  }
  [gate unlock];
  return result;
}


- (void) setValue:(id) value {
  [gate lock];
  {
    self.valueData = value;
  }
  [gate unlock];
  if (delegate != nil && saveSelector != nil) {
    [delegate performSelector:saveSelector withObject:value];
  }
}

@end
