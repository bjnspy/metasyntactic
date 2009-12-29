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

#import "MultiDictionary.h"

@interface MultiDictionary()
@property (retain) NSDictionary* dictionary;
@end

@implementation MultiDictionary

@synthesize dictionary;

- (void) dealloc {
  self.dictionary = nil;
  [super dealloc];
}


- (id) initWithDictionary:(NSDictionary*) dictionary_ {
  if ((self = [super init])) {
    self.dictionary = dictionary_;
  }

  return self;
}


+ (MultiDictionary*) dictionary {
  return [[[MultiDictionary alloc] initWithDictionary:[NSDictionary dictionary]] autorelease];
}


- (id) init {
  if ((self = [super init])) {
    self.dictionary = [NSDictionary dictionary];
  }

  return self;
}


- (NSArray*) objectsForKey:(id) key {
  NSArray* array = [dictionary objectForKey:key];
  if (array == nil) {
    array = [NSArray array];
  }
  return array;
}


- (NSArray*) allKeys {
  return dictionary.allKeys;
}


- (NSArray*) allValues {
  return dictionary.allValues;
}

@end
