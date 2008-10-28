//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "LinkedSet.h"

#import "LinkedNode.h"

@implementation LinkedSet

@synthesize firstNode;
@synthesize lastNode;
@synthesize valueToNode;

- (void) dealloc {
    self.firstNode = nil;
    self.lastNode = nil;
    self.valueToNode = nil;
    
    [super dealloc];
}


- (id) initWithCountLimit:(NSInteger) countLimit_ {
    if (self = [super init]) {
        countLimit = countLimit_;
        self.valueToNode = [NSMutableDictionary dictionary];
    }
    
    return self;
}


+ (LinkedSet*) setWithCountLimit:(NSInteger) countLimit {
    return [[[LinkedSet alloc] initWithCountLimit:countLimit] autorelease];
}


+ (LinkedSet*) set {
    return [LinkedSet setWithCountLimit:-1];
}


- (id) removeLastObjectAdded {
    id object = [[lastNode.value retain] autorelease];
    if (object != nil) {
        [valueToNode removeObjectForKey:object];
    }
    
    if (lastNode == firstNode) {
        self.firstNode = nil;
        self.lastNode = nil;
    } else {
        self.lastNode = lastNode.previous;
        self.lastNode.next = nil;
    }
    
    return object;
}


- (void) enforceLimit {
    if (countLimit <= 0) {
        return;
    }
    
    while (valueToNode.count > countLimit) {
        [valueToNode removeObjectForKey:firstNode.value];
        self.firstNode = firstNode.next;
        firstNode.previous = nil;
    }
}


- (void) addObject:(id) object {
    LinkedNode* node = [valueToNode objectForKey:object];
    node.next.previous = node.previous;
    node.previous.next = node.next;
    
    self.lastNode = [LinkedNode nodeWithValue:object previous:lastNode next:nil];
    [valueToNode setObject:lastNode forKey:object];
    
    if (firstNode == nil) {
        self.firstNode = lastNode;
    }
    
    [self enforceLimit];
}

@end
