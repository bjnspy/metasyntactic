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

@interface LinkedSet()
@property (retain) NSLock* gate;
@property (retain) LinkedNode* firstNode;
@property (retain) LinkedNode* lastNode;
@property (retain) NSMutableDictionary* valueToNode;
@end


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
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
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


- (void) addObjectNoLock:(id) object {
    if (object == nil) {
        return;
    }

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


- (void) addObject:(id) object {
    if (object == nil) {
        return;
    }

    [gate lock];
    {
        [self addObjectNoLock:object];
    }
    [gate unlock];
}


- (void) addObjectsFromArrayNoLock:(NSArray*) array {
    for (NSInteger i = array.count - 1; i >= 0; i--) {
        [self addObjectNoLock:[array objectAtIndex:i]];
    }
}

- (void) addObjectsFromArray:(NSArray*) array {
    [gate lock];
    {
        [self addObjectsFromArrayNoLock:array];
    }
    [gate unlock];
}


- (void) removeAllObjectsNoLock {
    // delete all the back pointers.netflixSeriesDirectory
    // This will clear up circular references.
    for (LinkedNode* node = firstNode; node != nil; node = node.next) {
        node.previous = nil;
    }

    // now, when we release our nodes, they'll all dissapear.
    self.firstNode = nil;
    self.lastNode = nil;

    [valueToNode removeAllObjects];
}


- (void) removeAllObjects {
    [gate lock];
    {
        [self removeAllObjectsNoLock];
    }
    [gate unlock];
}


- (void) setArray:(NSArray*) array {
    [gate lock];
    {
        [self removeAllObjectsNoLock];
        [self addObjectsFromArrayNoLock:array];
    }
    [gate unlock];
}

@end