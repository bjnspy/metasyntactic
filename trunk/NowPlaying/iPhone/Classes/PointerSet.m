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

#import "PointerSet.h"


@implementation PointerSet

@synthesize set;

- (void) dealloc {
    self.set = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.set = [NSMutableSet set];
    }

    return self;
}


+ (PointerSet*) set {
    return [[[PointerSet alloc] init] autorelease];
}


+ (PointerSet*) setWithArray:(NSArray*) array {
    PointerSet* set = [[[PointerSet alloc] init] autorelease];
    [set addObjectsFromArray:array];
    return set;
}


- (void) addObject:(id) value {
    [set addObject:[NSValue valueWithPointer:value]];
}


- (void) addObjectsFromArray:(NSArray*) values {
    for (id value in values) {
        [self addObject:value];
    }
}


- (BOOL) containsObject:(id) value {
    return [set containsObject:[NSValue valueWithPointer:value]];
}

@end