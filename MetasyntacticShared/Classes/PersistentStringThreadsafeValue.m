//
//  PersistentStringThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersistentStringThreadsafeValue.h"

#import "FileUtilities.h"

@implementation PersistentStringThreadsafeValue

+ (PersistentStringThreadsafeValue*) valueWithGate:(id<NSLocking>) gate file:(NSString*) file {
  return [[[PersistentStringThreadsafeValue alloc] initWithGate:gate file:file] autorelease];
}


- (NSString*) loadFromFile {
  NSString* result = [FileUtilities readObject:file];
  if (result.length == 0) {
    return @"";
  }
  return result;
}


- (void) saveToFile:(NSString*) object {
  [FileUtilities writeObject:object toFile:file];
}

@end
