//
//  PersistentThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersistentDictionaryThreadsafeValue.h"

#import "FileUtilities.h"

@interface PersistentDictionaryThreadsafeValue()
@end


@implementation PersistentDictionaryThreadsafeValue

+ (PersistentDictionaryThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                             file:(NSString*) file {
  return [[[PersistentDictionaryThreadsafeValue alloc] initWithGate:gate
                                                          file:file] autorelease];
}


- (NSDictionary*) loadFromFile {
  NSDictionary* result = [FileUtilities readObject:file];
  if (result.count == 0) {
    return [NSDictionary dictionary];
  }
  return result;
}


- (void) saveToFile:(NSDictionary*) object {
  [FileUtilities writeObject:object toFile:file];
}

@end
