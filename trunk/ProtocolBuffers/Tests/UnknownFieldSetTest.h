//
//  UnknownFieldSetTest.h
//  ProtocolBuffers-Test
//
//  Created by Cyrus Najmabadi on 10/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class PBDescriptor;
@class PBUnknownFieldSet;
@class TestAllTypes;
@class TestEmptyMessage;

@interface UnknownFieldSetTest : SenTestCase {
  PBDescriptor* descriptor;
  TestAllTypes* allFields;
  NSData* allFieldsData;
  
  // An empty message that has been parsed from allFieldsData.  So, it has
  // unknown fields of every type.
  TestEmptyMessage* emptyMessage;
  PBUnknownFieldSet* unknownFields;
}

@property (retain) PBDescriptor* descriptor;
@property (retain) TestAllTypes* allFields;
@property (retain) NSData* allFieldsData;

// An empty message that has been parsed from allFieldsData.  So, it has
// unknown fields of every type.
@property (retain) TestEmptyMessage* emptyMessage;
@property (retain) PBUnknownFieldSet* unknownFields;

+ (void) runAllTests;

@end
