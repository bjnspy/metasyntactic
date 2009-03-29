// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MutablePointerSet.h"

@interface MutablePointerSet()
@property (retain) NSMutableSet* mutableSet;
@end


@implementation MutablePointerSet

@synthesize mutableSet;

- (void) dealloc {
    self.mutableSet = nil;
    [super dealloc];
}


- (id) initWithSet:(NSMutableSet*) set_ {
    if (self = [super initWithSet:set_]) {
        self.mutableSet = set_;
    }

    return self;
}


+ (MutablePointerSet*) set {
    return [[[MutablePointerSet alloc] initWithSet:[NSMutableSet set]] autorelease];
}


- (void) addObject:(id) value {
    [mutableSet addObject:[NSValue valueWithPointer:value]];
}


- (void) removeObject:(id) value {
    [mutableSet removeObject:[NSValue valueWithPointer:value]];
}

@end