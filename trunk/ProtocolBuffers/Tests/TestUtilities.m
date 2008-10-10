//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "TestUtilities.h"

#import "Unittest.pb.h"

@implementation TestUtilities

+ (NSData*) toData:(NSString*) str {
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}



/**
 * Assert (using {@code junit.framework.Assert}} that all extensions of
 * {@code message} are set to the values assigned by {@code setAllExtensions}.
 */
- (void) assertAllExtensionsSet:(TestAllExtensions*) message {
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalInt64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalUint32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalUint64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalSint32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalSint64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalFixed32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalFixed64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalSfixed32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalSfixed64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalFloatExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalDoubleExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalBoolExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalStringExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalGroupExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalNestedMessageExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalForeignMessageExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalImportMessageExtension]], @"");
    
    STAssertTrue([[message getExtension:[UnittestProtoRoot optionalGroupExtension]] hasA], @"");
    STAssertTrue([[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] hasBb], @"");
    STAssertTrue([[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] hasC], @"");
    STAssertTrue([[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] hasD], @"");
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot optionalCordExtension]], @"");
    
    STAssertTrue(101 == [[message getExtension:[UnittestProtoRoot optionalInt32Extension]] intValue], @"");
    STAssertTrue(102L == [[message getExtension:[UnittestProtoRoot optionalInt64Extension]] intValue], @"");
    STAssertTrue(103 == [[message getExtension:[UnittestProtoRoot optionalUint32Extension]] intValue], @"");
    STAssertTrue(104L == [[message getExtension:[UnittestProtoRoot optionalUint64Extension]] intValue], @"");
    STAssertTrue(105 == [[message getExtension:[UnittestProtoRoot optionalSint32Extension]] intValue], @"");
    STAssertTrue(106L == [[message getExtension:[UnittestProtoRoot optionalSint64Extension]] intValue], @"");
    STAssertTrue(107 == [[message getExtension:[UnittestProtoRoot optionalFixed32Extension]] intValue], @"");
    STAssertTrue(108L == [[message getExtension:[UnittestProtoRoot optionalFixed64Extension]] intValue], @"");
    STAssertTrue(109 == [[message getExtension:[UnittestProtoRoot optionalSfixed32Extension]] intValue], @"");
    STAssertTrue(110L == [[message getExtension:[UnittestProtoRoot optionalSfixed64Extension]] intValue], @"");
    STAssertTrue(111.0 == [[message getExtension:[UnittestProtoRoot optionalFloatExtension]] floatValue], @"");
    STAssertTrue(112.0 == [[message getExtension:[UnittestProtoRoot optionalDoubleExtension]] doubleValue], @"");
    STAssertTrue(true == [[message getExtension:[UnittestProtoRoot optionalBoolExtension]] boolValue], @"");
    STAssertEqualObjects(@"115", [message getExtension:[UnittestProtoRoot optionalStringExtension]], @"");
    STAssertEqualObjects([TestUtilities toData:@"116"], [message getExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
    
    STAssertTrue(117 == [[message getExtension:[UnittestProtoRoot optionalGroupExtension]] a], @"");
    STAssertTrue(118 == [[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] bb], @"");
    STAssertTrue(119 == [[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] c], @"");
    STAssertTrue(120 == [[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] d], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == [message getExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == [message getExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == [message getExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
    
     STAssertEqualObjects(@"124", [message getExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
     STAssertEqualObjects(@"125", [message getExtension:[UnittestProtoRoot optionalCordExtension]], @"");
    
    // -----------------------------------------------------------------
    
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]], @"");
    
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]], @"");
    
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]], @"");
    STAssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]], @"");
    
    STAssertTrue(201 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:0] intValue], @"");;
    STAssertTrue(202L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:0] intValue], @"");;
    STAssertTrue(203 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:0] intValue], @"");;
    STAssertTrue(204L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:0] intValue], @"");
    STAssertTrue(205 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:0] intValue], @"");
    STAssertTrue(206L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:0] intValue], @"");
    STAssertTrue(207 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:0] intValue], @"");
    STAssertTrue(208L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:0] intValue], @"");
    STAssertTrue(209 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:0] intValue], @"");
    STAssertTrue(210L == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:0] intValue], @"");
    STAssertTrue(211.0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension] index:0] floatValue], @"");
    STAssertTrue(212.0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension] index:0] doubleValue], @"");
    STAssertTrue(true == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension] index:0] boolValue], @"");
    STAssertEqualObjects(@"215", [message getExtension:[UnittestProtoRoot repeatedStringExtension] index:0], @"");
    STAssertEqualObjects([TestUtilities toData:@"216"], [message getExtension:[UnittestProtoRoot repeatedBytesExtension] index:0], @"");
    
    STAssertTrue(217 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension] index:0] a], @"");
    STAssertTrue(218 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:0] bb], @"");
    STAssertTrue(219 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:0] c], @"");
    STAssertTrue(220 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:0] d], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] == [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:0], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] == [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:0], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] == [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:0], @"");
    
    STAssertEqualObjects(@"224", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:0], @"");
    STAssertEqualObjects(@"225", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:0], @"");
    
    STAssertTrue(301 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:1] intValue], @"");
    STAssertTrue(302L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:1] intValue], @"");
    STAssertTrue(303 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:1] intValue], @"");
    STAssertTrue(304L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:1] intValue], @"");
    STAssertTrue(305 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:1] intValue], @"");
    STAssertTrue(306L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:1] intValue], @"");
    STAssertTrue(307 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:1] intValue], @"");
    STAssertTrue(308L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:1] intValue], @"");
    STAssertTrue(309 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:1] intValue], @"");
    STAssertTrue(310L == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:1] intValue], @"");
    STAssertTrue(311.0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension] index:1] floatValue], @"");
    STAssertTrue(312.0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension] index:1] doubleValue], @"");
    STAssertTrue(false == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension] index:1] boolValue], @"");
    STAssertEqualObjects(@"315", [message getExtension:[UnittestProtoRoot repeatedStringExtension] index:1], @"");
    STAssertEqualObjects([TestUtilities toData:@"316"], [message getExtension:[UnittestProtoRoot repeatedBytesExtension] index:1], @"");
    
    STAssertTrue(317 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension] index:1] a], @"");
    STAssertTrue(318 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:1] bb], @"");
    STAssertTrue(319 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:1] c], @"");
    STAssertTrue(320 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:1] d], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:1], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:1], @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:1], @"");
    
    STAssertEqualObjects(@"324", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:1], @"");
    STAssertEqualObjects(@"325", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:1], @"");
    
    // -----------------------------------------------------------------
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultInt32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultInt64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultUint32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultUint64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultSint32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultSint64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultFixed32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultFixed64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultSfixed32Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultSfixed64Extension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultFloatExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultDoubleExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultBoolExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultStringExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
    
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
    STAssertTrue([message hasExtension:[UnittestProtoRoot defaultCordExtension]], @"");
    
    STAssertTrue(401 == [[message getExtension:[UnittestProtoRoot defaultInt32Extension]] intValue], @"");
    STAssertTrue(402L == [[message getExtension:[UnittestProtoRoot defaultInt64Extension]] intValue], @"");
    STAssertTrue(403 == [[message getExtension:[UnittestProtoRoot defaultUint32Extension]] intValue], @"");
    STAssertTrue(404L == [[message getExtension:[UnittestProtoRoot defaultUint64Extension]] intValue], @"");
    STAssertTrue(405 == [[message getExtension:[UnittestProtoRoot defaultSint32Extension]] intValue], @"");
    STAssertTrue(406L == [[message getExtension:[UnittestProtoRoot defaultSint64Extension]] intValue], @"");
    STAssertTrue(407 == [[message getExtension:[UnittestProtoRoot defaultFixed32Extension]] intValue], @"");
    STAssertTrue(408L == [[message getExtension:[UnittestProtoRoot defaultFixed64Extension]] intValue], @"");
    STAssertTrue(409 == [[message getExtension:[UnittestProtoRoot defaultSfixed32Extension]] intValue], @"");
    STAssertTrue(410L == [[message getExtension:[UnittestProtoRoot defaultSfixed64Extension]] intValue], @"");
    STAssertTrue(411.0 == [[message getExtension:[UnittestProtoRoot defaultFloatExtension]] floatValue], @"");
    STAssertTrue(412.0 == [[message getExtension:[UnittestProtoRoot defaultDoubleExtension]] doubleValue], @"");
    STAssertTrue(false == [[message getExtension:[UnittestProtoRoot defaultBoolExtension]] boolValue], @"");
    STAssertEqualObjects(@"415", [message getExtension:[UnittestProtoRoot defaultStringExtension]], @"");
    STAssertEqualObjects([TestUtilities toData:@"416"], [message getExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum FOO] == [message getExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == [message getExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
    STAssertTrue([ImportEnum IMPORT_FOO] == [message getExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
    
    STAssertEqualObjects(@"424", [message getExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
    STAssertEqualObjects(@"425", [message getExtension:[UnittestProtoRoot defaultCordExtension]], @"");
}

+ (void) assertAllExtensionsSet:(TestAllExtensions*) message {
    return [[[[TestUtilities alloc] init] autorelease] assertAllExtensionsSet:message];
}


// -------------------------------------------------------------------

/**
 * Assert (using {@code junit.framework.Assert}} that all fields of
 * {@code message} are set to the values assigned by {@code setAllFields}.
 */
- (void) assertAllFieldsSet:(TestAllTypes*) message {
    
    STAssertTrue(message.hasOptionalInt32, @"");
    STAssertTrue(message.hasOptionalInt64, @"");
    STAssertTrue(message.hasOptionalUint32, @"");
    STAssertTrue(message.hasOptionalUint64, @"");
    STAssertTrue(message.hasOptionalSint32, @"");
    STAssertTrue(message.hasOptionalSint64, @"");
    STAssertTrue(message.hasOptionalFixed32, @"");
    STAssertTrue(message.hasOptionalFixed64, @"");
    STAssertTrue(message.hasOptionalSfixed32, @"");
    STAssertTrue(message.hasOptionalSfixed64, @"");
    STAssertTrue(message.hasOptionalFloat, @"");
    STAssertTrue(message.hasOptionalDouble, @"");
    STAssertTrue(message.hasOptionalBool, @"");
    STAssertTrue(message.hasOptionalString, @"");
    STAssertTrue(message.hasOptionalBytes, @"");
    
    STAssertTrue(message.hasOptionalGroup, @"");
    STAssertTrue(message.hasOptionalNestedMessage, @"");
    STAssertTrue(message.hasOptionalForeignMessage, @"");
    STAssertTrue(message.hasOptionalImportMessage, @"");
    
    STAssertTrue(message.optionalGroup.hasA, @"");
    STAssertTrue(message.optionalNestedMessage.hasBb, @"");
    STAssertTrue(message.optionalForeignMessage.hasC, @"");
    STAssertTrue(message.optionalImportMessage.hasD, @"");
    
    STAssertTrue(message.hasOptionalNestedEnum, @"");
    STAssertTrue(message.hasOptionalForeignEnum, @"");
    STAssertTrue(message.hasOptionalImportEnum, @"");
    
    STAssertTrue(message.hasOptionalStringPiece, @"");
    STAssertTrue(message.hasOptionalCord, @"");
    
    STAssertTrue(101 == message.optionalInt32, @"");
    STAssertTrue(102 == message.optionalInt64, @"");
    STAssertTrue(103 == message.optionalUint32, @"");
    STAssertTrue(104 == message.optionalUint64, @"");
    STAssertTrue(105 == message.optionalSint32, @"");
    STAssertTrue(106 == message.optionalSint64, @"");
    STAssertTrue(107 == message.optionalFixed32, @"");
    STAssertTrue(108 == message.optionalFixed64, @"");
    STAssertTrue(109 == message.optionalSfixed32, @"");
    STAssertTrue(110 == message.optionalSfixed64, @"");
    STAssertEqualsWithAccuracy(111, message.optionalFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(112, message.optionalDouble, 0.1, @"");
    STAssertTrue(true == message.optionalBool, @"");
    STAssertEquals(@"115", message.optionalString, @"");
    STAssertEquals([TestUtilities toData:@"116"], message.optionalBytes, @"");
    
    STAssertTrue(117 == message.optionalGroup.a, @"");
    STAssertTrue(118 == message.optionalNestedMessage.bb, @"");
    STAssertTrue(119 == message.optionalForeignMessage.c, @"");
    STAssertTrue(120 == message.optionalImportMessage.d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == message.optionalNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == message.optionalForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == message.optionalImportEnum, @"");
    
    STAssertEquals(@"124", message.optionalStringPiece, @"");
    STAssertEquals(@"125", message.optionalCord, @"");
    
    // -----------------------------------------------------------------
    
    STAssertTrue(2 == message.repeatedInt32List.count, @"");
    STAssertTrue(2 == message.repeatedInt64List.count, @"");
    STAssertTrue(2 == message.repeatedUint32List.count, @"");
    STAssertTrue(2 == message.repeatedUint64List.count, @"");
    STAssertTrue(2 == message.repeatedSint32List.count, @"");
    STAssertTrue(2 == message.repeatedSint64List.count, @"");
    STAssertTrue(2 == message.repeatedFixed32List.count, @"");
    STAssertTrue(2 == message.repeatedFixed64List.count, @"");
    STAssertTrue(2 == message.repeatedSfixed32List.count, @"");
    STAssertTrue(2 == message.repeatedSfixed64List.count, @"");
    STAssertTrue(2 == message.repeatedFloatList.count, @"");
    STAssertTrue(2 == message.repeatedDoubleList.count, @"");
    STAssertTrue(2 == message.repeatedBoolList.count, @"");
    STAssertTrue(2 == message.repeatedStringList.count, @"");
    STAssertTrue(2 == message.repeatedBytesList.count, @"");
    
    STAssertTrue(2 == message.repeatedGroupList.count, @"");
    STAssertTrue(2 == message.repeatedNestedMessageList.count, @"");
    STAssertTrue(2 == message.repeatedForeignMessageList.count, @"");
    STAssertTrue(2 == message.repeatedImportMessageList.count, @"");
    STAssertTrue(2 == message.repeatedNestedEnumList.count, @"");
    STAssertTrue(2 == message.repeatedForeignEnumList.count, @"");
    STAssertTrue(2 == message.repeatedImportEnumList.count, @"");
    
    STAssertTrue(2 == message.repeatedStringPieceList.count, @"");
    STAssertTrue(2 == message.repeatedCordList.count, @"");
    
    STAssertTrue(201 == [message repeatedInt32AtIndex:0], @"");
    STAssertTrue(202 == [message repeatedInt64AtIndex:0], @"");
    STAssertTrue(203 == [message repeatedUint32AtIndex:0], @"");
    STAssertTrue(204 == [message repeatedUint64AtIndex:0], @"");
    STAssertTrue(205 == [message repeatedSint32AtIndex:0], @"");
    STAssertTrue(206 == [message repeatedSint64AtIndex:0], @"");
    STAssertTrue(207 == [message repeatedFixed32AtIndex:0], @"");
    STAssertTrue(208 == [message repeatedFixed64AtIndex:0], @"");
    STAssertTrue(209 == [message repeatedSfixed32AtIndex:0], @"");
    STAssertTrue(210 == [message repeatedSfixed64AtIndex:0], @"");
    STAssertEqualsWithAccuracy(211, [message repeatedFloatAtIndex:0], 0.1, @"");
    STAssertEqualsWithAccuracy(212, [message repeatedDoubleAtIndex:0], 0.1, @"");
    STAssertTrue(true == [message repeatedBoolAtIndex:0], @"");
    STAssertEquals(@"215", [message repeatedStringAtIndex:0], @"");
    STAssertEquals([TestUtilities toData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    STAssertTrue(217 == [message repeatedGroupAtIndex:0].a, @"");
    STAssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    STAssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    STAssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
    
    STAssertEquals(@"224", [message repeatedStringPieceAtIndex:0], @"");
    STAssertEquals(@"225", [message repeatedCordAtIndex:0], @"");
    
    STAssertTrue(301 == [message repeatedInt32AtIndex:1], @"");
    STAssertTrue(302 == [message repeatedInt64AtIndex:1], @"");
    STAssertTrue(303 == [message repeatedUint32AtIndex:1], @"");
    STAssertTrue(304 == [message repeatedUint64AtIndex:1], @"");
    STAssertTrue(305 == [message repeatedSint32AtIndex:1], @"");
    STAssertTrue(306 == [message repeatedSint64AtIndex:1], @"");
    STAssertTrue(307 == [message repeatedFixed32AtIndex:1], @"");
    STAssertTrue(308 == [message repeatedFixed64AtIndex:1], @"");
    STAssertTrue(309 == [message repeatedSfixed32AtIndex:1], @"");
    STAssertTrue(310 == [message repeatedSfixed64AtIndex:1], @"");
    STAssertEqualsWithAccuracy(311, [message repeatedFloatAtIndex:1], 0.1, @"");
    STAssertEqualsWithAccuracy(312, [message repeatedDoubleAtIndex:1], 0.1, @"");
    STAssertTrue(false == [message repeatedBoolAtIndex:1], @"");
    STAssertEquals(@"315", [message repeatedStringAtIndex:1], @"");
    STAssertEquals([TestUtilities toData:@"316"], [message repeatedBytesAtIndex:1], @"");
    
    STAssertTrue(317 == [message repeatedGroupAtIndex:1].a, @"");
    STAssertTrue(318 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    STAssertTrue(319 == [message repeatedForeignMessageAtIndex:1].c, @"");
    STAssertTrue(320 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == [message repeatedNestedEnumAtIndex:1], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == [message repeatedForeignEnumAtIndex:1], @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == [message repeatedImportEnumAtIndex:1], @"");
    
    STAssertEquals(@"324", [message repeatedStringPieceAtIndex:1], @"");
    STAssertEquals(@"325", [message repeatedCordAtIndex:1], @"");
    
    // -----------------------------------------------------------------
    
    STAssertTrue(message.hasDefaultInt32, @"");
    STAssertTrue(message.hasDefaultInt64, @"");
    STAssertTrue(message.hasDefaultUint32, @"");
    STAssertTrue(message.hasDefaultUint64, @"");
    STAssertTrue(message.hasDefaultSint32, @"");
    STAssertTrue(message.hasDefaultSint64, @"");
    STAssertTrue(message.hasDefaultFixed32, @"");
    STAssertTrue(message.hasDefaultFixed64, @"");
    STAssertTrue(message.hasDefaultSfixed32, @"");
    STAssertTrue(message.hasDefaultSfixed64, @"");
    STAssertTrue(message.hasDefaultFloat, @"");
    STAssertTrue(message.hasDefaultDouble, @"");
    STAssertTrue(message.hasDefaultBool, @"");
    STAssertTrue(message.hasDefaultString, @"");
    STAssertTrue(message.hasDefaultBytes, @"");
    
    STAssertTrue(message.hasDefaultNestedEnum, @"");
    STAssertTrue(message.hasDefaultForeignEnum, @"");
    STAssertTrue(message.hasDefaultImportEnum, @"");
    
    STAssertTrue(message.hasDefaultStringPiece, @"");
    STAssertTrue(message.hasDefaultCord, @"");
    
    STAssertTrue(401 == message.defaultInt32, @"");
    STAssertTrue(402 == message.defaultInt64, @"");
    STAssertTrue(403 == message.defaultUint32, @"");
    STAssertTrue(404 == message.defaultUint64, @"");
    STAssertTrue(405 == message.defaultSint32, @"");
    STAssertTrue(406 == message.defaultSint64, @"");
    STAssertTrue(407 == message.defaultFixed32, @"");
    STAssertTrue(408 == message.defaultFixed64, @"");
    STAssertTrue(409 == message.defaultSfixed32, @"");
    STAssertTrue(410 == message.defaultSfixed64, @"");
    STAssertEqualsWithAccuracy(411, message.defaultFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(412, message.defaultDouble, 0.1, @"");
    STAssertTrue(false == message.defaultBool, @"");
    STAssertEquals(@"415", message.defaultString, @"");
    STAssertEquals([TestUtilities toData:@"416"], message.defaultBytes, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum FOO] == message.defaultNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == message.defaultForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_FOO] == message.defaultImportEnum, @"");
    
    STAssertEquals(@"424", message.defaultStringPiece, @"");
    STAssertEquals(@"425", message.defaultCord, @"");
}

+ (void) assertAllFieldsSet:(TestAllTypes*) message {
    [[[[TestUtilities alloc] init] autorelease] assertAllFieldsSet:message];
}


+ (void) setAllFields:(TestAllTypes_Builder*) message {
    [message setOptionalInt32:101];
    [message setOptionalInt64:102];
    [message setOptionalUint32:103];
    [message setOptionalUint64:104];
    [message setOptionalSint32:105];
    [message setOptionalSint64:106];
    [message setOptionalFixed32:107];
    [message setOptionalFixed64:108];
    [message setOptionalSfixed32:109];
    [message setOptionalSfixed64:110];
    [message setOptionalFloat:111];
    [message setOptionalDouble:112];
    [message setOptionalBool:true];
    [message setOptionalString:@"115"];
    [message setOptionalBytes:[self toData:@"116"]];
    
    [message setOptionalGroup:[[[TestAllTypes_OptionalGroup_Builder builder] setA:117] build]];
    [message setOptionalNestedMessage:[[[TestAllTypes_NestedMessage_Builder builder] setBb:118] build]];
    [message setOptionalForeignMessage:[[[ForeignMessage_Builder builder] setC:119] build]];
    [message setOptionalImportMessage:[[[ImportMessage_Builder builder] setD:120] build]];
    
    [message setOptionalNestedEnum:[TestAllTypes_NestedEnum BAZ]];
    [message setOptionalForeignEnum:[ForeignEnum FOREIGN_BAZ]];
    [message setOptionalImportEnum:[ImportEnum IMPORT_BAZ]];
    
    [message setOptionalStringPiece:@"124"];
    [message setOptionalCord:@"125"];
    
    // -----------------------------------------------------------------
    
    [message addRepeatedInt32   :201];
    [message addRepeatedInt64   :202];
    [message addRepeatedUint32  :203];
    [message addRepeatedUint64  :204];
    [message addRepeatedSint32  :205];
    [message addRepeatedSint64  :206];
    [message addRepeatedFixed32 :207];
    [message addRepeatedFixed64 :208];
    [message addRepeatedSfixed32:209];
    [message addRepeatedSfixed64:210];
    [message addRepeatedFloat   :211];
    [message addRepeatedDouble  :212];
    [message addRepeatedBool    :true];
    [message addRepeatedString  :@"215"];
    [message addRepeatedBytes   :[self toData:@"216"]];
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup_Builder builder] setA:217] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage_Builder builder] setBb:218] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage_Builder builder] setC:219] build]];
    [message addRepeatedImportMessage:[[[ImportMessage_Builder builder] setD:220] build]];
    
    [message addRepeatedNestedEnum :[TestAllTypes_NestedEnum BAR]];
    [message addRepeatedForeignEnum:[ForeignEnum FOREIGN_BAR]];
    [message addRepeatedImportEnum :[ImportEnum IMPORT_BAR]];
    
    [message addRepeatedStringPiece:@"224"];
    [message addRepeatedCord:@"225"];
    
    // Add a second one of each field.
    [message addRepeatedInt32   :301];
    [message addRepeatedInt64   :302];
    [message addRepeatedUint32  :303];
    [message addRepeatedUint64  :304];
    [message addRepeatedSint32  :305];
    [message addRepeatedSint64  :306];
    [message addRepeatedFixed32 :307];
    [message addRepeatedFixed64 :308];
    [message addRepeatedSfixed32:309];
    [message addRepeatedSfixed64:310];
    [message addRepeatedFloat   :311];
    [message addRepeatedDouble  :312];
    [message addRepeatedBool    :false];
    [message addRepeatedString  :@"315"];
    [message addRepeatedBytes   :[self toData:@"316"]];
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup_Builder builder] setA:317] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage_Builder builder] setBb:318] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage_Builder builder] setC:319] build]];
    [message addRepeatedImportMessage:[[[ImportMessage_Builder builder] setD:320] build]];
    
    [message addRepeatedNestedEnum :[TestAllTypes_NestedEnum BAZ]];
    [message addRepeatedForeignEnum:[ForeignEnum FOREIGN_BAZ]];
    [message addRepeatedImportEnum :[ImportEnum IMPORT_BAZ]];
    
    [message addRepeatedStringPiece:@"324"];
    [message addRepeatedCord:@"325"];
    
    // -----------------------------------------------------------------
    
    [message setDefaultInt32   :401];
    [message setDefaultInt64   :402];
    [message setDefaultUint32  :403];
    [message setDefaultUint64  :404];
    [message setDefaultSint32  :405];
    [message setDefaultSint64  :406];
    [message setDefaultFixed32 :407];
    [message setDefaultFixed64 :408];
    [message setDefaultSfixed32:409];
    [message setDefaultSfixed64:410];
    [message setDefaultFloat   :411];
    [message setDefaultDouble  :412];
    [message setDefaultBool    :false];
    [message setDefaultString  :@"415"];
    [message setDefaultBytes   :[self toData:@"416"]];
    
    [message setDefaultNestedEnum :[TestAllTypes_NestedEnum FOO]];
    [message setDefaultForeignEnum:[ForeignEnum FOREIGN_FOO]];
    [message setDefaultImportEnum :[ImportEnum IMPORT_FOO]];
    
    [message setDefaultStringPiece:@"424"];
    [message setDefaultCord:@"425"];
}

/**
 * Set every field of {@code message} to the values expected by
 * {@code assertAllExtensionsSet()}.
 */
+ (void) setAllExtensions:(TestAllExtensions_Builder*) message {
    [message setExtension:[UnittestProtoRoot optionalInt32Extension]   value:[NSNumber numberWithInt:101]];
    [message setExtension:[UnittestProtoRoot optionalInt64Extension]   value:[NSNumber numberWithInt:102L]];
    [message setExtension:[UnittestProtoRoot optionalUint32Extension]  value:[NSNumber numberWithInt:103]];
    [message setExtension:[UnittestProtoRoot optionalUint64Extension]  value:[NSNumber numberWithInt:104L]];
    [message setExtension:[UnittestProtoRoot optionalSint32Extension]  value:[NSNumber numberWithInt:105]];
    [message setExtension:[UnittestProtoRoot optionalSint64Extension]  value:[NSNumber numberWithInt:106L]];
    [message setExtension:[UnittestProtoRoot optionalFixed32Extension] value:[NSNumber numberWithInt:107]];
    [message setExtension:[UnittestProtoRoot optionalFixed64Extension] value:[NSNumber numberWithInt:108L]];
    [message setExtension:[UnittestProtoRoot optionalSfixed32Extension] value:[NSNumber numberWithInt:109]];
    [message setExtension:[UnittestProtoRoot optionalSfixed64Extension] value:[NSNumber numberWithInt:110L]];
    [message setExtension:[UnittestProtoRoot optionalFloatExtension]   value:[NSNumber numberWithFloat:111.0]];
    [message setExtension:[UnittestProtoRoot optionalDoubleExtension]  value:[NSNumber numberWithDouble:112.0]];
    [message setExtension:[UnittestProtoRoot optionalBoolExtension]    value:[NSNumber numberWithBool:true]];
    [message setExtension:[UnittestProtoRoot optionalStringExtension]  value:@"115"];
    [message setExtension:[UnittestProtoRoot optionalBytesExtension]   value:[self toData:@"116"]];
    
    [message setExtension:[UnittestProtoRoot optionalGroupExtension]
                    value:[[[OptionalGroup_extension_Builder builder] setA:117] build]];
    [message setExtension:[UnittestProtoRoot optionalNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage_Builder builder] setBb:118] build]];
    [message setExtension:[UnittestProtoRoot optionalForeignMessageExtension]
                    value:[[[ForeignMessage_Builder builder] setC:119] build]];
    [message setExtension:[UnittestProtoRoot optionalImportMessageExtension]
                    value:[[[ImportMessage_Builder builder] setD:120] build]];
    
    [message setExtension:[UnittestProtoRoot optionalNestedEnumExtension]
                    value:[TestAllTypes_NestedEnum BAZ]];
    [message setExtension:[UnittestProtoRoot optionalForeignEnumExtension]
                    value:[ForeignEnum FOREIGN_BAZ]];
    [message setExtension:[UnittestProtoRoot optionalImportEnumExtension]
                    value:[ImportEnum IMPORT_BAZ]];
    
    [message setExtension:[UnittestProtoRoot optionalStringPieceExtension]  value:@"124"];
    [message setExtension:[UnittestProtoRoot optionalCordExtension] value:@"125"];
    
    // -----------------------------------------------------------------
    
    [message addExtension:[UnittestProtoRoot repeatedInt32Extension]    value:[NSNumber numberWithInt:201]];
    [message addExtension:[UnittestProtoRoot repeatedInt64Extension]    value:[NSNumber numberWithInt:202L]];
    [message addExtension:[UnittestProtoRoot repeatedUint32Extension]   value:[NSNumber numberWithInt:203]];
    [message addExtension:[UnittestProtoRoot repeatedUint64Extension]   value:[NSNumber numberWithInt:204L]];
    [message addExtension:[UnittestProtoRoot repeatedSint32Extension]   value:[NSNumber numberWithInt:205]];
    [message addExtension:[UnittestProtoRoot repeatedSint64Extension]   value:[NSNumber numberWithInt:206L]];
    [message addExtension:[UnittestProtoRoot repeatedFixed32Extension]  value:[NSNumber numberWithInt:207]];
    [message addExtension:[UnittestProtoRoot repeatedFixed64Extension]  value:[NSNumber numberWithInt:208L]];
    [message addExtension:[UnittestProtoRoot repeatedSfixed32Extension] value:[NSNumber numberWithInt:209]];
    [message addExtension:[UnittestProtoRoot repeatedSfixed64Extension] value:[NSNumber numberWithInt:210L]];
    [message addExtension:[UnittestProtoRoot repeatedFloatExtension]    value:[NSNumber numberWithFloat:211.0]];
    [message addExtension:[UnittestProtoRoot repeatedDoubleExtension]   value:[NSNumber numberWithDouble:212.0]];
    [message addExtension:[UnittestProtoRoot repeatedBoolExtension]     value:[NSNumber numberWithBool:true]];
    [message addExtension:[UnittestProtoRoot repeatedStringExtension]  value:@"215"];
    [message addExtension:[UnittestProtoRoot repeatedBytesExtension]   value:[self toData:@"216"]];
    
    [message addExtension:[UnittestProtoRoot repeatedGroupExtension]
                    value:[[[RepeatedGroup_extension_Builder builder] setA:217] build]];
    [message addExtension:[UnittestProtoRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage_Builder builder] setBb:218] build]];
    [message addExtension:[UnittestProtoRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage_Builder builder] setC:219] build]];
    [message addExtension:[UnittestProtoRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage_Builder builder] setD:220] build]];
    
    [message addExtension:[UnittestProtoRoot repeatedNestedEnumExtension]
                    value:[TestAllTypes_NestedEnum BAR]];
    [message addExtension:[UnittestProtoRoot repeatedForeignEnumExtension]
                    value:[ForeignEnum FOREIGN_BAR]];
    [message addExtension:[UnittestProtoRoot repeatedImportEnumExtension]
                    value:[ImportEnum IMPORT_BAR]];
    
    [message addExtension:[UnittestProtoRoot repeatedStringPieceExtension] value:@"224"];
    [message addExtension:[UnittestProtoRoot repeatedCordExtension] value:@"225"];
    
    // Add a second one of each field.
    [message addExtension:[UnittestProtoRoot repeatedInt32Extension] value:[NSNumber numberWithInt:301]];
    [message addExtension:[UnittestProtoRoot repeatedInt64Extension] value:[NSNumber numberWithInt:302L]];
    [message addExtension:[UnittestProtoRoot repeatedUint32Extension] value:[NSNumber numberWithInt:303]];
    [message addExtension:[UnittestProtoRoot repeatedUint64Extension] value:[NSNumber numberWithInt:304L]];
    [message addExtension:[UnittestProtoRoot repeatedSint32Extension] value:[NSNumber numberWithInt:305]];
    [message addExtension:[UnittestProtoRoot repeatedSint64Extension] value:[NSNumber numberWithInt:306L]];
    [message addExtension:[UnittestProtoRoot repeatedFixed32Extension] value:[NSNumber numberWithInt:307]];
    [message addExtension:[UnittestProtoRoot repeatedFixed64Extension] value:[NSNumber numberWithInt:308L]];
    [message addExtension:[UnittestProtoRoot repeatedSfixed32Extension] value:[NSNumber numberWithInt:309]];
    [message addExtension:[UnittestProtoRoot repeatedSfixed64Extension] value:[NSNumber numberWithInt:310L]];
    [message addExtension:[UnittestProtoRoot repeatedFloatExtension] value:[NSNumber numberWithFloat:311.0]];
    [message addExtension:[UnittestProtoRoot repeatedDoubleExtension] value:[NSNumber numberWithDouble:312.0]];
    [message addExtension:[UnittestProtoRoot repeatedBoolExtension] value:[NSNumber numberWithBool:false]];
    [message addExtension:[UnittestProtoRoot repeatedStringExtension] value:@"315"];
    [message addExtension:[UnittestProtoRoot repeatedBytesExtension] value:[self toData:@"316"]];
    
    [message addExtension:[UnittestProtoRoot repeatedGroupExtension]
                    value:[[[RepeatedGroup_extension_Builder builder] setA:317] build]];
    [message addExtension:[UnittestProtoRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage_Builder builder] setBb:318] build]];
    [message addExtension:[UnittestProtoRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage_Builder builder] setC:319] build]];
    [message addExtension:[UnittestProtoRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage_Builder builder] setD:320] build]];
    
    [message addExtension:[UnittestProtoRoot repeatedNestedEnumExtension]
                    value:[TestAllTypes_NestedEnum BAZ]];
    [message addExtension:[UnittestProtoRoot repeatedForeignEnumExtension]
                    value:[ForeignEnum FOREIGN_BAZ]];
    [message addExtension:[UnittestProtoRoot repeatedImportEnumExtension]
                    value:[ImportEnum IMPORT_BAZ]];
    
    [message addExtension:[UnittestProtoRoot repeatedStringPieceExtension] value:@"324"];
    [message addExtension:[UnittestProtoRoot repeatedCordExtension] value:@"325"];
    
    // -----------------------------------------------------------------
    
    [message setExtension:[UnittestProtoRoot defaultInt32Extension] value:[NSNumber numberWithInt:401]];
    [message setExtension:[UnittestProtoRoot defaultInt64Extension] value:[NSNumber numberWithInt:402L]];
    [message setExtension:[UnittestProtoRoot defaultUint32Extension] value:[NSNumber numberWithInt:403]];
    [message setExtension:[UnittestProtoRoot defaultUint64Extension] value:[NSNumber numberWithInt:404L]];
    [message setExtension:[UnittestProtoRoot defaultSint32Extension] value:[NSNumber numberWithInt:405]];
    [message setExtension:[UnittestProtoRoot defaultSint64Extension] value:[NSNumber numberWithInt:406L]];
    [message setExtension:[UnittestProtoRoot defaultFixed32Extension] value:[NSNumber numberWithInt:407]];
    [message setExtension:[UnittestProtoRoot defaultFixed64Extension] value:[NSNumber numberWithInt:408L]];
    [message setExtension:[UnittestProtoRoot defaultSfixed32Extension] value:[NSNumber numberWithInt:409]];
    [message setExtension:[UnittestProtoRoot defaultSfixed64Extension] value:[NSNumber numberWithInt:410L]];
    [message setExtension:[UnittestProtoRoot defaultFloatExtension] value:[NSNumber numberWithFloat:411.0]];
    [message setExtension:[UnittestProtoRoot defaultDoubleExtension] value:[NSNumber numberWithDouble:412.0]];
    [message setExtension:[UnittestProtoRoot defaultBoolExtension] value:[NSNumber numberWithBool:false]];
    [message setExtension:[UnittestProtoRoot defaultStringExtension] value:@"415"];
    [message setExtension:[UnittestProtoRoot defaultBytesExtension] value:[self toData:@"416"]];
    
    [message setExtension:[UnittestProtoRoot defaultNestedEnumExtension]
                    value:[TestAllTypes_NestedEnum FOO]];
    [message setExtension:[UnittestProtoRoot defaultForeignEnumExtension]
                    value:[ForeignEnum FOREIGN_FOO]];
    [message setExtension:[UnittestProtoRoot defaultImportEnumExtension]
                    value:[ImportEnum IMPORT_FOO]];
    
    [message setExtension:[UnittestProtoRoot defaultStringPieceExtension] value:@"424"];
    [message setExtension:[UnittestProtoRoot defaultCordExtension] value:@"425"];
}


/**
 * Register all of {@code TestAllExtensions}' extensions with the
 * given {@link ExtensionRegistry}.
 */
+ (void) registerAllExtensions:(PBExtensionRegistry*) registry {
    [registry addExtension:[UnittestProtoRoot optionalInt32Extension]];
    [registry addExtension:[UnittestProtoRoot optionalInt64Extension]];
    [registry addExtension:[UnittestProtoRoot optionalUint32Extension]];
    [registry addExtension:[UnittestProtoRoot optionalUint64Extension]];
    [registry addExtension:[UnittestProtoRoot optionalSint32Extension]];
    [registry addExtension:[UnittestProtoRoot optionalSint64Extension]];
    [registry addExtension:[UnittestProtoRoot optionalFixed32Extension]];
    [registry addExtension:[UnittestProtoRoot optionalFixed64Extension]];
    [registry addExtension:[UnittestProtoRoot optionalSfixed32Extension]];
    [registry addExtension:[UnittestProtoRoot optionalSfixed64Extension]];
    [registry addExtension:[UnittestProtoRoot optionalFloatExtension]];
    [registry addExtension:[UnittestProtoRoot optionalDoubleExtension]];
    [registry addExtension:[UnittestProtoRoot optionalBoolExtension]];
    [registry addExtension:[UnittestProtoRoot optionalStringExtension]];
    [registry addExtension:[UnittestProtoRoot optionalBytesExtension]];
    [registry addExtension:[UnittestProtoRoot optionalGroupExtension]];
    [registry addExtension:[UnittestProtoRoot optionalNestedMessageExtension]];
    [registry addExtension:[UnittestProtoRoot optionalForeignMessageExtension]];
    [registry addExtension:[UnittestProtoRoot optionalImportMessageExtension]];
    [registry addExtension:[UnittestProtoRoot optionalNestedEnumExtension]];
    [registry addExtension:[UnittestProtoRoot optionalForeignEnumExtension]];
    [registry addExtension:[UnittestProtoRoot optionalImportEnumExtension]];
    [registry addExtension:[UnittestProtoRoot optionalStringPieceExtension]];
    [registry addExtension:[UnittestProtoRoot optionalCordExtension]];
    
    [registry addExtension:[UnittestProtoRoot repeatedInt32Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedInt64Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedUint32Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedUint64Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedSint32Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedSint64Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedFixed32Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedFixed64Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedSfixed32Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedSfixed64Extension]];
    [registry addExtension:[UnittestProtoRoot repeatedFloatExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedDoubleExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedBoolExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedStringExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedBytesExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedGroupExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedNestedMessageExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedForeignMessageExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedImportMessageExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedNestedEnumExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedForeignEnumExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedImportEnumExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedStringPieceExtension]];
    [registry addExtension:[UnittestProtoRoot repeatedCordExtension]];
    
    [registry addExtension:[UnittestProtoRoot defaultInt32Extension]];
    [registry addExtension:[UnittestProtoRoot defaultInt64Extension]];
    [registry addExtension:[UnittestProtoRoot defaultUint32Extension]];
    [registry addExtension:[UnittestProtoRoot defaultUint64Extension]];
    [registry addExtension:[UnittestProtoRoot defaultSint32Extension]];
    [registry addExtension:[UnittestProtoRoot defaultSint64Extension]];
    [registry addExtension:[UnittestProtoRoot defaultFixed32Extension]];
    [registry addExtension:[UnittestProtoRoot defaultFixed64Extension]];
    [registry addExtension:[UnittestProtoRoot defaultSfixed32Extension]];
    [registry addExtension:[UnittestProtoRoot defaultSfixed64Extension]];
    [registry addExtension:[UnittestProtoRoot defaultFloatExtension]];
    [registry addExtension:[UnittestProtoRoot defaultDoubleExtension]];
    [registry addExtension:[UnittestProtoRoot defaultBoolExtension]];
    [registry addExtension:[UnittestProtoRoot defaultStringExtension]];
    [registry addExtension:[UnittestProtoRoot defaultBytesExtension]];
    [registry addExtension:[UnittestProtoRoot defaultNestedEnumExtension]];
    [registry addExtension:[UnittestProtoRoot defaultForeignEnumExtension]];
    [registry addExtension:[UnittestProtoRoot defaultImportEnumExtension]];
    [registry addExtension:[UnittestProtoRoot defaultStringPieceExtension]];
    [registry addExtension:[UnittestProtoRoot defaultCordExtension]];
}


/**
 * Get an unmodifiable {@link ExtensionRegistry} containing all the
 * extensions of {@code TestAllExtensions}.
 */
+ (PBExtensionRegistry*) extensionRegistry {
    PBExtensionRegistry* registry = [PBExtensionRegistry registry];
    [self registerAllExtensions:registry];
    return registry;
}


+ (TestAllTypes*) allSet {
    TestAllTypes_Builder* builder = [TestAllTypes_Builder builder];
    [self setAllFields:builder];
    return [builder build];
}


+ (TestAllExtensions*) allExtensionsSet {
    TestAllExtensions_Builder* builder = [TestAllExtensions_Builder builder];
    [self setAllExtensions:builder];
    return [builder build];
}


// -------------------------------------------------------------------

/**
 * Assert (using {@code junit.framework.Assert}} that all fields of
 * {@code message} are cleared, and that getting the fields returns their
 * default values.
 */
- (void) assertClear:(TestAllTypes*) message {
    // hasBlah() should initially be false for all optional fields.
    STAssertFalse(message.hasOptionalInt32, @"");
    STAssertFalse(message.hasOptionalInt64, @"");
    STAssertFalse(message.hasOptionalUint32, @"");
    STAssertFalse(message.hasOptionalUint64, @"");
    STAssertFalse(message.hasOptionalSint32, @"");
    STAssertFalse(message.hasOptionalSint64, @"");
    STAssertFalse(message.hasOptionalFixed32, @"");
    STAssertFalse(message.hasOptionalFixed64, @"");
    STAssertFalse(message.hasOptionalSfixed32, @"");
    STAssertFalse(message.hasOptionalSfixed64, @"");
    STAssertFalse(message.hasOptionalFloat, @"");
    STAssertFalse(message.hasOptionalDouble, @"");
    STAssertFalse(message.hasOptionalBool, @"");
    STAssertFalse(message.hasOptionalString, @"");
    STAssertFalse(message.hasOptionalBytes, @"");
    
    STAssertFalse(message.hasOptionalGroup, @"");
    STAssertFalse(message.hasOptionalNestedMessage, @"");
    STAssertFalse(message.hasOptionalForeignMessage, @"");
    STAssertFalse(message.hasOptionalImportMessage, @"");
    
    STAssertFalse(message.hasOptionalNestedEnum, @"");
    STAssertFalse(message.hasOptionalForeignEnum, @"");
    STAssertFalse(message.hasOptionalImportEnum, @"");
    
    STAssertFalse(message.hasOptionalStringPiece, @"");
    STAssertFalse(message.hasOptionalCord, @"");
    
    // Optional fields without defaults are set to zero or something like it.
    STAssertTrue(0 == message.optionalInt32, @"");
    STAssertTrue(0 == message.optionalInt64, @"");
    STAssertTrue(0 == message.optionalUint32, @"");
    STAssertTrue(0 == message.optionalUint64, @"");
    STAssertTrue(0 == message.optionalSint32, @"");
    STAssertTrue(0 == message.optionalSint64, @"");
    STAssertTrue(0 == message.optionalFixed32, @"");
    STAssertTrue(0 == message.optionalFixed64, @"");
    STAssertTrue(0 == message.optionalSfixed32, @"");
    STAssertTrue(0 == message.optionalSfixed64, @"");
    STAssertTrue(0 == message.optionalFloat, @"");
    STAssertTrue(0 == message.optionalDouble, @"");
    STAssertTrue(false == message.optionalBool, @"");
    STAssertEqualObjects(@"", message.optionalString, @"");
    STAssertEqualObjects([NSData data], message.optionalBytes, @"");
    
    // Embedded messages should also be clear.
    STAssertFalse(message.optionalGroup.hasA, @"");
    STAssertFalse(message.optionalNestedMessage.hasBb, @"");
    STAssertFalse(message.optionalForeignMessage.hasC, @"");
    STAssertFalse(message.optionalImportMessage.hasD, @"");
    
    STAssertTrue(0 == message.optionalGroup.a, @"");
    STAssertTrue(0 == message.optionalNestedMessage.bb, @"");
    STAssertTrue(0 == message.optionalForeignMessage.c, @"");
    STAssertTrue(0 == message.optionalImportMessage.d, @"");
    
    // Enums without defaults are set to the first value in the enum.
    STAssertTrue([TestAllTypes_NestedEnum FOO] == message.optionalNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == message.optionalForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_FOO] == message.optionalImportEnum, @"");
    
    STAssertEqualObjects(@"", message.optionalStringPiece, @"");
    STAssertEqualObjects(@"", message.optionalCord, @"");
    
    // Repeated fields are empty.
    STAssertTrue(0 == message.repeatedInt32List.count, @"");
    STAssertTrue(0 == message.repeatedInt64List.count, @"");
    STAssertTrue(0 == message.repeatedUint32List.count, @"");
    STAssertTrue(0 == message.repeatedUint64List.count, @"");
    STAssertTrue(0 == message.repeatedSint32List.count, @"");
    STAssertTrue(0 == message.repeatedSint64List.count, @"");
    STAssertTrue(0 == message.repeatedFixed32List.count, @"");
    STAssertTrue(0 == message.repeatedFixed64List.count, @"");
    STAssertTrue(0 == message.repeatedSfixed32List.count, @"");
    STAssertTrue(0 == message.repeatedSfixed64List.count, @"");
    STAssertTrue(0 == message.repeatedFloatList.count, @"");
    STAssertTrue(0 == message.repeatedDoubleList.count, @"");
    STAssertTrue(0 == message.repeatedBoolList.count, @"");
    STAssertTrue(0 == message.repeatedStringList.count, @"");
    STAssertTrue(0 == message.repeatedBytesList.count, @"");
    
    STAssertTrue(0 == message.repeatedGroupList.count, @"");
    STAssertTrue(0 == message.repeatedNestedMessageList.count, @"");
    STAssertTrue(0 == message.repeatedForeignMessageList.count, @"");
    STAssertTrue(0 == message.repeatedImportMessageList.count, @"");
    STAssertTrue(0 == message.repeatedNestedEnumList.count, @"");
    STAssertTrue(0 == message.repeatedForeignEnumList.count, @"");
    STAssertTrue(0 == message.repeatedImportEnumList.count, @"");
    
    STAssertTrue(0 == message.repeatedStringPieceList.count, @"");
    STAssertTrue(0 == message.repeatedCordList.count, @"");
    
    // hasBlah() should also be false for all default fields.
    STAssertFalse(message.hasDefaultInt32, @"");
    STAssertFalse(message.hasDefaultInt64, @"");
    STAssertFalse(message.hasDefaultUint32, @"");
    STAssertFalse(message.hasDefaultUint64, @"");
    STAssertFalse(message.hasDefaultSint32, @"");
    STAssertFalse(message.hasDefaultSint64, @"");
    STAssertFalse(message.hasDefaultFixed32, @"");
    STAssertFalse(message.hasDefaultFixed64, @"");
    STAssertFalse(message.hasDefaultSfixed32, @"");
    STAssertFalse(message.hasDefaultSfixed64, @"");
    STAssertFalse(message.hasDefaultFloat, @"");
    STAssertFalse(message.hasDefaultDouble, @"");
    STAssertFalse(message.hasDefaultBool, @"");
    STAssertFalse(message.hasDefaultString, @"");
    STAssertFalse(message.hasDefaultBytes, @"");
    
    STAssertFalse(message.hasDefaultNestedEnum, @"");
    STAssertFalse(message.hasDefaultForeignEnum, @"");
    STAssertFalse(message.hasDefaultImportEnum, @"");
    
    STAssertFalse(message.hasDefaultStringPiece, @"");
    STAssertFalse(message.hasDefaultCord, @"");
    
    // Fields with defaults have their default values (duh).
    STAssertTrue( 41 == message.defaultInt32, @"");
    STAssertTrue( 42 == message.defaultInt64, @"");
    STAssertTrue( 43 == message.defaultUint32, @"");
    STAssertTrue( 44 == message.defaultUint64, @"");
    STAssertTrue(-45 == message.defaultSint32, @"");
    STAssertTrue( 46 == message.defaultSint64, @"");
    STAssertTrue( 47 == message.defaultFixed32, @"");
    STAssertTrue( 48 == message.defaultFixed64, @"");
    STAssertTrue( 49 == message.defaultSfixed32, @"");
    STAssertTrue(-50 == message.defaultSfixed64, @"");
    STAssertEqualsWithAccuracy(51.5, message.defaultFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(52e3, message.defaultDouble, 0.1, @"");
    STAssertTrue(true == message.defaultBool, @"");
    STAssertEqualObjects(@"hello", message.defaultString, @"");
    STAssertEqualObjects([TestUtilities toData:@"world"], message.defaultBytes, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] == message.defaultNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] == message.defaultForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_BAR] == message.defaultImportEnum, @"");
    
    STAssertEqualObjects(@"abc", message.defaultStringPiece, @"");
    STAssertEqualObjects(@"123", message.defaultCord, @"");
}


+ (void) assertClear:(TestAllTypes*) message {
    return [[[[TestUtilities alloc] init] autorelease] assertClear:message];
}

#if 0


/**
 * Set every field of {@code message} to the values expected by
 * {@code assertAllFieldsSet()}.
 */


// -------------------------------------------------------------------

/**
 * Modify the repeated fields of {@code message} to contain the values
 * expected by {@code assertRepeatedFieldsModified()}.
 */
public static void modifyRepeatedFields(TestAllTypes.Builder message) {
    [message setRepeatedInt32   (1, 501);
     [message setRepeatedInt64   (1, 502);
      [message setRepeatedUint32  (1, 503);
       [message setRepeatedUint64  (1, 504);
        [message setRepeatedSint32  (1, 505);
         [message setRepeatedSint64  (1, 506);
          [message setRepeatedFixed32 (1, 507);
           [message setRepeatedFixed64 (1, 508);
            [message setRepeatedSfixed32(1, 509);
             [message setRepeatedSfixed64(1, 510);
              [message setRepeatedFloat   (1, 511);
               [message setRepeatedDouble  (1, 512);
                [message setRepeatedBool    (1, true);
                 [message setRepeatedString  (1, "515");
                  [message setRepeatedBytes   (1, toData("516"));
                   
                   [message setRepeatedGroup(1,
                       [TestAllTypes_RepeatedGroup newBuilder].setA(517) build]);
                    [message setRepeatedNestedMessage(1,
          [TestAllTypes_NestedMessage newBuilder].setBb(518) build]);
                     [message setRepeatedForeignMessage(1,
            [ForeignMessage newBuilder].setC(519) build]);
                      [message setRepeatedImportMessage(1,
            [ImportMessage newBuilder] setD:520] build]);
                       
                       [message setRepeatedNestedEnum (1, [TestAllTypes_NestedEnum FOO]);
                        [message setRepeatedForeignEnum(1, [ForeignEnum FOREIGN_FOO]);
                         [message setRepeatedImportEnum (1, [ImportEnum IMPORT_FOO]);
    
    [message setRepeatedStringPiece(1, "524");
     [message setRepeatedCord(1, "525");
     }
     
     
     
     
     // -------------------------------------------------------------------
     
    /**
     * Assert (using {@code junit.framework.Assert}} that all fields of
     * {@code message} are set to the values assigned by {@code setAllFields}
     * followed by {@code modifyRepeatedFields}.
     */
     public static void assertRepeatedFieldsModified(TestAllTypes message) {
        // ModifyRepeatedFields only sets the second repeated element of each
        // field.  In addition to verifying this, we also verify that the first
        // element and size were *not* modified.
        STAssertTrue(2 == message.repeatedInt32List.count, @"");
        STAssertTrue(2 == message.repeatedInt64List.count, @"");
        STAssertTrue(2 == message.repeatedUint32List.count, @"");
        STAssertTrue(2 == message.repeatedUint64List.count, @"");
        STAssertTrue(2 == message.repeatedSint32List.count, @"");
        STAssertTrue(2 == message.repeatedSint64List.count, @"");
        STAssertTrue(2 == message.repeatedFixed32List.count, @"");
        STAssertTrue(2 == message.repeatedFixed64List.count, @"");
        STAssertTrue(2 == message.repeatedSfixed32List.count, @"");
        STAssertTrue(2 == message.repeatedSfixed64List.count, @"");
        STAssertTrue(2 == message.repeatedFloatList.count, @"");
        STAssertTrue(2 == message.repeatedDoubleList.count, @"");
        STAssertTrue(2 == message.repeatedBoolList.count, @"");
        STAssertTrue(2 == message.repeatedStringList.count, @"");
        STAssertTrue(2 == message.repeatedBytesList.count, @"");
        
        STAssertTrue(2 == message.repeatedGroupList.count, @"");
        STAssertTrue(2 == message.repeatedNestedMessageList.count, @"");
        STAssertTrue(2 == message.repeatedForeignMessageList.count, @"");
        STAssertTrue(2 == message.repeatedImportMessageList.count, @"");
        STAssertTrue(2 == message.repeatedNestedEnumList.count, @"");
        STAssertTrue(2 == message.repeatedForeignEnumList.count, @"");
        STAssertTrue(2 == message.repeatedImportEnumList.count, @"");
        
        STAssertTrue(2 == message.repeatedStringPieceList.count, @"");
        STAssertTrue(2 == message.repeatedCordList.count, @"");
        
        STAssertTrue(201 == [message repeatedInt32AtIndex:0], @"");
        STAssertTrue(202L == [message repeatedInt64AtIndex:0], @"");
        STAssertTrue(203 == [message repeatedUint32AtIndex:0], @"");
        STAssertTrue(204L == [message repeatedUint64AtIndex:0], @"");
        STAssertTrue(205 == [message repeatedSint32AtIndex:0], @"");
        STAssertTrue(206L == [message repeatedSint64AtIndex:0], @"");
        STAssertTrue(207 == [message repeatedFixed32AtIndex:0], @"");
        STAssertTrue(208L == [message repeatedFixed64AtIndex:0], @"");
        STAssertTrue(209 == [message repeatedSfixed32AtIndex:0], @"");
        STAssertTrue(210L == [message repeatedSfixed64AtIndex:0], @"");
        STAssertTrue(211F == [message repeatedFloatAtIndex:0], @"");
        STAssertTrue(212D == [message repeatedDoubleAtIndex:0], @"");
        STAssertTrue(true == [message repeatedBoolAtIndex:0], @"");
        STAssertTrue("215" == [message repeatedStringAtIndex:0], @"");
        STAssertTrue(toData("216"), message.getRepeatedBytes(0));
        
        STAssertTrue(217 == [message repeatedGroupAtIndex:0]a, @"");
        STAssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
        STAssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
        STAssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
        
        STAssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
        STAssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
        STAssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
        
        STAssertTrue("224" == [message repeatedStringPieceAtIndex:0], @"");
        STAssertTrue("225" == [message repeatedCordAtIndex:0], @"");
        
        // Actually verify the second (modified) elements now.
        STAssertTrue(501 == [message repeatedInt32AtIndex:1], @"");
        STAssertTrue(502L == [message repeatedInt64AtIndex:1], @"");
        STAssertTrue(503 == [message repeatedUint32AtIndex:1], @"");
        STAssertTrue(504L == [message repeatedUint64AtIndex:1], @"");
        STAssertTrue(505 == [message repeatedSint32AtIndex:1], @"");
        STAssertTrue(506L == [message repeatedSint64AtIndex:1], @"");
        STAssertTrue(507 == [message repeatedFixed32AtIndex:1], @"");
        STAssertTrue(508L == [message repeatedFixed64AtIndex:1], @"");
        STAssertTrue(509 == [message repeatedSfixed32AtIndex:1], @"");
        STAssertTrue(510L == [message repeatedSfixed64AtIndex:1], @"");
        STAssertTrue(511F == [message repeatedFloatAtIndex:1], @"");
        STAssertTrue(512D == [message repeatedDoubleAtIndex:1], @"");
        STAssertTrue(true == [message repeatedBoolAtIndex:1], @"");
        STAssertTrue("515" == [message repeatedStringAtIndex:1], @"");
        STAssertTrue(toData("516"), message.getRepeatedBytes(1));
        
        STAssertTrue(517 == [message repeatedGroupAtIndex:1]a, @"");
        STAssertTrue(518 == [message repeatedNestedMessageAtIndex:1].bb, @"");
        STAssertTrue(519 == [message repeatedForeignMessageAtIndex:1].c, @"");
        STAssertTrue(520 == [message repeatedImportMessageAtIndex:1].d, @"");
        
        STAssertTrue([TestAllTypes_NestedEnum FOO] == [message repeatedNestedEnumAtIndex:1], @"");
        STAssertTrue([ForeignEnum FOREIGN_FOO] == [message repeatedForeignEnumAtIndex:1], @"");
        STAssertTrue([ImportEnum IMPORT_FOO] == [message repeatedImportEnumAtIndex:1], @"");
        
        STAssertTrue("524" == [message repeatedStringPieceAtIndex:1], @"");
        STAssertTrue("525" == [message repeatedCordAtIndex:1], @"");
    }
     
     // ===================================================================
     // Like above, but for extensions
     
     // Java gets confused with things like assertEquals(int, Integer):  it can't
     // decide whether to call assertEquals(int, int) or assertEquals(Object,
     // Object).  So we define these methods to help it.
     private static void STAssertTrue(int a, int b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(long a, long b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(float a, float b) {
        STAssertTrue(a, b, 0.0);
    }
     private static void STAssertTrue(double a, double b) {
        STAssertTrue(a, b, 0.0);
    }
     private static void STAssertTrue(boolean a, boolean b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(String a, String b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(ByteString a, ByteString b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(TestAllTypes_NestedEnum a,
                         TestAllTypes_NestedEnum b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(ForeignEnum a, ForeignEnum b) {
        STAssertTrue(a, b);
    }
     private static void STAssertTrue(ImportEnum a, ImportEnum b) {
        STAssertTrue(a, b);
    }
     
     
     
     
     
     
     // -------------------------------------------------------------------
     
    /**
     * Modify the repeated extensions of {@code message} to contain the values
     * expected by {@code assertRepeatedExtensionsModified()}.
     */
     public static void modifyRepeatedExtensions(
     TestAllExtensions.Builder message) {
        [message setExtension:[UnittestProtoRoot repeatedInt32Extension], 1, 501);
         [message setExtension:[UnittestProtoRoot repeatedInt64Extension], 1, 502L);
          [message setExtension:[UnittestProtoRoot repeatedUint32Extension], 1, 503);
           [message setExtension:[UnittestProtoRoot repeatedUint64Extension], 1, 504L);
            [message setExtension:[UnittestProtoRoot repeatedSint32Extension], 1, 505);
             [message setExtension:[UnittestProtoRoot repeatedSint64Extension], 1, 506L);
              [message setExtension:[UnittestProtoRoot repeatedFixed32Extension], 1, 507);
               [message setExtension:[UnittestProtoRoot repeatedFixed64Extension], 1, 508L);
                [message setExtension:[UnittestProtoRoot repeatedSfixed32Extension], 1, 509);
                 [message setExtension:[UnittestProtoRoot repeatedSfixed64Extension], 1, 510L);
                  [message setExtension:[UnittestProtoRoot repeatedFloatExtension], 1, 511F);
                   [message setExtension:[UnittestProtoRoot repeatedDoubleExtension], 1, 512D);
                    [message setExtension:[UnittestProtoRoot repeatedBoolExtension], 1, true);
                     [message setExtension:[UnittestProtoRoot repeatedStringExtension], 1, "515");
                      [message setExtension:[UnittestProtoRoot repeatedBytesExtension], 1, toData("516"));
                       
                       [message setExtension:[UnittestProtoRoot repeatedGroupExtension], 1,
                        UnittestProto.RepeatedGroup_extension.newBuilder().setA(517) build]);
                       [message setExtension:[UnittestProtoRoot repeatedNestedMessageExtension], 1,
                        [TestAllTypes_NestedMessage newBuilder].setBb(518) build]);
                       [message setExtension:[UnittestProtoRoot repeatedForeignMessageExtension], 1,
                        [ForeignMessage newBuilder].setC(519) build]);
                       [message setExtension:[UnittestProtoRoot repeatedImportMessageExtension], 1,
                        [ImportMessage newBuilder] setD:520] build]);
                      
                      [message setExtension:[UnittestProtoRoot repeatedNestedEnumExtension], 1,
                       [TestAllTypes_NestedEnum FOO]);
                       [message setExtension:[UnittestProtoRoot repeatedForeignEnumExtension], 1,
                        [ForeignEnum FOREIGN_FOO]);
                        [message setExtension:[UnittestProtoRoot repeatedImportEnumExtension], 1,
                         [ImportEnum IMPORT_FOO]);
                         
                         [message setExtension:[UnittestProtoRoot repeatedStringPieceExtension], 1, "524");
    [message setExtension:[UnittestProtoRoot repeatedCordExtension], 1, "525");
    }
    
    // -------------------------------------------------------------------

    
    // -------------------------------------------------------------------
    
        /**
         * Assert (using {@code junit.framework.Assert}} that all extensions of
         * {@code message} are cleared, and that getting the extensions returns their
         * default values.
         */
    public static void assertExtensionsClear(TestAllExtensions message) {
            // hasBlah() should initially be false for all optional fields.
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalInt64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalUint32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalUint64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalSint32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalSint64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalFixed32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalFixed64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalSfixed32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalSfixed64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalFloatExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalDoubleExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalBoolExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalStringExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
            
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalGroupExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalNestedMessageExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalForeignMessageExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalImportMessageExtension]], @"");
            
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
            
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot optionalCordExtension]], @"");
            
            // Optional fields without defaults are set to zero or something like it.
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalInt32Extension]   ));
                STAssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalInt64Extension]   ));
                     STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalUint32Extension]  ));
                         STAssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalUint64Extension]  ));
                         STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalSint32Extension]  ));
       STAssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalSint64Extension]  ));
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalFixed32Extension] ));
           STAssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalFixed64Extension] ));
                STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalSfixed32Extension]));
                    STAssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalSfixed64Extension]));
                         STAssertTrue(0F, [message getExtension:[UnittestProtoRoot optionalFloatExtension]   ));
                         STAssertTrue(0D, [message getExtension:[UnittestProtoRoot optionalDoubleExtension]  ));
        STAssertTrue(false, [message getExtension:[UnittestProtoRoot optionalBoolExtension]    ));
                STAssertTrue("", [message getExtension:[UnittestProtoRoot optionalStringExtension]  ));
                STAssertTrue(ByteString.EMPTY, [message getExtension:[UnittestProtoRoot optionalBytesExtension]));
            
            // Embedded messages should also be clear.
             STAssertFalse([message getExtension:[UnittestProtoRoot optionalGroupExtension]         ).hasA());
      STAssertFalse([message getExtension:[UnittestProtoRoot optionalNestedMessageExtension] ).hasBb());
                     STAssertFalse([message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]).hasC());
         STAssertFalse([message getExtension:[UnittestProtoRoot optionalImportMessageExtension] ).hasD());
            
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalGroupExtension]         .a);
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalNestedMessageExtension] ).bb);
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]).c);
            STAssertTrue(0, [message getExtension:[UnittestProtoRoot optionalImportMessageExtension] ).d);
            
            // Enums without defaults are set to the first value in the enum.
            STAssertTrue([TestAllTypes_NestedEnum FOO],
            [message getExtension:[UnittestProtoRoot optionalNestedEnumExtension] ));
            STAssertTrue([ForeignEnum FOREIGN_FOO],
            [message getExtension:[UnittestProtoRoot optionalForeignEnumExtension]));
            STAssertTrue([ImportEnum IMPORT_FOO],
            [message getExtension:[UnittestProtoRoot optionalImportEnumExtension]));
            
            STAssertTrue("", [message getExtension:[UnittestProtoRoot optionalStringPieceExtension]));
            STAssertTrue("", [message getExtension:[UnittestProtoRoot optionalCordExtension]));
            
            // Repeated fields are empty.
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]   ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]   ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension] ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension] ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]   ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]    ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]  ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]   ));
            
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]         ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension] ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension] ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]    ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]   ));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]    ));
            
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]));
            STAssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]));
            
            // hasBlah() should also be false for all default fields.
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultInt32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultInt64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultUint32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultUint64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultSint32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultSint64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultFixed32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultFixed64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultSfixed32Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultSfixed64Extension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultFloatExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultDoubleExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultBoolExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultStringExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
            
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
            
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
            STAssertFalse([message hasExtension:[UnittestProtoRoot defaultCordExtension]], @"");
            
            // Fields with defaults have their default values (duh).
            STAssertTrue( 41, [message getExtension:[UnittestProtoRoot defaultInt32Extension]   ));
            STAssertTrue( 42L, [message getExtension:[UnittestProtoRoot defaultInt64Extension]   ));
            STAssertTrue( 43, [message getExtension:[UnittestProtoRoot defaultUint32Extension]  ));
            STAssertTrue( 44L, [message getExtension:[UnittestProtoRoot defaultUint64Extension]  ));
            STAssertTrue(-45, [message getExtension:[UnittestProtoRoot defaultSint32Extension]  ));
            STAssertTrue( 46L, [message getExtension:[UnittestProtoRoot defaultSint64Extension]  ));
            STAssertTrue( 47, [message getExtension:[UnittestProtoRoot defaultFixed32Extension] ));
            STAssertTrue( 48L, [message getExtension:[UnittestProtoRoot defaultFixed64Extension] ));
            STAssertTrue( 49, [message getExtension:[UnittestProtoRoot defaultSfixed32Extension]));
            STAssertTrue(-50L, [message getExtension:[UnittestProtoRoot defaultSfixed64Extension]));
            STAssertTrue( 51.5F, [message getExtension:[UnittestProtoRoot defaultFloatExtension]   ));
            STAssertTrue( 52e3D, [message getExtension:[UnittestProtoRoot defaultDoubleExtension]  ));
            STAssertTrue(true, [message getExtension:[UnittestProtoRoot defaultBoolExtension]    ));
            STAssertTrue("hello", [message getExtension:[UnittestProtoRoot defaultStringExtension]  ));
            STAssertTrue(toData("world"), [message getExtension:[UnittestProtoRoot defaultBytesExtension]));
            
            STAssertTrue([TestAllTypes_NestedEnum BAR],
            [message getExtension:[UnittestProtoRoot defaultNestedEnumExtension] ));
            STAssertTrue([ForeignEnum FOREIGN_BAR],
            [message getExtension:[UnittestProtoRoot defaultForeignEnumExtension]));
            STAssertTrue([ImportEnum IMPORT_BAR],
            [message getExtension:[UnittestProtoRoot defaultImportEnumExtension]));
            
            STAssertTrue("abc", [message getExtension:[UnittestProtoRoot defaultStringPieceExtension]));
            STAssertTrue("123", [message getExtension:[UnittestProtoRoot defaultCordExtension]));
        }
    
    // -------------------------------------------------------------------
    
        /**
         * Assert (using {@code junit.framework.Assert}} that all extensions of
         * {@code message} are set to the values assigned by {@code setAllExtensions}
         * followed by {@code modifyRepeatedExtensions}.
         */
    public static void assertRepeatedExtensionsModified(
            TestAllExtensions message) {
            // ModifyRepeatedFields only sets the second repeated element of each
            // field.  In addition to verifying this, we also verify that the first
            // element and size were *not* modified.
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]   ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]   ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension] ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension] ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]   ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]    ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]  ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]   ));
            
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]         ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension] ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension] ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]    ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]   ));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]    ));
            
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]));
            STAssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]));
            
            STAssertTrue(201, [message getExtension:[UnittestProtoRoot repeatedInt32Extension], 0));
            STAssertTrue(202L, [message getExtension:[UnittestProtoRoot repeatedInt64Extension], 0));
            STAssertTrue(203, [message getExtension:[UnittestProtoRoot repeatedUint32Extension], 0));
            STAssertTrue(204L, [message getExtension:[UnittestProtoRoot repeatedUint64Extension], 0));
            STAssertTrue(205, [message getExtension:[UnittestProtoRoot repeatedSint32Extension], 0));
            STAssertTrue(206L, [message getExtension:[UnittestProtoRoot repeatedSint64Extension], 0));
            STAssertTrue(207, [message getExtension:[UnittestProtoRoot repeatedFixed32Extension], 0));
            STAssertTrue(208L, [message getExtension:[UnittestProtoRoot repeatedFixed64Extension], 0));
            STAssertTrue(209, [message getExtension:[UnittestProtoRoot repeatedSfixed32Extension], 0));
            STAssertTrue(210L, [message getExtension:[UnittestProtoRoot repeatedSfixed64Extension], 0));
            STAssertTrue(211F, [message getExtension:[UnittestProtoRoot repeatedFloatExtension], 0));
            STAssertTrue(212D, [message getExtension:[UnittestProtoRoot repeatedDoubleExtension], 0));
            STAssertTrue(true, [message getExtension:[UnittestProtoRoot repeatedBoolExtension], 0));
            STAssertTrue("215", [message getExtension:[UnittestProtoRoot repeatedStringExtension], 0));
            STAssertTrue(toData("216"), [message getExtension:[UnittestProtoRoot repeatedBytesExtension], 0));
            
            STAssertTrue(217, [message getExtension:[UnittestProtoRoot repeatedGroupExtension], 0.a);
            STAssertTrue(218, [message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension], 0).bb);
            STAssertTrue(219, [message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension], 0).c);
            STAssertTrue(220, [message getExtension:[UnittestProtoRoot repeatedImportMessageExtension], 0).d);
            
            STAssertTrue([TestAllTypes_NestedEnum BAR],
            [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension], 0));
            STAssertTrue([ForeignEnum FOREIGN_BAR],
            [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension], 0));
            STAssertTrue([ImportEnum IMPORT_BAR],
            [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension], 0));
            
            STAssertTrue("224", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension], 0));
            STAssertTrue("225", [message getExtension:[UnittestProtoRoot repeatedCordExtension], 0));
            
            // Actually verify the second (modified) elements now.
            STAssertTrue(501, [message getExtension:[UnittestProtoRoot repeatedInt32Extension], 1));
            STAssertTrue(502L, [message getExtension:[UnittestProtoRoot repeatedInt64Extension], 1));
            STAssertTrue(503, [message getExtension:[UnittestProtoRoot repeatedUint32Extension], 1));
            STAssertTrue(504L, [message getExtension:[UnittestProtoRoot repeatedUint64Extension], 1));
            STAssertTrue(505, [message getExtension:[UnittestProtoRoot repeatedSint32Extension], 1));
            STAssertTrue(506L, [message getExtension:[UnittestProtoRoot repeatedSint64Extension], 1));
            STAssertTrue(507, [message getExtension:[UnittestProtoRoot repeatedFixed32Extension], 1));
            STAssertTrue(508L, [message getExtension:[UnittestProtoRoot repeatedFixed64Extension], 1));
            STAssertTrue(509, [message getExtension:[UnittestProtoRoot repeatedSfixed32Extension], 1));
            STAssertTrue(510L, [message getExtension:[UnittestProtoRoot repeatedSfixed64Extension], 1));
            STAssertTrue(511F, [message getExtension:[UnittestProtoRoot repeatedFloatExtension], 1));
            STAssertTrue(512D, [message getExtension:[UnittestProtoRoot repeatedDoubleExtension], 1));
            STAssertTrue(true, [message getExtension:[UnittestProtoRoot repeatedBoolExtension], 1));
            STAssertTrue("515", [message getExtension:[UnittestProtoRoot repeatedStringExtension], 1));
            STAssertTrue(toData("516"), [message getExtension:[UnittestProtoRoot repeatedBytesExtension], 1));
            
            STAssertTrue(517, [message getExtension:[UnittestProtoRoot repeatedGroupExtension], 1].a);
            STAssertTrue(518, [message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension], 1).bb);
            STAssertTrue(519, [message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension], 1).c);
            STAssertTrue(520, [message getExtension:[UnittestProtoRoot repeatedImportMessageExtension], 1).d);
            
            STAssertTrue([TestAllTypes_NestedEnum FOO],
            [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension], 1));
            STAssertTrue([ForeignEnum FOREIGN_FOO],
            [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension], 1));
            STAssertTrue([ImportEnum IMPORT_FOO],
            [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension], 1));
            
            STAssertTrue("524", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension], 1));
            STAssertTrue("525", [message getExtension:[UnittestProtoRoot repeatedCordExtension], 1));
        }
    
    // ===================================================================
    
        /**
         * Performs the same things that the methods of {@code TestUtil} do, but
         * via the reflection interface.  This is its own class because it needs
         * to know what descriptor to use.
         */
    public static class ReflectionTester {
            private final Descriptors.Descriptor baseDescriptor;
            private final ExtensionRegistry extensionRegistry;
            
            private final Descriptors.FileDescriptor file;
            private final Descriptors.FileDescriptor importFile;
            
            private final Descriptors.Descriptor optionalGroup;
            private final Descriptors.Descriptor repeatedGroup;
            private final Descriptors.Descriptor nestedMessage;
            private final Descriptors.Descriptor foreignMessage;
            private final Descriptors.Descriptor importMessage;
            
            private final Descriptors.FieldDescriptor groupA;
            private final Descriptors.FieldDescriptor repeatedGroupA;
            private final Descriptors.FieldDescriptor nestedB;
            private final Descriptors.FieldDescriptor foreignC;
            private final Descriptors.FieldDescriptor importD;
            
            private final Descriptors.EnumDescriptor nestedEnum;
            private final Descriptors.EnumDescriptor foreignEnum;
            private final Descriptors.EnumDescriptor importEnum;
            
            private final Descriptors.EnumValueDescriptor nestedFoo;
            private final Descriptors.EnumValueDescriptor nestedBar;
            private final Descriptors.EnumValueDescriptor nestedBaz;
            private final Descriptors.EnumValueDescriptor foreignFoo;
            private final Descriptors.EnumValueDescriptor foreignBar;
            private final Descriptors.EnumValueDescriptor foreignBaz;
            private final Descriptors.EnumValueDescriptor importFoo;
            private final Descriptors.EnumValueDescriptor importBar;
            private final Descriptors.EnumValueDescriptor importBaz;
            
            /**
             * Construct a {@code ReflectionTester} that will expect messages using
             * the given descriptor.
             *
             * Normally {@code baseDescriptor} should be a descriptor for the type
             * {@code TestAllTypes}, defined in
             * {@code google/protobuf/unittest.proto}.  However, if
             * {@code extensionRegistry} is non-null, then {@code baseDescriptor} should
             * be for {@code TestAllExtensions} instead, and instead of reading and
             * writing normal fields, the tester will read and write extensions.
             * All of {@code TestAllExtensions}' extensions must be registered in the
             * registry.
             */
            public ReflectionTester(Descriptors.Descriptor baseDescriptor,
              ExtensionRegistry extensionRegistry) {
                this.baseDescriptor = baseDescriptor;
                this.extensionRegistry = extensionRegistry;
                
                this.file = baseDescriptor.getFile();
                STAssertTrue(1, file.getDependencies().size());
                this.importFile = file.getDependencies().get(0);
                
                Descriptors.Descriptor testAllTypes;
                if (extensionRegistry == null) {
                    testAllTypes = baseDescriptor;
                } else {
                    testAllTypes = file.findMessageTypeByName("TestAllTypes");
                    Assert.assertNotNull(testAllTypes);
                }
                
                if (extensionRegistry == null) {
                    this.optionalGroup =
                    baseDescriptor.findNestedTypeByName("OptionalGroup");
                    this.repeatedGroup =
                    baseDescriptor.findNestedTypeByName("RepeatedGroup");
                } else {
                    this.optionalGroup =
                    file.findMessageTypeByName("OptionalGroup_extension");
                    this.repeatedGroup =
                    file.findMessageTypeByName("RepeatedGroup_extension");
                }
                this.nestedMessage = testAllTypes.findNestedTypeByName("NestedMessage");
                this.foreignMessage = file.findMessageTypeByName("ForeignMessage");
                this.importMessage = importFile.findMessageTypeByName("ImportMessage");
                
                this.nestedEnum = testAllTypes.findEnumTypeByName("NestedEnum");
                this.foreignEnum = file.findEnumTypeByName("ForeignEnum");
                this.importEnum = importFile.findEnumTypeByName("ImportEnum");
                
                Assert.assertNotNull(optionalGroup );
                Assert.assertNotNull(repeatedGroup );
                Assert.assertNotNull(nestedMessage );
                Assert.assertNotNull(foreignMessage);
                Assert.assertNotNull(importMessage );
                Assert.assertNotNull(nestedEnum    );
                Assert.assertNotNull(foreignEnum   );
                Assert.assertNotNull(importEnum    );
                
                this.nestedB  = nestedMessage.findFieldByName("bb");
                this.foreignC = foreignMessage.findFieldByName("c");
                this.importD  = importMessage.findFieldByName("d");
                this.nestedFoo = nestedEnum.findValueByName("FOO");
                this.nestedBar = nestedEnum.findValueByName("BAR");
                this.nestedBaz = nestedEnum.findValueByName("BAZ");
                this.foreignFoo = foreignEnum.findValueByName("FOREIGN_FOO");
                this.foreignBar = foreignEnum.findValueByName("FOREIGN_BAR");
                this.foreignBaz = foreignEnum.findValueByName("FOREIGN_BAZ");
                this.importFoo = importEnum.findValueByName("IMPORT_FOO");
                this.importBar = importEnum.findValueByName("IMPORT_BAR");
                this.importBaz = importEnum.findValueByName("IMPORT_BAZ");
                
                this.groupA = optionalGroup.findFieldByName("a");
                this.repeatedGroupA = repeatedGroup.findFieldByName("a");
                
                Assert.assertNotNull(groupA        );
                Assert.assertNotNull(repeatedGroupA);
                Assert.assertNotNull(nestedB       );
                Assert.assertNotNull(foreignC      );
                Assert.assertNotNull(importD       );
                Assert.assertNotNull(nestedFoo     );
                Assert.assertNotNull(nestedBar     );
                Assert.assertNotNull(nestedBaz     );
                Assert.assertNotNull(foreignFoo    );
                Assert.assertNotNull(foreignBar    );
                Assert.assertNotNull(foreignBaz    );
                Assert.assertNotNull(importFoo     );
                Assert.assertNotNull(importBar     );
                Assert.assertNotNull(importBaz     );
            }
            
            /**
             * Shorthand to get a FieldDescriptor for a field of unittest::TestAllTypes.
             */
            private Descriptors.FieldDescriptor f(String name) {
                Descriptors.FieldDescriptor result;
                if (extensionRegistry == null) {
                    result = baseDescriptor.findFieldByName(name);
                } else {
                    result = file.findExtensionByName(name + "_extension");
                }
                Assert.assertNotNull(result);
                return result;
            }
            
            /**
             * Calls {@code parent.newBuilderForField()} or uses the
             * {@code ExtensionRegistry} to find an appropriate builder, depending
             * on what type is being tested.
             */
            private Message.Builder newBuilderForField(
           Message.Builder parent, Descriptors.FieldDescriptor field) {
                if (extensionRegistry == null) {
                    return parent.newBuilderForField(field);
                } else {
                    ExtensionRegistry.ExtensionInfo extension =
                    extensionRegistry.findExtensionByNumber(field.getContainingType(),
                field.getNumber());
                    Assert.assertNotNull(extension);
                    Assert.assertNotNull(extension.defaultInstance);
                    return extension.defaultInstance.createBuilder();
                }
            }
            
            // -------------------------------------------------------------------
            
            /**
             * Set every field of {@code message} to the values expected by
             * {@code assertAllFieldsSet()}, using the {@link Message.Builder}
             * reflection interface.
             */
            void setAllFieldsViaReflection(Message.Builder message) {
                [message setField(f("optional_int32"   ), 101 );
                 [message setField(f("optional_int64"   ), 102L);
                  [message setField(f("optional_uint32"  ), 103 );
                   [message setField(f("optional_uint64"  ), 104L);
                    [message setField(f("optional_sint32"  ), 105 );
                     [message setField(f("optional_sint64"  ), 106L);
                      [message setField(f("optional_fixed32" ), 107 );
                       [message setField(f("optional_fixed64" ), 108L);
                        [message setField(f("optional_sfixed32"), 109 );
                         [message setField(f("optional_sfixed64"), 110L);
    [message setField(f("optional_float"   ), 111F);
     [message setField(f("optional_double"  ), 112D);
      [message setField(f("optional_bool"    ), true);
       [message setField(f("optional_string"  ), "115");
        [message setField(f("optional_bytes"   ), toData("116"));
         
         [message setField(f("optionalgroup"),
     newBuilderForField(message, f("optionalgroup"))
 .setField(groupA, 117) build]);
          [message setField(f("optional_nested_message"),
      newBuilderForField(message, f("optional_nested_message"))
.setField(nestedB, 118) build]);
           [message setField(f("optional_foreign_message"),
       newBuilderForField(message, f("optional_foreign_message"))
 .setField(foreignC, 119) build]);
            [message setField(f("optional_import_message"),
        newBuilderForField(message, f("optional_import_message"))
.setField(importD, 120) build]);
             
             [message setField(f("optional_nested_enum" ),  nestedBaz);
              [message setField(f("optional_foreign_enum"), foreignBaz);
               [message setField(f("optional_import_enum" ),  importBaz);
                
                [message setField(f("optional_string_piece" ), "124");
                 [message setField(f("optional_cord" ), "125");
                  
                  // -----------------------------------------------------------------
                  
                  message.addRepeatedField(f("repeated_int32"   ), 201 );
                  message.addRepeatedField(f("repeated_int64"   ), 202L);
                  message.addRepeatedField(f("repeated_uint32"  ), 203 );
                  message.addRepeatedField(f("repeated_uint64"  ), 204L);
                  message.addRepeatedField(f("repeated_sint32"  ), 205 );
                  message.addRepeatedField(f("repeated_sint64"  ), 206L);
                  message.addRepeatedField(f("repeated_fixed32" ), 207 );
                  message.addRepeatedField(f("repeated_fixed64" ), 208L);
                  message.addRepeatedField(f("repeated_sfixed32"), 209 );
                  message.addRepeatedField(f("repeated_sfixed64"), 210L);
                  message.addRepeatedField(f("repeated_float"   ), 211F);
                  message.addRepeatedField(f("repeated_double"  ), 212D);
                  message.addRepeatedField(f("repeated_bool"    ), true);
                  message.addRepeatedField(f("repeated_string"  ), "215");
                  message.addRepeatedField(f("repeated_bytes"   ), toData("216"));
                  
                  message.addRepeatedField(f("repeatedgroup"),
                     newBuilderForField(message, f("repeatedgroup"))
       .setField(repeatedGroupA, 217) build]);
                  message.addRepeatedField(f("repeated_nested_message"),
                     newBuilderForField(message, f("repeated_nested_message"))
       .setField(nestedB, 218) build]);
                  message.addRepeatedField(f("repeated_foreign_message"),
                     newBuilderForField(message, f("repeated_foreign_message"))
       .setField(foreignC, 219) build]);
                  message.addRepeatedField(f("repeated_import_message"),
                     newBuilderForField(message, f("repeated_import_message"))
       .setField(importD, 220) build]);
                  
                  message.addRepeatedField(f("repeated_nested_enum" ),  nestedBar);
                  message.addRepeatedField(f("repeated_foreign_enum"), foreignBar);
                  message.addRepeatedField(f("repeated_import_enum" ),  importBar);
                  
                  message.addRepeatedField(f("repeated_string_piece" ), "224");
                  message.addRepeatedField(f("repeated_cord" ), "225");
                  
                  // Add a second one of each field.
                  message.addRepeatedField(f("repeated_int32"   ), 301 );
                  message.addRepeatedField(f("repeated_int64"   ), 302L);
                  message.addRepeatedField(f("repeated_uint32"  ), 303 );
                  message.addRepeatedField(f("repeated_uint64"  ), 304L);
                  message.addRepeatedField(f("repeated_sint32"  ), 305 );
                  message.addRepeatedField(f("repeated_sint64"  ), 306L);
                  message.addRepeatedField(f("repeated_fixed32" ), 307 );
                  message.addRepeatedField(f("repeated_fixed64" ), 308L);
                  message.addRepeatedField(f("repeated_sfixed32"), 309 );
                  message.addRepeatedField(f("repeated_sfixed64"), 310L);
                  message.addRepeatedField(f("repeated_float"   ), 311F);
                  message.addRepeatedField(f("repeated_double"  ), 312D);
                  message.addRepeatedField(f("repeated_bool"    ), false);
                  message.addRepeatedField(f("repeated_string"  ), "315");
                  message.addRepeatedField(f("repeated_bytes"   ), toData("316"));
                  
                  message.addRepeatedField(f("repeatedgroup"),
                     newBuilderForField(message, f("repeatedgroup"))
       .setField(repeatedGroupA, 317) build]);
                  message.addRepeatedField(f("repeated_nested_message"),
                     newBuilderForField(message, f("repeated_nested_message"))
       .setField(nestedB, 318) build]);
                  message.addRepeatedField(f("repeated_foreign_message"),
                     newBuilderForField(message, f("repeated_foreign_message"))
       .setField(foreignC, 319) build]);
                  message.addRepeatedField(f("repeated_import_message"),
                     newBuilderForField(message, f("repeated_import_message"))
       .setField(importD, 320) build]);
                  
                  message.addRepeatedField(f("repeated_nested_enum" ),  nestedBaz);
                  message.addRepeatedField(f("repeated_foreign_enum"), foreignBaz);
                  message.addRepeatedField(f("repeated_import_enum" ),  importBaz);
                  
                  message.addRepeatedField(f("repeated_string_piece" ), "324");
                  message.addRepeatedField(f("repeated_cord" ), "325");
                  
                  // -----------------------------------------------------------------
                  
                  [message setField(f("default_int32"   ), 401 );
                   [message setField(f("default_int64"   ), 402L);
                    [message setField(f("default_uint32"  ), 403 );
                     [message setField(f("default_uint64"  ), 404L);
                      [message setField(f("default_sint32"  ), 405 );
                       [message setField(f("default_sint64"  ), 406L);
                        [message setField(f("default_fixed32" ), 407 );
                         [message setField(f("default_fixed64" ), 408L);
    [message setField(f("default_sfixed32"), 409 );
     [message setField(f("default_sfixed64"), 410L);
      [message setField(f("default_float"   ), 411F);
       [message setField(f("default_double"  ), 412D);
        [message setField(f("default_bool"    ), false);
         [message setField(f("default_string"  ), "415");
          [message setField(f("default_bytes"   ), toData("416"));
           
           [message setField(f("default_nested_enum" ),  nestedFoo);
            [message setField(f("default_foreign_enum"), foreignFoo);
             [message setField(f("default_import_enum" ),  importFoo);
              
              [message setField(f("default_string_piece" ), "424");
               [message setField(f("default_cord" ), "425");
               }
               
               // -------------------------------------------------------------------
               
               /**
                 * Modify the repeated fields of {@code message} to contain the values
                 * expected by {@code assertRepeatedFieldsModified()}, using the
                 * {@link Message.Builder} reflection interface.
                 */
               void modifyRepeatedFieldsViaReflection(Message.Builder message) {
                    [message setRepeatedField(f("repeated_int32"   ), 1, 501 );
                     [message setRepeatedField(f("repeated_int64"   ), 1, 502L);
                      [message setRepeatedField(f("repeated_uint32"  ), 1, 503 );
                       [message setRepeatedField(f("repeated_uint64"  ), 1, 504L);
                        [message setRepeatedField(f("repeated_sint32"  ), 1, 505 );
                         [message setRepeatedField(f("repeated_sint64"  ), 1, 506L);
    [message setRepeatedField(f("repeated_fixed32" ), 1, 507 );
     [message setRepeatedField(f("repeated_fixed64" ), 1, 508L);
      [message setRepeatedField(f("repeated_sfixed32"), 1, 509 );
       [message setRepeatedField(f("repeated_sfixed64"), 1, 510L);
        [message setRepeatedField(f("repeated_float"   ), 1, 511F);
         [message setRepeatedField(f("repeated_double"  ), 1, 512D);
          [message setRepeatedField(f("repeated_bool"    ), 1, true);
           [message setRepeatedField(f("repeated_string"  ), 1, "515");
            [message setRepeatedField(f("repeated_bytes"   ), 1, toData("516"));
             
             [message setRepeatedField(f("repeatedgroup"), 1,
                 newBuilderForField(message, f("repeatedgroup"))
   .setField(repeatedGroupA, 517) build]);
              [message setRepeatedField(f("repeated_nested_message"), 1,
                  newBuilderForField(message, f("repeated_nested_message"))
    .setField(nestedB, 518) build]);
               [message setRepeatedField(f("repeated_foreign_message"), 1,
                   newBuilderForField(message, f("repeated_foreign_message"))
     .setField(foreignC, 519) build]);
                [message setRepeatedField(f("repeated_import_message"), 1,
                    newBuilderForField(message, f("repeated_import_message"))
      .setField(importD, 520) build]);
                 
                 [message setRepeatedField(f("repeated_nested_enum" ), 1,  nestedFoo);
                  [message setRepeatedField(f("repeated_foreign_enum"), 1, foreignFoo);
                   [message setRepeatedField(f("repeated_import_enum" ), 1,  importFoo);
                    
                    [message setRepeatedField(f("repeated_string_piece"), 1, "524");
                     [message setRepeatedField(f("repeated_cord"), 1, "525");
                     }
                     
                     // -------------------------------------------------------------------
                     
                     /**
                     * Assert (using {@code junit.framework.Assert}} that all fields of
                     * {@code message} are set to the values assigned by {@code setAllFields},
                     * using the {@link Message} reflection interface.
                     */
                     public void assertAllFieldsSetViaReflection(Message message) {
                        STAssertTrue(message.hasField(f("optional_int32"   )));
                        STAssertTrue(message.hasField(f("optional_int64"   )));
                        STAssertTrue(message.hasField(f("optional_uint32"  )));
                        STAssertTrue(message.hasField(f("optional_uint64"  )));
                        STAssertTrue(message.hasField(f("optional_sint32"  )));
                        STAssertTrue(message.hasField(f("optional_sint64"  )));
                        STAssertTrue(message.hasField(f("optional_fixed32" )));
                        STAssertTrue(message.hasField(f("optional_fixed64" )));
                        STAssertTrue(message.hasField(f("optional_sfixed32")));
                        STAssertTrue(message.hasField(f("optional_sfixed64")));
                        STAssertTrue(message.hasField(f("optional_float"   )));
                        STAssertTrue(message.hasField(f("optional_double"  )));
                        STAssertTrue(message.hasField(f("optional_bool"    )));
                        STAssertTrue(message.hasField(f("optional_string"  )));
                        STAssertTrue(message.hasField(f("optional_bytes"   )));
                        
                        STAssertTrue(message.hasField(f("optionalgroup"           )));
                        STAssertTrue(message.hasField(f("optional_nested_message" )));
                        STAssertTrue(message.hasField(f("optional_foreign_message")));
                        STAssertTrue(message.hasField(f("optional_import_message" )));
                        
                        STAssertTrue(
                    ((Message)message.getField(f("optionalgroup"))).hasField(groupA));
                        STAssertTrue(
                    ((Message)message.getField(f("optional_nested_message")))
.hasField(nestedB));
                        STAssertTrue(
                    ((Message)message.getField(f("optional_foreign_message")))
.hasField(foreignC));
                        STAssertTrue(
                    ((Message)message.getField(f("optional_import_message")))
.hasField(importD));
                        
                        STAssertTrue(message.hasField(f("optional_nested_enum" )));
                        STAssertTrue(message.hasField(f("optional_foreign_enum")));
                        STAssertTrue(message.hasField(f("optional_import_enum" )));
                        
                        STAssertTrue(message.hasField(f("optional_string_piece")));
                        STAssertTrue(message.hasField(f("optional_cord")));
                        
                        STAssertTrue(101, message.getField(f("optional_int32"   )));
                        STAssertTrue(102L, message.getField(f("optional_int64"   )));
                        STAssertTrue(103, message.getField(f("optional_uint32"  )));
                        STAssertTrue(104L, message.getField(f("optional_uint64"  )));
                        STAssertTrue(105, message.getField(f("optional_sint32"  )));
                        STAssertTrue(106L, message.getField(f("optional_sint64"  )));
                        STAssertTrue(107, message.getField(f("optional_fixed32" )));
                        STAssertTrue(108L, message.getField(f("optional_fixed64" )));
                        STAssertTrue(109, message.getField(f("optional_sfixed32")));
                        STAssertTrue(110L, message.getField(f("optional_sfixed64")));
                        STAssertTrue(111F, message.getField(f("optional_float"   )));
                        STAssertTrue(112D, message.getField(f("optional_double"  )));
                        STAssertTrue(true, message.getField(f("optional_bool"    )));
                        STAssertTrue("115", message.getField(f("optional_string"  )));
                        STAssertTrue(toData("116"), message.getField(f("optional_bytes")));
                        
                        STAssertTrue(117,
                      ((Message)message.getField(f("optionalgroup"))).getField(groupA));
                        STAssertTrue(118,
                      ((Message)message.getField(f("optional_nested_message")))
.getField(nestedB));
                        STAssertTrue(119,
                      ((Message)message.getField(f("optional_foreign_message")))
.getField(foreignC));
                        STAssertTrue(120,
                      ((Message)message.getField(f("optional_import_message")))
.getField(importD));
                        
                        STAssertTrue( nestedBaz, message.getField(f("optional_nested_enum" )));
                        STAssertTrue(foreignBaz, message.getField(f("optional_foreign_enum")));
                        STAssertTrue( importBaz, message.getField(f("optional_import_enum" )));
                        
                        STAssertTrue("124", message.getField(f("optional_string_piece")));
                        STAssertTrue("125", message.getField(f("optional_cord")));
                        
                        // -----------------------------------------------------------------
                        
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_int32"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_int64"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_float"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_double"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_bool"    )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_string"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                        
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_message" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                        
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_string_piece")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_cord")));
                        
                        STAssertTrue(201, message.getRepeatedField(f("repeated_int32"   ), 0));
                        STAssertTrue(202L, message.getRepeatedField(f("repeated_int64"   ), 0));
                        STAssertTrue(203, message.getRepeatedField(f("repeated_uint32"  ), 0));
                        STAssertTrue(204L, message.getRepeatedField(f("repeated_uint64"  ), 0));
                        STAssertTrue(205, message.getRepeatedField(f("repeated_sint32"  ), 0));
                        STAssertTrue(206L, message.getRepeatedField(f("repeated_sint64"  ), 0));
                        STAssertTrue(207, message.getRepeatedField(f("repeated_fixed32" ), 0));
                        STAssertTrue(208L, message.getRepeatedField(f("repeated_fixed64" ), 0));
                        STAssertTrue(209, message.getRepeatedField(f("repeated_sfixed32"), 0));
                        STAssertTrue(210L, message.getRepeatedField(f("repeated_sfixed64"), 0));
                        STAssertTrue(211F, message.getRepeatedField(f("repeated_float"   ), 0));
                        STAssertTrue(212D, message.getRepeatedField(f("repeated_double"  ), 0));
                        STAssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 0));
                        STAssertTrue("215", message.getRepeatedField(f("repeated_string"  ), 0));
                        STAssertTrue(toData("216"), message.getRepeatedField(f("repeated_bytes"), 0));
                        
                        STAssertTrue(217,
                      ((Message)message.getRepeatedField(f("repeatedgroup"), 0))
.getField(repeatedGroupA));
                        STAssertTrue(218,
                      ((Message)message.getRepeatedField(f("repeated_nested_message"), 0))
.getField(nestedB));
                        STAssertTrue(219,
                      ((Message)message.getRepeatedField(f("repeated_foreign_message"), 0))
.getField(foreignC));
                        STAssertTrue(220,
                      ((Message)message.getRepeatedField(f("repeated_import_message"), 0))
.getField(importD));
                        
                        STAssertTrue( nestedBar, message.getRepeatedField(f("repeated_nested_enum" ),0));
                        STAssertTrue(foreignBar, message.getRepeatedField(f("repeated_foreign_enum"),0));
                        STAssertTrue( importBar, message.getRepeatedField(f("repeated_import_enum" ),0));
                        
                        STAssertTrue("224", message.getRepeatedField(f("repeated_string_piece"), 0));
                        STAssertTrue("225", message.getRepeatedField(f("repeated_cord"), 0));
                        
                        STAssertTrue(301, message.getRepeatedField(f("repeated_int32"   ), 1));
                        STAssertTrue(302L, message.getRepeatedField(f("repeated_int64"   ), 1));
                        STAssertTrue(303, message.getRepeatedField(f("repeated_uint32"  ), 1));
                        STAssertTrue(304L, message.getRepeatedField(f("repeated_uint64"  ), 1));
                        STAssertTrue(305, message.getRepeatedField(f("repeated_sint32"  ), 1));
                        STAssertTrue(306L, message.getRepeatedField(f("repeated_sint64"  ), 1));
                        STAssertTrue(307, message.getRepeatedField(f("repeated_fixed32" ), 1));
                        STAssertTrue(308L, message.getRepeatedField(f("repeated_fixed64" ), 1));
                        STAssertTrue(309, message.getRepeatedField(f("repeated_sfixed32"), 1));
                        STAssertTrue(310L, message.getRepeatedField(f("repeated_sfixed64"), 1));
                        STAssertTrue(311F, message.getRepeatedField(f("repeated_float"   ), 1));
                        STAssertTrue(312D, message.getRepeatedField(f("repeated_double"  ), 1));
                        STAssertTrue(false, message.getRepeatedField(f("repeated_bool"    ), 1));
                        STAssertTrue("315", message.getRepeatedField(f("repeated_string"  ), 1));
                        STAssertTrue(toData("316"), message.getRepeatedField(f("repeated_bytes"), 1));
                        
                        STAssertTrue(317,
                      ((Message)message.getRepeatedField(f("repeatedgroup"), 1))
.getField(repeatedGroupA));
                        STAssertTrue(318,
                      ((Message)message.getRepeatedField(f("repeated_nested_message"), 1))
.getField(nestedB));
                        STAssertTrue(319,
                      ((Message)message.getRepeatedField(f("repeated_foreign_message"), 1))
.getField(foreignC));
                        STAssertTrue(320,
                      ((Message)message.getRepeatedField(f("repeated_import_message"), 1))
.getField(importD));
                        
                        STAssertTrue( nestedBaz, message.getRepeatedField(f("repeated_nested_enum" ),1));
                        STAssertTrue(foreignBaz, message.getRepeatedField(f("repeated_foreign_enum"),1));
                        STAssertTrue( importBaz, message.getRepeatedField(f("repeated_import_enum" ),1));
                        
                        STAssertTrue("324", message.getRepeatedField(f("repeated_string_piece"), 1));
                        STAssertTrue("325", message.getRepeatedField(f("repeated_cord"), 1));
                        
                        // -----------------------------------------------------------------
                        
                        STAssertTrue(message.hasField(f("default_int32"   )));
                        STAssertTrue(message.hasField(f("default_int64"   )));
                        STAssertTrue(message.hasField(f("default_uint32"  )));
                        STAssertTrue(message.hasField(f("default_uint64"  )));
                        STAssertTrue(message.hasField(f("default_sint32"  )));
                        STAssertTrue(message.hasField(f("default_sint64"  )));
                        STAssertTrue(message.hasField(f("default_fixed32" )));
                        STAssertTrue(message.hasField(f("default_fixed64" )));
                        STAssertTrue(message.hasField(f("default_sfixed32")));
                        STAssertTrue(message.hasField(f("default_sfixed64")));
                        STAssertTrue(message.hasField(f("default_float"   )));
                        STAssertTrue(message.hasField(f("default_double"  )));
                        STAssertTrue(message.hasField(f("default_bool"    )));
                        STAssertTrue(message.hasField(f("default_string"  )));
                        STAssertTrue(message.hasField(f("default_bytes"   )));
                        
                        STAssertTrue(message.hasField(f("default_nested_enum" )));
                        STAssertTrue(message.hasField(f("default_foreign_enum")));
                        STAssertTrue(message.hasField(f("default_import_enum" )));
                        
                        STAssertTrue(message.hasField(f("default_string_piece")));
                        STAssertTrue(message.hasField(f("default_cord")));
                        
                        STAssertTrue(401, message.getField(f("default_int32"   )));
                        STAssertTrue(402L, message.getField(f("default_int64"   )));
                        STAssertTrue(403, message.getField(f("default_uint32"  )));
                        STAssertTrue(404L, message.getField(f("default_uint64"  )));
                        STAssertTrue(405, message.getField(f("default_sint32"  )));
                        STAssertTrue(406L, message.getField(f("default_sint64"  )));
                        STAssertTrue(407, message.getField(f("default_fixed32" )));
                        STAssertTrue(408L, message.getField(f("default_fixed64" )));
                        STAssertTrue(409, message.getField(f("default_sfixed32")));
                        STAssertTrue(410L, message.getField(f("default_sfixed64")));
                        STAssertTrue(411F, message.getField(f("default_float"   )));
                        STAssertTrue(412D, message.getField(f("default_double"  )));
                        STAssertTrue(false, message.getField(f("default_bool"    )));
                        STAssertTrue("415", message.getField(f("default_string"  )));
                        STAssertTrue(toData("416"), message.getField(f("default_bytes")));
                        
                        STAssertTrue( nestedFoo, message.getField(f("default_nested_enum" )));
                        STAssertTrue(foreignFoo, message.getField(f("default_foreign_enum")));
                        STAssertTrue( importFoo, message.getField(f("default_import_enum" )));
                        
                        STAssertTrue("424", message.getField(f("default_string_piece")));
                        STAssertTrue("425", message.getField(f("default_cord")));
                    }
                     
                     // -------------------------------------------------------------------
                     
                     /**
                     * Assert (using {@code junit.framework.Assert}} that all fields of
                     * {@code message} are cleared, and that getting the fields returns their
                     * default values, using the {@link Message} reflection interface.
                     */
                     public void assertClearViaReflection(Message message) {
                        // has_blah() should initially be false for all optional fields.
                        STAssertFalse(message.hasField(f("optional_int32"   )));
                        STAssertFalse(message.hasField(f("optional_int64"   )));
                        STAssertFalse(message.hasField(f("optional_uint32"  )));
                        STAssertFalse(message.hasField(f("optional_uint64"  )));
                        STAssertFalse(message.hasField(f("optional_sint32"  )));
                        STAssertFalse(message.hasField(f("optional_sint64"  )));
                        STAssertFalse(message.hasField(f("optional_fixed32" )));
                        STAssertFalse(message.hasField(f("optional_fixed64" )));
                        STAssertFalse(message.hasField(f("optional_sfixed32")));
                        STAssertFalse(message.hasField(f("optional_sfixed64")));
                        STAssertFalse(message.hasField(f("optional_float"   )));
                        STAssertFalse(message.hasField(f("optional_double"  )));
                        STAssertFalse(message.hasField(f("optional_bool"    )));
                        STAssertFalse(message.hasField(f("optional_string"  )));
                        STAssertFalse(message.hasField(f("optional_bytes"   )));
                        
                        STAssertFalse(message.hasField(f("optionalgroup"           )));
                        STAssertFalse(message.hasField(f("optional_nested_message" )));
                        STAssertFalse(message.hasField(f("optional_foreign_message")));
                        STAssertFalse(message.hasField(f("optional_import_message" )));
                        
                        STAssertFalse(message.hasField(f("optional_nested_enum" )));
                        STAssertFalse(message.hasField(f("optional_foreign_enum")));
                        STAssertFalse(message.hasField(f("optional_import_enum" )));
                        
                        STAssertFalse(message.hasField(f("optional_string_piece")));
                        STAssertFalse(message.hasField(f("optional_cord")));
                        
                        // Optional fields without defaults are set to zero or something like it.
                        STAssertTrue(0, message.getField(f("optional_int32"   )));
                        STAssertTrue(0L, message.getField(f("optional_int64"   )));
                        STAssertTrue(0, message.getField(f("optional_uint32"  )));
                        STAssertTrue(0L, message.getField(f("optional_uint64"  )));
                        STAssertTrue(0, message.getField(f("optional_sint32"  )));
                        STAssertTrue(0L, message.getField(f("optional_sint64"  )));
                        STAssertTrue(0, message.getField(f("optional_fixed32" )));
                        STAssertTrue(0L, message.getField(f("optional_fixed64" )));
                        STAssertTrue(0, message.getField(f("optional_sfixed32")));
                        STAssertTrue(0L, message.getField(f("optional_sfixed64")));
                        STAssertTrue(0F, message.getField(f("optional_float"   )));
                        STAssertTrue(0D, message.getField(f("optional_double"  )));
                        STAssertTrue(false, message.getField(f("optional_bool"    )));
                        STAssertTrue("", message.getField(f("optional_string"  )));
                        STAssertTrue(ByteString.EMPTY, message.getField(f("optional_bytes")));
                        
                        // Embedded messages should also be clear.
                        STAssertFalse(
                ((Message)message.getField(f("optionalgroup"))).hasField(groupA));
                        STAssertFalse(
                ((Message)message.getField(f("optional_nested_message")))
.hasField(nestedB));
                        STAssertFalse(
                ((Message)message.getField(f("optional_foreign_message")))
.hasField(foreignC));
                        STAssertFalse(
                ((Message)message.getField(f("optional_import_message")))
.hasField(importD));
                        
                        STAssertTrue(0,
                      ((Message)message.getField(f("optionalgroup"))).getField(groupA));
                        STAssertTrue(0,
                      ((Message)message.getField(f("optional_nested_message")))
.getField(nestedB));
                        STAssertTrue(0,
                      ((Message)message.getField(f("optional_foreign_message")))
.getField(foreignC));
                        STAssertTrue(0,
                      ((Message)message.getField(f("optional_import_message")))
.getField(importD));
                        
                        // Enums without defaults are set to the first value in the enum.
                        STAssertTrue( nestedFoo, message.getField(f("optional_nested_enum" )));
                        STAssertTrue(foreignFoo, message.getField(f("optional_foreign_enum")));
                        STAssertTrue( importFoo, message.getField(f("optional_import_enum" )));
                        
                        STAssertTrue("", message.getField(f("optional_string_piece")));
                        STAssertTrue("", message.getField(f("optional_cord")));
                        
                        // Repeated fields are empty.
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_int32"   )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_int64"   )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_float"   )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_double"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_bool"    )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_string"  )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                        
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_import_message" )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                        
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_string_piece")));
                        STAssertTrue(0, message.getRepeatedFieldCount(f("repeated_cord")));
                        
                        // has_blah() should also be false for all default fields.
                        STAssertFalse(message.hasField(f("default_int32"   )));
                        STAssertFalse(message.hasField(f("default_int64"   )));
                        STAssertFalse(message.hasField(f("default_uint32"  )));
                        STAssertFalse(message.hasField(f("default_uint64"  )));
                        STAssertFalse(message.hasField(f("default_sint32"  )));
                        STAssertFalse(message.hasField(f("default_sint64"  )));
                        STAssertFalse(message.hasField(f("default_fixed32" )));
                        STAssertFalse(message.hasField(f("default_fixed64" )));
                        STAssertFalse(message.hasField(f("default_sfixed32")));
                        STAssertFalse(message.hasField(f("default_sfixed64")));
                        STAssertFalse(message.hasField(f("default_float"   )));
                        STAssertFalse(message.hasField(f("default_double"  )));
                        STAssertFalse(message.hasField(f("default_bool"    )));
                        STAssertFalse(message.hasField(f("default_string"  )));
                        STAssertFalse(message.hasField(f("default_bytes"   )));
                        
                        STAssertFalse(message.hasField(f("default_nested_enum" )));
                        STAssertFalse(message.hasField(f("default_foreign_enum")));
                        STAssertFalse(message.hasField(f("default_import_enum" )));
                        
                        STAssertFalse(message.hasField(f("default_string_piece" )));
                        STAssertFalse(message.hasField(f("default_cord" )));
                        
                        // Fields with defaults have their default values (duh).
                        STAssertTrue( 41, message.getField(f("default_int32"   )));
                        STAssertTrue( 42L, message.getField(f("default_int64"   )));
                        STAssertTrue( 43, message.getField(f("default_uint32"  )));
                        STAssertTrue( 44L, message.getField(f("default_uint64"  )));
                        STAssertTrue(-45, message.getField(f("default_sint32"  )));
                        STAssertTrue( 46L, message.getField(f("default_sint64"  )));
                        STAssertTrue( 47, message.getField(f("default_fixed32" )));
                        STAssertTrue( 48L, message.getField(f("default_fixed64" )));
                        STAssertTrue( 49, message.getField(f("default_sfixed32")));
                        STAssertTrue(-50L, message.getField(f("default_sfixed64")));
                        STAssertTrue( 51.5F, message.getField(f("default_float"   )));
                        STAssertTrue( 52e3D, message.getField(f("default_double"  )));
                        STAssertTrue(true, message.getField(f("default_bool"    )));
                        STAssertTrue("hello", message.getField(f("default_string"  )));
                        STAssertTrue(toData("world"), message.getField(f("default_bytes")));
                        
                        STAssertTrue( nestedBar, message.getField(f("default_nested_enum" )));
                        STAssertTrue(foreignBar, message.getField(f("default_foreign_enum")));
                        STAssertTrue( importBar, message.getField(f("default_import_enum" )));
                        
                        STAssertTrue("abc", message.getField(f("default_string_piece")));
                        STAssertTrue("123", message.getField(f("default_cord")));
                    }
                     
                     // ---------------------------------------------------------------
                     
                     public void assertRepeatedFieldsModifiedViaReflection(Message message) {
                        // ModifyRepeatedFields only sets the second repeated element of each
                        // field.  In addition to verifying this, we also verify that the first
                        // element and size were *not* modified.
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_int32"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_int64"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_float"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_double"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_bool"    )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_string"  )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                        
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_message" )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                        
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_string_piece")));
                        STAssertTrue(2, message.getRepeatedFieldCount(f("repeated_cord")));
                        
                        STAssertTrue(201, message.getRepeatedField(f("repeated_int32"   ), 0));
                        STAssertTrue(202L, message.getRepeatedField(f("repeated_int64"   ), 0));
                        STAssertTrue(203, message.getRepeatedField(f("repeated_uint32"  ), 0));
                        STAssertTrue(204L, message.getRepeatedField(f("repeated_uint64"  ), 0));
                        STAssertTrue(205, message.getRepeatedField(f("repeated_sint32"  ), 0));
                        STAssertTrue(206L, message.getRepeatedField(f("repeated_sint64"  ), 0));
                        STAssertTrue(207, message.getRepeatedField(f("repeated_fixed32" ), 0));
                        STAssertTrue(208L, message.getRepeatedField(f("repeated_fixed64" ), 0));
                        STAssertTrue(209, message.getRepeatedField(f("repeated_sfixed32"), 0));
                        STAssertTrue(210L, message.getRepeatedField(f("repeated_sfixed64"), 0));
                        STAssertTrue(211F, message.getRepeatedField(f("repeated_float"   ), 0));
                        STAssertTrue(212D, message.getRepeatedField(f("repeated_double"  ), 0));
                        STAssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 0));
                        STAssertTrue("215", message.getRepeatedField(f("repeated_string"  ), 0));
                        STAssertTrue(toData("216"), message.getRepeatedField(f("repeated_bytes"), 0));
                        
                        STAssertTrue(217,
                      ((Message)message.getRepeatedField(f("repeatedgroup"), 0))
.getField(repeatedGroupA));
                        STAssertTrue(218,
                      ((Message)message.getRepeatedField(f("repeated_nested_message"), 0))
.getField(nestedB));
                        STAssertTrue(219,
                      ((Message)message.getRepeatedField(f("repeated_foreign_message"), 0))
.getField(foreignC));
                        STAssertTrue(220,
                      ((Message)message.getRepeatedField(f("repeated_import_message"), 0))
.getField(importD));
                        
                        STAssertTrue( nestedBar, message.getRepeatedField(f("repeated_nested_enum" ),0));
                        STAssertTrue(foreignBar, message.getRepeatedField(f("repeated_foreign_enum"),0));
                        STAssertTrue( importBar, message.getRepeatedField(f("repeated_import_enum" ),0));
                        
                        STAssertTrue("224", message.getRepeatedField(f("repeated_string_piece"), 0));
                        STAssertTrue("225", message.getRepeatedField(f("repeated_cord"), 0));
                        
                        STAssertTrue(501, message.getRepeatedField(f("repeated_int32"   ), 1));
                        STAssertTrue(502L, message.getRepeatedField(f("repeated_int64"   ), 1));
                        STAssertTrue(503, message.getRepeatedField(f("repeated_uint32"  ), 1));
                        STAssertTrue(504L, message.getRepeatedField(f("repeated_uint64"  ), 1));
                        STAssertTrue(505, message.getRepeatedField(f("repeated_sint32"  ), 1));
                        STAssertTrue(506L, message.getRepeatedField(f("repeated_sint64"  ), 1));
                        STAssertTrue(507, message.getRepeatedField(f("repeated_fixed32" ), 1));
                        STAssertTrue(508L, message.getRepeatedField(f("repeated_fixed64" ), 1));
                        STAssertTrue(509, message.getRepeatedField(f("repeated_sfixed32"), 1));
                        STAssertTrue(510L, message.getRepeatedField(f("repeated_sfixed64"), 1));
                        STAssertTrue(511F, message.getRepeatedField(f("repeated_float"   ), 1));
                        STAssertTrue(512D, message.getRepeatedField(f("repeated_double"  ), 1));
                        STAssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 1));
                        STAssertTrue("515", message.getRepeatedField(f("repeated_string"  ), 1));
                        STAssertTrue(toData("516"), message.getRepeatedField(f("repeated_bytes"), 1));
                        
                        STAssertTrue(517,
                      ((Message)message.getRepeatedField(f("repeatedgroup"), 1))
.getField(repeatedGroupA));
                        STAssertTrue(518,
                      ((Message)message.getRepeatedField(f("repeated_nested_message"), 1))
.getField(nestedB));
                        STAssertTrue(519,
                      ((Message)message.getRepeatedField(f("repeated_foreign_message"), 1))
.getField(foreignC));
                        STAssertTrue(520,
                      ((Message)message.getRepeatedField(f("repeated_import_message"), 1))
.getField(importD));
                        
                        STAssertTrue( nestedFoo, message.getRepeatedField(f("repeated_nested_enum" ),1));
                        STAssertTrue(foreignFoo, message.getRepeatedField(f("repeated_foreign_enum"),1));
                        STAssertTrue( importFoo, message.getRepeatedField(f("repeated_import_enum" ),1));
                        
                        STAssertTrue("524", message.getRepeatedField(f("repeated_string_piece"), 1));
                        STAssertTrue("525", message.getRepeatedField(f("repeated_cord"), 1));
                    }
                     }
                     
                    /**
                     * @param filePath The path relative to
                     * {@link com.google.testing.util.TestUtil#getDefaultSrcDir}.
                     */
                     public static String readTextFromFile(String filePath) {
                        return readBytesFromFile(filePath).toStringUtf8();
                    }
                     
                     private static File getTestDataDir() {
                        // Search each parent directory looking for "src/google/protobuf".
                        File ancestor = new File(".");
                        try {
      ancestor = ancestor.getCanonicalFile();
                        } catch (IOException e) {
      throw new RuntimeException(
           "Couldn't get canonical name of working directory.", e);
                        }
                        while (ancestor != null && ancestor.exists()) {
      if (new File(ancestor, "src/google/protobuf").exists()) {
          return new File(ancestor, "src/google/protobuf/testdata");
      }
      ancestor = ancestor.getParentFile();
                        }
                        
                        throw new RuntimeException(
       "Could not find golden files.  This test must be run from within the " +
       "protobuf source package so that it can read test data files from the " +
       "C++ source tree.");
                    }
                     
                    /**
                     * @param filePath The path relative to
                     * {@link com.google.testing.util.TestUtil#getDefaultSrcDir}.
                     */
                     public static ByteString readBytesFromFile(String filename) {
                        File fullPath = new File(getTestDataDir(), filename);
                        try {
      RandomAccessFile file = new RandomAccessFile(fullPath, "r");
      byte[] content = new byte[(int) file.length()];
      file.readFully(content);
      return ByteString.copyFrom(content);
                        } catch (IOException e) {
      // Throw a RuntimeException here so that we can call this function from
      // static initializers.
      throw new IllegalArgumentException(
                   "Couldn't read file: " + fullPath.getPath(), e);
                        }
                    }
                     
                    /**
                     * Get the bytes of the "golden message".  This is a serialized TestAllTypes
                     * with all fields set as they would be by
                     * {@link setAllFields(TestAllTypes.Builder)}, but it is loaded from a file
                     * on disk rather than generated dynamically.  The file is actually generated
                     * by C++ code, so testing against it verifies compatibility with C++.
                     */
                     public static ByteString getGoldenMessage() {
                        if (goldenMessage == null) {
      goldenMessage = readBytesFromFile("golden_message");
                        }
                        return goldenMessage;
                    }
                     private static ByteString goldenMessage = null;
                     }
                     
#endif
                     
                     @end