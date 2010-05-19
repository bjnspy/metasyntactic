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

#import "ThreadingUtilities.h"

#import "BackgroundInvocation3.h"
#import "Invocation3.h"

@implementation ThreadingUtilities

+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                       gate:(id<NSLocking>) gate
                     daemon:(BOOL) daemon {
  [self backgroundSelector:selector
                  onTarget:target
                withObject:nil
                      gate:gate
                    daemon:daemon];
}


+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument
                       gate:(id<NSLocking>) gate
                     daemon:(BOOL) daemon {
  BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                       selector:selector
                                                                     withObject:argument
                                                                           gate:gate
                                                                         daemon:daemon];
  [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument1
                 withObject:(id) argument2
                       gate:(id<NSLocking>) gate
                     daemon:(BOOL) daemon {
  BackgroundInvocation* invocation = [BackgroundInvocation2 invocationWithTarget:target
                                                                        selector:selector
                                                                      withObject:argument1
                                                                      withObject:argument2
                                                                            gate:gate
                                                                          daemon:daemon];
  [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) backgroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument1
                 withObject:(id) argument2
                 withObject:(id) argument3
                       gate:(id<NSLocking>) gate
                     daemon:(BOOL) daemon {
  BackgroundInvocation* invocation = [BackgroundInvocation3 invocationWithTarget:target
                                                                        selector:selector
                                                                      withObject:argument1
                                                                      withObject:argument2
                                                                      withObject:argument3
                                                                            gate:gate
                                                                          daemon:daemon];
  [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target {
  [target performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument {
  [target performSelectorOnMainThread:selector withObject:argument waitUntilDone:NO];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument1
                 withObject:(id) argument2 {
  Invocation* invocation = [Invocation2 invocationWithTarget:target
                                                    selector:selector
                                                  withObject:argument1
                                                  withObject:argument2];
  [invocation performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
}


+ (void) foregroundSelector:(SEL) selector
                   onTarget:(id) target
                 withObject:(id) argument1
                 withObject:(id) argument2
                 withObject:(id) argument3 {
  Invocation* invocation = [Invocation3 invocationWithTarget:target
                                                    selector:selector
                                                  withObject:argument1
                                                  withObject:argument2
                                                  withObject:argument3];
  [invocation performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
}


+ (BOOL) hasNonDaemonBackgroundTasks {
  return [BackgroundInvocation hasNonDaemonBackgroundTasks];
}

@end
