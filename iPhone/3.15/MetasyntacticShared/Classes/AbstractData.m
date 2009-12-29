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

#import "AbstractData.h"


@implementation AbstractData

+ (NSArray*) encodeArray:(NSArray*) values {
  if (values.count == 0) {
    return [NSArray array];
  }

  NSMutableArray* result = [NSMutableArray array];
  for (id value in values) {
    [result addObject:[value dictionary]];
  }

  return result;
}


+ (NSArray*) encodeSet:(NSSet*) values {
  return [self encodeArray:values.allObjects];
}


+ (id) createWithDictionary:(NSDictionary*) dictionary {
  return nil;
}


+ (NSArray*) decodeArray:(NSArray*) values {
  if (values.count == 0) {
    return [NSArray array];
  }

  NSMutableArray* result = [NSMutableArray array];
  for (NSDictionary* dictionary in values) {
    id value = [self createWithDictionary:dictionary];
    if (value != nil) {
      [result addObject:value];
    }
  }

  return result;
}


+ (NSSet*) decodeSet:(NSArray*) values {
  return [NSSet setWithArray:[self decodeArray:values]];
}

@end
