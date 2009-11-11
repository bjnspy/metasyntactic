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

#import "Iterator.h"

@interface Iterator()
@property (retain) NSEnumerator* enumerator;
@property (retain) id next;
@end


@implementation Iterator

@synthesize enumerator;
@synthesize next;

- (void) dealloc {
  self.enumerator = nil;
  self.next = nil;
  [super dealloc];
}


- (id) initWithEnumerator:(NSEnumerator*) enumerator_ {
  if ((self = [super init])) {
    self.enumerator = enumerator_;
    self.next = enumerator.nextObject;
  }

  return self;
}


+ (Iterator*) iteratorWithEnumerator:(NSEnumerator*) enumerator {
  return [[[Iterator alloc] initWithEnumerator:enumerator] autorelease];
}


- (BOOL) hasNext {
  return next != nil;
}


- (id) next {
  id result = [[next retain] autorelease];
  self.next = enumerator.nextObject;
  return result;
}

@end
