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

@interface Invocation : NSObject {
    SEL selector;
    id target;
    id argument;
    NSLock* gate;
    BOOL visible;
}

@property SEL selector;
@property (retain) id target;
@property (retain) id argument;
@property (retain) NSLock* gate;
@property BOOL visible;

+ (Invocation*) invocationWithSelector:(SEL) selector
                                target:(id) target
                              argument:(id) argument
                                  gate:(NSLock*) gate
                               visible:(BOOL) visible;

@end
