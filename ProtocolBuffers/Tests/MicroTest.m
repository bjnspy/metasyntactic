//
//  MicroTest.m
//  ProtocolBuffers
//
//  Created by David Symonds on 8/10/08.
//  Copyright 2008 Google Inc. All rights reserved.
//

#import "MicroTest.h"


@implementation MicroTest

- (void)testIntegers {
  STAssertNil(nil, @"nil should be nil");
  STAssertEquals(2, 2, @"2 should equal 2");
}

@end
