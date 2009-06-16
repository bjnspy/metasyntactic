//
//  AbstractPersistentThreadsafeValue.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractPersistentThreadsafeValue.h"

@interface AbstractPersistentThreadsafeValue()
@property (retain) NSString* file;
@end


@implementation AbstractPersistentThreadsafeValue

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

@end
