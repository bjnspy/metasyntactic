//
//  PersistentThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PersistentThreadsafeValue.h"

#import "FileUtilities.h"

@interface PersistentThreadsafeValue()
@property (retain) NSString* file;
@end


@implementation PersistentThreadsafeValue

@synthesize file;

- (void) dealloc {
  self.file = nil;
  [super dealloc];
}


- (id) initWithGate:(id<NSLocking>) gate file:(NSString*) file_ {
  if ((self = [super initWithGate:gate
                         delegate:self
                     loadSelector:@selector(loadFromFile)
                     saveSelector:@selector(saveToFile:)])) {
    self.file = file_;
  }
  return self;
}


+ (PersistentThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                        file:(NSString*) file {
  return [[[PersistentThreadsafeValue alloc] initWithGate:gate file:file] autorelease];
}


- (id) loadFromFile {
  return [FileUtilities readObject:file];
}


- (void) saveToFile:(id) object {
  [FileUtilities writeObject:object toFile:file];
}

@end
