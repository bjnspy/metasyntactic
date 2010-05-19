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

@interface ThreadsafeValue : NSObject {
@private
  id delegate;
  id<NSLocking> gate;
  SEL loadSelector;
  SEL saveSelector;

  id valueData;
}

+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                          delegate:(id) delegate
                      loadSelector:(SEL) loadSelector
                      saveSelector:(SEL) saveSelector;
+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                          delegate:(id) delegate
                      loadSelector:(SEL) loadSelector;
+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate;

- (id) value;
- (void) setValue:(id) value;

/* @protected */
- (id) initWithGate:(id<NSLocking>) gate_
           delegate:(id) delegate_
       loadSelector:(SEL) loadSelector_
       saveSelector:(SEL) saveSelector_;

@end
