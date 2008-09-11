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

#import "ThreadingUtilities.h"

#import "BackgroundInvocation.h"
#import "GlobalActivityIndicator.h"

@implementation ThreadingUtilities


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(NSLock*) gate
                       visible:(BOOL) visible {
    [self performSelector:selector onTarget:target inBackgroundWithArgument:argument gate:gate visible:visible lowPriority:YES];
}


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(NSLock*) gate
                       visible:(BOOL) visible 
                   lowPriority:(BOOL) lowPriority {
    BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                         selector:selector
                                                                         argument:argument
                                                                             gate:gate
                                                                          visible:visible
                                                                      lowPriority:lowPriority];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}

@end