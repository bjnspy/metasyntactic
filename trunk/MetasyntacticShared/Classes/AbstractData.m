//
//  AbstractData.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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


+ (id) newWithDictionary:(NSDictionary*) dictionary {
  return nil;
}


+ (NSArray*) decodeArray:(NSArray*) values {
  if (values.count == 0) {
    return [NSArray array];
  }

  NSMutableArray* result = [NSMutableArray array];
  for (NSDictionary* dictionary in values) {
    id value = [self newWithDictionary:dictionary];
    if (value != nil) {
      [result addObject:value];
    }
  }
  
  return result;
}

@end