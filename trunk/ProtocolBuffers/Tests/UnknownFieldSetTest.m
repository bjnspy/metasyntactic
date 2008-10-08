//
//  UnknownFieldSetTest.m
//  ProtocolBuffers-Test
//
//  Created by Cyrus Najmabadi on 10/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UnknownFieldSetTest.h"

#import "TestUtilities.h"
#import "Unittest.pb.h"
#import "Macros.h"

@implementation UnknownFieldSetTest

@synthesize descriptor;
@synthesize allFields;
@synthesize allFieldsData;
@synthesize emptyMessage;
@synthesize unknownFields;

- (void) dealloc {
  self.descriptor = nil;
  self.allFields = nil;
  self.allFieldsData = nil;
  self.emptyMessage = nil;
  self.unknownFields = nil;
  [super dealloc];
}


- (void) setUp {
  self.descriptor = [TestAllTypes descriptor];
  self.allFields = [TestUtilities allSet];
  self.allFieldsData = [allFields toData];
  self.emptyMessage = [TestEmptyMessage parseFromData:allFieldsData];
  self.unknownFields = emptyMessage.unknownFields;
}


- (id) init {
  if (self = [super init]) {
    [self setUp];
  }
  return self;
}


- (PBField*) getField:(NSString*) name {
  PBFieldDescriptor* field = [descriptor findFieldByName:name];
  STAssertTrue(field != nil, @"");
  return [unknownFields getField:field.number];
}


// Constructs a protocol buffer which contains fields with all the same
// numbers as allFieldsData except that each field is some other wire
// type.
- (NSData*) getBizarroData {
  PBUnknownFieldSet_Builder* bizarroFields = [PBUnknownFieldSet newBuilder];
  
  PBField* varintField = [[PBMutableField field] addVarint:1];
  PBField* fixed32Field = [[PBMutableField field] addFixed32:1];
  
  for (NSNumber* key in unknownFields.fields) {
    PBField* field = [unknownFields.fields objectForKey:key];
    if (field.varintList.count == 0) {
      // Original field is not a varint, so use a varint.
      [bizarroFields addField:varintField forNumber:key.intValue];
    } else {
      // Original field *is* a varint, so use something else.
      [bizarroFields addField:fixed32Field forNumber:key.intValue];
    }
  }
  
  return [[bizarroFields build] toData];
}

// =================================================================

- (void) testVarint {
  PBField* field = [self getField:@"optional_int32"];
  STAssertTrue(1 == field.varintList.count, @"");
  STAssertTrue(allFields.optionalInt32 == [[field.varintList objectAtIndex:0] intValue], @"");
}


- (void) testFixed32 {
  PBField* field = [self getField:@"optional_fixed32"];
  STAssertTrue(1 == field.fixed32List.count, @"");
  STAssertTrue(allFields.optionalFixed32 == [[field.fixed32List objectAtIndex:0] intValue], @"");
}


- (void) testFixed64 {
  PBField* field = [self getField:@"optional_fixed64"];
  STAssertTrue(1 == field.fixed64List.count, @"");
  STAssertTrue(allFields.optionalFixed64 == [[field.fixed64List objectAtIndex:0] longLongValue], @"");
}


- (void) testLengthDelimited {
  PBField* field = [self getField:@"optional_bytes"];
  STAssertTrue(1 == field.lengthDelimitedList.count, @"");
  STAssertTrue([allFields.optionalBytes isEqual:[field.lengthDelimitedList objectAtIndex:0]], @"");
}

- (void) testGroup {
  PBFieldDescriptor* nestedFieldDescriptor =
  [[TestAllTypes_OptionalGroup descriptor] findFieldByName:@"a"];
  STAssertTrue(nestedFieldDescriptor != nil, @"");
  
  PBField* field = [self getField:@"optionalgroup"];
  STAssertTrue(1 == field.groupList.count, @"");
  
  PBUnknownFieldSet* group = [field.groupList objectAtIndex:0];
  STAssertTrue(1 == group.fields.count, @"");
  STAssertTrue([group hasField:nestedFieldDescriptor.number], @"");
  
  PBField* nestedField =
  [group getField:nestedFieldDescriptor.number];
  STAssertTrue(1 == nestedField.varintList.count, @"");
  STAssertTrue(allFields.optionalGroup.a == [[nestedField.varintList objectAtIndex:0] intValue], @"");
}


- (void) testSerialize {
    // Check that serializing the UnknownFieldSet produces the original data
    // again.
    NSData* data = [emptyMessage toData];
    STAssertEqualObjects(allFieldsData, data, @"");
}


- (void) testCopyFrom {
    TestEmptyMessage* message =
    [[[TestEmptyMessage newBuilder] mergeFromMessage:emptyMessage] build];
    
    STAssertEqualObjects(emptyMessage.toData, message.toData, @"");
}


- (void) testMergeFrom {
    PBUnknownFieldSet* set1 =
    [[[[PBUnknownFieldSet newBuilder]
       addField:[[PBMutableField field] addVarint:2] forNumber:2]
      addField:[[PBMutableField field] addVarint:4] forNumber:3] build];
    
    PBUnknownFieldSet* set2 = 
    [[[[PBUnknownFieldSet newBuilder]
       addField:[[PBMutableField field] addVarint:1] forNumber:1]
      addField:[[PBMutableField field] addVarint:3] forNumber:3] build];
    
    PBUnknownFieldSet* set3 =
    [[[[PBUnknownFieldSet newBuilder]
       addField:[[PBMutableField field] addVarint:1] forNumber:1]
      addField:[[PBMutableField field] addVarint:4] forNumber:3] build];
    
    PBUnknownFieldSet* set4 = 
    [[[[PBUnknownFieldSet newBuilder]
       addField:[[PBMutableField field] addVarint:2] forNumber:2]
      addField:[[PBMutableField field] addVarint:3] forNumber:3] build];
    
    TestEmptyMessage* source1 = (id)[[[TestEmptyMessage newBuilder] setUnknownFields:set1] build];
    TestEmptyMessage* source2 = (id)[[[TestEmptyMessage newBuilder] setUnknownFields:set2] build];
    TestEmptyMessage* source3 = (id)[[[TestEmptyMessage newBuilder] setUnknownFields:set3] build];
    TestEmptyMessage* source4 = (id)[[[TestEmptyMessage newBuilder] setUnknownFields:set4] build];
    
    TestEmptyMessage* destination1 = (id)[[[[TestEmptyMessage newBuilder] mergeFromMessage:source1] mergeFromMessage:source2] build];
    TestEmptyMessage* destination2 = (id)[[[[TestEmptyMessage newBuilder] mergeFromMessage:source3] mergeFromMessage:source4] build];
    
    STAssertEqualObjects(destination1.toData, destination2.toData, @"");
}


- (void) testClear {
    PBUnknownFieldSet* fields = 
    [[[[PBUnknownFieldSet newBuilder] mergeUnknownFields:unknownFields] clear] build];
    STAssertEquals(fields.fields.count, (NSUInteger) 0, @"");
}


- (void) testClearMessage {
    TestEmptyMessage* message =
    [[[[TestEmptyMessage newBuilder] mergeFromMessage:emptyMessage] clear] build];
    STAssertTrue(0 == message.serializedSize, @"");
}


- (void) testParseKnownAndUnknown {
    // Test mixing known and unknown fields when parsing.
    
    PBUnknownFieldSet* fields = 
    [[[PBUnknownFieldSet newBuilder:unknownFields] addField:[[PBMutableField field] addVarint:654321]
                                                 forNumber:123456] build];
    
    NSData* data = fields.toData;
    TestAllTypes* destination = [TestAllTypes parseFromData:data];
    
    [TestUtilities assertAllFieldsSet:destination];
    STAssertTrue(1 == destination.unknownFields.fields.count, @"");
    
    PBField* field = [destination.unknownFields getField:123456];
    STAssertTrue(1 == field.varintList.count, @"");
    STAssertTrue(654321 == [[field.varintList objectAtIndex:0] longLongValue], @"");
}


- (void) testWrongTypeTreatedAsUnknown {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing.
    
    NSData* bizarroData = [self getBizarroData];
    TestAllTypes* allTypesMessage = [TestAllTypes parseFromData:bizarroData];
    TestEmptyMessage* emptyMessage_ = [TestEmptyMessage parseFromData:bizarroData];
    
    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    STAssertEqualObjects(emptyMessage_.toData, allTypesMessage.toData, @"");
}


- (void) testUnknownExtensions {
    // Make sure fields are properly parsed to the UnknownFieldSet even when
    // they are declared as extension numbers.
    
    TestEmptyMessageWithExtensions* message =
    [TestEmptyMessageWithExtensions parseFromData:allFieldsData];
    
    STAssertTrue(unknownFields.fields.count ==  message.unknownFields.fields.count, @"");
    STAssertEqualObjects(allFieldsData, message.toData, @"");
}


- (void) testWrongExtensionTypeTreatedAsUnknown {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing extensions.
    
    NSData* bizarroData = [self getBizarroData];
    TestAllExtensions* allExtensionsMessage = [TestAllExtensions parseFromData:bizarroData];
    TestEmptyMessage* emptyMessage_ = [TestEmptyMessage parseFromData:bizarroData];
    
    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    STAssertEqualObjects(emptyMessage_.toData, allExtensionsMessage.toData, @"");
}

#if 0





public void testParseUnknownEnumValue() throws Exception {
  Descriptors.FieldDescriptor singularField =
  TestAllTypes.getDescriptor().findFieldByName("optional_nested_enum");
  Descriptors.FieldDescriptor repeatedField =
  TestAllTypes.getDescriptor().findFieldByName("repeated_nested_enum");
  assertNotNull(singularField);
  assertNotNull(repeatedField);
  
  ByteString data =
  UnknownFieldSet.newBuilder()
  .addField(singularField.getNumber(),
            UnknownFieldSet.Field.newBuilder()
            .addVarint(TestAllTypes.NestedEnum.BAR.getNumber())
            .addVarint(5)   // not valid
            .build())
  .addField(repeatedField.getNumber(),
            UnknownFieldSet.Field.newBuilder()
            .addVarint(TestAllTypes.NestedEnum.FOO.getNumber())
            .addVarint(4)   // not valid
            .addVarint(TestAllTypes.NestedEnum.BAZ.getNumber())
            .addVarint(6)   // not valid
            .build())
  .build()
  .toByteString();
  
  {
    TestAllTypes message = TestAllTypes.parseFrom(data);
    STAssertTrue(TestAllTypes.NestedEnum.BAR,
             message.getOptionalNestedEnum());
    STAssertTrue(
             Arrays.asList(TestAllTypes.NestedEnum.FOO, TestAllTypes.NestedEnum.BAZ),
             message.getRepeatedNestedEnumList());
    STAssertTrue(Arrays.asList(5L),
             message.getUnknownFields()
             .getField(singularField.getNumber())
             .getVarintList());
    STAssertTrue(Arrays.asList(4L, 6L),
             message.getUnknownFields()
             .getField(repeatedField.getNumber())
             .getVarintList());
  }
  
  {
    TestAllExtensions message =
    TestAllExtensions.parseFrom(data, TestUtil.getExtensionRegistry());
    STAssertTrue(TestAllTypes.NestedEnum.BAR,
             message.getExtension(UnittestProto.optionalNestedEnumExtension));
    STAssertTrue(
             Arrays.asList(TestAllTypes.NestedEnum.FOO, TestAllTypes.NestedEnum.BAZ),
             message.getExtension(UnittestProto.repeatedNestedEnumExtension));
    STAssertTrue(Arrays.asList(5L),
             message.getUnknownFields()
             .getField(singularField.getNumber())
             .getVarintList());
    STAssertTrue(Arrays.asList(4L, 6L),
             message.getUnknownFields()
             .getField(repeatedField.getNumber())
             .getVarintList());
  }
}

public void testLargeVarint() throws Exception {
  ByteString data =
  UnknownFieldSet.newBuilder()
  .addField(1,
            UnknownFieldSet.Field.newBuilder()
            .addVarint(0x7FFFFFFFFFFFFFFFL)
            .build())
  .build()
  .toByteString();
  UnknownFieldSet parsed = UnknownFieldSet.parseFrom(data);
  UnknownFieldSet.Field field = parsed.getField(1);
  STAssertTrue(1, field.getVarintList().size());
  STAssertTrue(0x7FFFFFFFFFFFFFFFL, (long)field.getVarintList().get(0));
}
#endif

@end
