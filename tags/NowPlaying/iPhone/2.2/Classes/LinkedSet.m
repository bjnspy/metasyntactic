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

#import "LinkedSet.h"

#import "LinkedNode.h"

@implementation LinkedSet

@synthesize gate;
@synthesize firstNode;
@synthesize lastNode;
@synthesize valueToNode;

- (void) dealloc {
    self.gate = nil;
    self.firstNode = nil;
    self.lastNode = nil;
    self.valueToNode = nil;

    [super dealloc];
}


- (id) initWithCountLimit:(NSInteger) countLimit_ {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.valueToNode = [NSMutableDictionary dictionary];
        countLimit = countLimit_;
    }

    return self;
}


+ (LinkedSet*) setWithCountLimit:(NSInteger) countLimit {
    return [[[LinkedSet alloc] initWithCountLimit:countLimit] autorelease];
}


+ (LinkedSet*) set {
    return [LinkedSet setWithCountLimit:-1];
}


- (void) removeNode:(LinkedNode*) node {
    [[node retain] autorelease];

    if (node.value != nil) {
        [valueToNode removeObjectForKey:node.value];
    }

    node.next.previous = node.previous;
    node.previous.next = node.next;

    if (node == firstNode) {
        self.firstNode = firstNode.next;
        firstNode.previous = nil;
    }

    if (node == lastNode) {
        self.lastNode = lastNode.previous;
        lastNode.next = nil;
    }
}


- (id) removeLastObjectAdded {
    id object;

    [gate lock];
    {
        object = [[lastNode.value retain] autorelease];
        [self removeNode:lastNode];

        if (valueToNode.count == 0) {
            NSAssert(firstNode == nil, @"");
            NSAssert(lastNode == nil, @"");
        } else {
            NSAssert(firstNode != nil, @"");
            NSAssert(lastNode != nil, @"");
            NSAssert(firstNode.previous == nil, @"");
            NSAssert(lastNode.next == nil, @"");
        }
    }
    [gate unlock];

    return object;
}


- (void) enforceLimit {
    if (countLimit <= 0) {
        return;
    }

    while (valueToNode.count > countLimit) {
        [self removeNode:firstNode];
    }
}


- (void) addObject:(id) object {
    [gate lock];
    {
        LinkedNode* node = [valueToNode objectForKey:object];
        [self removeNode:node];

        self.lastNode = [LinkedNode nodeWithValue:object previous:lastNode next:nil];
        [valueToNode setObject:lastNode forKey:object];

        if (firstNode == nil) {
            self.firstNode = lastNode;
        }

        [self enforceLimit];

        NSAssert(firstNode != nil, @"");
        NSAssert(lastNode != nil, @"");
        NSAssert(firstNode.previous == nil, @"");
        NSAssert(lastNode.next == nil, @"");
    }
    [gate unlock];
}

@end