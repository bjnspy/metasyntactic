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

#import "BackgroundInvocation3.h"

@interface BackgroundInvocation2()
- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_
                 gate:(id<NSLocking>) gate_
               daemon:(BOOL) daemon_;
@end

@interface BackgroundInvocation3()
@property (retain) id argument3;
@end


@implementation BackgroundInvocation3

@synthesize argument3;

- (void) dealloc {
  self.argument3 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_
           withObject:(id) argument3_
                 gate:(id<NSLocking>) gate_
               daemon:(BOOL) daemon_ {
  if ((self = [super initWithTarget:target_
                           selector:selector_
                         withObject:argument1_
                         withObject:argument2_
                               gate:gate_
                             daemon:daemon_])) {
    self.argument3 = argument3_;
  }

  return self;
}


+ (BackgroundInvocation3*) invocationWithTarget:(id) target
                                       selector:(SEL) selector
                                     withObject:(id) argument1
                                     withObject:(id) argument2
                                     withObject:(id) argument3
                                           gate:(id<NSLocking>) gate
                                         daemon:(BOOL) daemon {
  return [[[BackgroundInvocation3 alloc] initWithTarget:target
                                               selector:selector
                                             withObject:argument1
                                             withObject:argument2
                                             withObject:argument3
                                                   gate:gate
                                                 daemon:daemon] autorelease];
}


- (void) invokeSelector {
  IMP imp = [target methodForSelector:selector];
  imp(target, selector, argument, argument2, argument3);
}

@end
