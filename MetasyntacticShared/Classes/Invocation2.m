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

#import "Invocation2.h"

@interface Invocation()
- (id) initWithTarget:(id) target
             selector:(SEL) selector
           withObject:(id) argument;
@end

@interface Invocation2()
@property (retain) id argument2;
@end

@implementation Invocation2

@synthesize argument2;

- (void) dealloc {
  self.argument2 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_ {
  if ((self = [super initWithTarget:target_ selector:selector_ withObject:argument1_])) {
    self.argument2 = argument2_;
  }

  return self;
}


+ (Invocation2*) invocationWithTarget:(id) target
                             selector:(SEL) selector
                           withObject:(id) argument1
                           withObject:(id) argument2 {
  return [[[Invocation2 alloc] initWithTarget:target
                                     selector:selector
                                   withObject:argument1
                                   withObject:argument2] autorelease];
}


- (void) run {
  [target performSelector:selector withObject:argument withObject:argument2];
}

@end
