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

#import "LinkedNode.h"

@implementation LinkedNode

@synthesize value;
@synthesize previous;
@synthesize next;

- (void) dealloc {
    self.value = nil;
    self.previous = nil;
    self.next = nil;
    
    [super dealloc];
}


- (id) initWithValue:(id) value_ 
            previous:(LinkedNode*) previous_
                next:(LinkedNode*) next_ {
    if (self = [super init]) {
        self.value = value_;
        self.previous = previous_;
        self.next = next_;
    }
    
    return self;
}


+ (LinkedNode*) nodeWithValue:(id) value {
    return [LinkedNode nodeWithValue:value previous:nil next:nil];
}


+ (LinkedNode*) nodeWithValue:(id) value
                     previous:(LinkedNode*) previous
                         next:(LinkedNode*) next {
    return [[[LinkedNode alloc] initWithValue:value previous:previous next:next] autorelease];
}

@end