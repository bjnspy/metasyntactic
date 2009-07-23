//
//  MemoryUtilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 7/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

void* CFAutoRelease(CFTypeRef val) {
  [NSAutoreleasePool addObject:(NSObject*)val];
  return (void*)val;
}
