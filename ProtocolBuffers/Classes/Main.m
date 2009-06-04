//
//  Main.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnknownFieldSetTest.h"

int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  // insert code here...
  NSLog(@"Hello, World!");
  
  UnknownFieldSetTest* tests = [[[UnknownFieldSetTest alloc] init] autorelease];
  [tests testUnknownExtensions];
  
  [pool drain];
  return 0;
}
