// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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


- (NSDictionary*) dictionary AbstractMethod;


+ (id) createWithDictionaryWorker:(NSDictionary*) dictionary AbstractMethod;


+ (id) createWithDictionary:(NSDictionary*) dictionary {
  if (dictionary.count == 0) {
    return nil;
  }

  return [self createWithDictionaryWorker:dictionary];
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
