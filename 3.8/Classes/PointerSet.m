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

@interface PointerSet()
@property (retain) NSSet* set;
@end


@implementation PointerSet

@synthesize set;

- (void) dealloc {
    self.set = nil;

    [super dealloc];
}


- (id) initWithSet:(NSSet*) set_ {
    if ((self = [super init])) {
        self.set = set_;
    }

    return self;
}


+ (PointerSet*) setWithArray:(NSArray*) array {
    NSMutableSet* set = [NSMutableSet set];
    for (id value in array) {
        [set addObject:[NSValue valueWithPointer:value]];
    }
    return [[[PointerSet alloc] initWithSet:set] autorelease];
}


- (BOOL) containsObject:(id) value {
    return [set containsObject:[NSValue valueWithPointer:value]];
}


- (NSInteger) count {
    return set.count;
}

@end
