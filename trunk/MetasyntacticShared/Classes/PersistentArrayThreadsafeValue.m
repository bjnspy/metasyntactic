//
//  PersistentThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersistentThreadsafeValue.h"

#import "FileUtilities.h"

@interface PersistentArrayThreadsafeValue()
@end


@implementation PersistentArrayThreadsafeValue

+ (PersistentArrayThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                        file:(NSString*) file {
  return [[[PersistentArrayThreadsafeValue alloc] initWithGate:gate
                                                          file:file] autorelease];
}


- (NSArray*) loadFromFile {
  NSArray* result = [FileUtilities readObject:file];
  if (result.count == 0) {
    return [NSArray array];
  }
  return result;
}


- (void) saveToFile:(NSArray*) object {
  [FileUtilities writeObject:object toFile:file];
}

@end
