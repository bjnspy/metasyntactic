//
//  ProtectedValue.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 6/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
  if (self = [super init]) {
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


- (id) valueNoLock {
  if (valueData == nil) {
    self.valueData = [delegate performSelector:loadSelector];
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
    [delegate performSelector:saveSelector withObject:value];
  }
  [gate unlock];
}

@end
