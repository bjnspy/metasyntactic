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

#import "AutoreleasingMutableDictionary.h"

@interface AutoreleasingMutableDictionary()
@property (retain) NSMutableDictionary* underlyingDictionary;
@end


@implementation AutoreleasingMutableDictionary

@synthesize underlyingDictionary;

- (void) dealloc {
  self.underlyingDictionary = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingDictionary = [NSMutableDictionary dictionary];
  }
  return self;
}


+ (AutoreleasingMutableDictionary*) dictionary {
  return [[[AutoreleasingMutableDictionary alloc] init] autorelease];
}


+ (AutoreleasingMutableDictionary*) dictionaryWithDictionary:(NSDictionary*) dictionary {
  AutoreleasingMutableDictionary* result = [self dictionary];
  [result setDictionary:dictionary];
  return result;
}


- (NSUInteger)count {
  return [underlyingDictionary count];
}


- (id)objectForKey:(id)aKey {
  return [[[underlyingDictionary objectForKey:aKey] retain] autorelease];
}


- (NSEnumerator *)keyEnumerator {
  return [underlyingDictionary keyEnumerator];
}


- (void)removeObjectForKey:(id)aKey {
  [underlyingDictionary removeObjectForKey:aKey];
}


- (void)setObject:(id)anObject forKey:(id)aKey {
  [underlyingDictionary setObject:anObject forKey:aKey];
}

@end
