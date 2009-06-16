//
//  PersistentSetThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersistentSetThreadsafeValue.h"

#import "FileUtilities.h"

@implementation PersistentSetThreadsafeValue

+ (PersistentSetThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                        file:(NSString*) file {
  return [[[PersistentSetThreadsafeValue alloc] initWithGate:gate file:file] autorelease];
}


- (NSSet*) loadFromFile {
  NSArray* array = [FileUtilities readObject:file];
  if (array.count == 0) {
    return [NSSet set];
  }
  return [NSSet setWithArray:array];
}


- (void) saveToFile:(NSSet*) set {
  [FileUtilities writeObject:set.allObjects toFile:file];
}

@end
