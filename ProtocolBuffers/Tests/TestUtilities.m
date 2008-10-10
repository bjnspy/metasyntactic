// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TestUtilities.h"

#import "Macros.h"
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
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalInt64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalUint32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalUint64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalSint32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalSint64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalFixed32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalFixed64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalSfixed32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalSfixed64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalFloatExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalDoubleExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalBoolExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalStringExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
    
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalGroupExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalNestedMessageExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalForeignMessageExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalImportMessageExtension]], @"");
    
    AssertTrue([[message getExtension:[UnittestProtoRoot optionalGroupExtension]] hasA], @"");
    AssertTrue([[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] hasBb], @"");
    AssertTrue([[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] hasC], @"");
    AssertTrue([[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] hasD], @"");
    
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
    
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot optionalCordExtension]], @"");
    
    AssertTrue(101 == [[message getExtension:[UnittestProtoRoot optionalInt32Extension]] intValue], @"");
    AssertTrue(102L == [[message getExtension:[UnittestProtoRoot optionalInt64Extension]] intValue], @"");
    AssertTrue(103 == [[message getExtension:[UnittestProtoRoot optionalUint32Extension]] intValue], @"");
    AssertTrue(104L == [[message getExtension:[UnittestProtoRoot optionalUint64Extension]] intValue], @"");
    AssertTrue(105 == [[message getExtension:[UnittestProtoRoot optionalSint32Extension]] intValue], @"");
    AssertTrue(106L == [[message getExtension:[UnittestProtoRoot optionalSint64Extension]] intValue], @"");
    AssertTrue(107 == [[message getExtension:[UnittestProtoRoot optionalFixed32Extension]] intValue], @"");
    AssertTrue(108L == [[message getExtension:[UnittestProtoRoot optionalFixed64Extension]] intValue], @"");
    AssertTrue(109 == [[message getExtension:[UnittestProtoRoot optionalSfixed32Extension]] intValue], @"");
    AssertTrue(110L == [[message getExtension:[UnittestProtoRoot optionalSfixed64Extension]] intValue], @"");
    AssertTrue(111.0 == [[message getExtension:[UnittestProtoRoot optionalFloatExtension]] floatValue], @"");
    AssertTrue(112.0 == [[message getExtension:[UnittestProtoRoot optionalDoubleExtension]] doubleValue], @"");
    AssertTrue(true == [[message getExtension:[UnittestProtoRoot optionalBoolExtension]] boolValue], @"");
    AssertEqualObjects(@"115", [message getExtension:[UnittestProtoRoot optionalStringExtension]], @"");
    AssertEqualObjects([TestUtilities toData:@"116"], [message getExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
    
    AssertTrue(117 == [[message getExtension:[UnittestProtoRoot optionalGroupExtension]] a], @"");
    AssertTrue(118 == [[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] bb], @"");
    AssertTrue(119 == [[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] c], @"");
    AssertTrue(120 == [[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] d], @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAZ] == [message getExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
    AssertTrue([ForeignEnum FOREIGN_BAZ] == [message getExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
    AssertTrue([ImportEnum IMPORT_BAZ] == [message getExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
    
    AssertEqualObjects(@"124", [message getExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
    AssertEqualObjects(@"125", [message getExtension:[UnittestProtoRoot optionalCordExtension]], @"");
    
    // -----------------------------------------------------------------
    
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]], @"");
    
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]], @"");
    
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]], @"");
    AssertTrue(2 == [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]], @"");
    
    AssertTrue(201 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:0] intValue], @"");;
    AssertTrue(202L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:0] intValue], @"");;
    AssertTrue(203 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:0] intValue], @"");;
    AssertTrue(204L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:0] intValue], @"");
    AssertTrue(205 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:0] intValue], @"");
    AssertTrue(206L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:0] intValue], @"");
    AssertTrue(207 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:0] intValue], @"");
    AssertTrue(208L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:0] intValue], @"");
    AssertTrue(209 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:0] intValue], @"");
    AssertTrue(210L == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:0] intValue], @"");
    AssertTrue(211.0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension] index:0] floatValue], @"");
    AssertTrue(212.0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension] index:0] doubleValue], @"");
    AssertTrue(true == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension] index:0] boolValue], @"");
    AssertEqualObjects(@"215", [message getExtension:[UnittestProtoRoot repeatedStringExtension] index:0], @"");
    AssertEqualObjects([TestUtilities toData:@"216"], [message getExtension:[UnittestProtoRoot repeatedBytesExtension] index:0], @"");
    
    AssertTrue(217 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension] index:0] a], @"");
    AssertTrue(218 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:0] bb], @"");
    AssertTrue(219 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:0] c], @"");
    AssertTrue(220 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:0] d], @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAR] == [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:0], @"");
    AssertTrue([ForeignEnum FOREIGN_BAR] == [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:0], @"");
    AssertTrue([ImportEnum IMPORT_BAR] == [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:0], @"");
    
    AssertEqualObjects(@"224", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:0], @"");
    AssertEqualObjects(@"225", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:0], @"");
    
    AssertTrue(301 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:1] intValue], @"");
    AssertTrue(302L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:1] intValue], @"");
    AssertTrue(303 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:1] intValue], @"");
    AssertTrue(304L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:1] intValue], @"");
    AssertTrue(305 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:1] intValue], @"");
    AssertTrue(306L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:1] intValue], @"");
    AssertTrue(307 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:1] intValue], @"");
    AssertTrue(308L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:1] intValue], @"");
    AssertTrue(309 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:1] intValue], @"");
    AssertTrue(310L == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:1] intValue], @"");
    AssertTrue(311.0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension] index:1] floatValue], @"");
    AssertTrue(312.0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension] index:1] doubleValue], @"");
    AssertTrue(false == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension] index:1] boolValue], @"");
    AssertEqualObjects(@"315", [message getExtension:[UnittestProtoRoot repeatedStringExtension] index:1], @"");
    AssertEqualObjects([TestUtilities toData:@"316"], [message getExtension:[UnittestProtoRoot repeatedBytesExtension] index:1], @"");
    
    AssertTrue(317 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension] index:1] a], @"");
    AssertTrue(318 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:1] bb], @"");
    AssertTrue(319 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:1] c], @"");
    AssertTrue(320 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:1] d], @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAZ] == [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:1], @"");
    AssertTrue([ForeignEnum FOREIGN_BAZ] == [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:1], @"");
    AssertTrue([ImportEnum IMPORT_BAZ] == [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:1], @"");
    
    AssertEqualObjects(@"324", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:1], @"");
    AssertEqualObjects(@"325", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:1], @"");
    
    // -----------------------------------------------------------------
    
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultInt32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultInt64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultUint32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultUint64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultSint32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultSint64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultFixed32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultFixed64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultSfixed32Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultSfixed64Extension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultFloatExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultDoubleExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultBoolExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultStringExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
    
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
    
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
    AssertTrue([message hasExtension:[UnittestProtoRoot defaultCordExtension]], @"");
    
    AssertTrue(401 == [[message getExtension:[UnittestProtoRoot defaultInt32Extension]] intValue], @"");
    AssertTrue(402L == [[message getExtension:[UnittestProtoRoot defaultInt64Extension]] intValue], @"");
    AssertTrue(403 == [[message getExtension:[UnittestProtoRoot defaultUint32Extension]] intValue], @"");
    AssertTrue(404L == [[message getExtension:[UnittestProtoRoot defaultUint64Extension]] intValue], @"");
    AssertTrue(405 == [[message getExtension:[UnittestProtoRoot defaultSint32Extension]] intValue], @"");
    AssertTrue(406L == [[message getExtension:[UnittestProtoRoot defaultSint64Extension]] intValue], @"");
    AssertTrue(407 == [[message getExtension:[UnittestProtoRoot defaultFixed32Extension]] intValue], @"");
    AssertTrue(408L == [[message getExtension:[UnittestProtoRoot defaultFixed64Extension]] intValue], @"");
    AssertTrue(409 == [[message getExtension:[UnittestProtoRoot defaultSfixed32Extension]] intValue], @"");
    AssertTrue(410L == [[message getExtension:[UnittestProtoRoot defaultSfixed64Extension]] intValue], @"");
    AssertTrue(411.0 == [[message getExtension:[UnittestProtoRoot defaultFloatExtension]] floatValue], @"");
    AssertTrue(412.0 == [[message getExtension:[UnittestProtoRoot defaultDoubleExtension]] doubleValue], @"");
    AssertTrue(false == [[message getExtension:[UnittestProtoRoot defaultBoolExtension]] boolValue], @"");
    AssertEqualObjects(@"415", [message getExtension:[UnittestProtoRoot defaultStringExtension]], @"");
    AssertEqualObjects([TestUtilities toData:@"416"], [message getExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
    
    AssertTrue([TestAllTypes_NestedEnum FOO] == [message getExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
    AssertTrue([ForeignEnum FOREIGN_FOO] == [message getExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
    AssertTrue([ImportEnum IMPORT_FOO] == [message getExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
    
    AssertEqualObjects(@"424", [message getExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
    AssertEqualObjects(@"425", [message getExtension:[UnittestProtoRoot defaultCordExtension]], @"");
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
    
    AssertTrue(message.hasOptionalInt32, @"");
    AssertTrue(message.hasOptionalInt64, @"");
    AssertTrue(message.hasOptionalUint32, @"");
    AssertTrue(message.hasOptionalUint64, @"");
    AssertTrue(message.hasOptionalSint32, @"");
    AssertTrue(message.hasOptionalSint64, @"");
    AssertTrue(message.hasOptionalFixed32, @"");
    AssertTrue(message.hasOptionalFixed64, @"");
    AssertTrue(message.hasOptionalSfixed32, @"");
    AssertTrue(message.hasOptionalSfixed64, @"");
    AssertTrue(message.hasOptionalFloat, @"");
    AssertTrue(message.hasOptionalDouble, @"");
    AssertTrue(message.hasOptionalBool, @"");
    AssertTrue(message.hasOptionalString, @"");
    AssertTrue(message.hasOptionalBytes, @"");
    
    AssertTrue(message.hasOptionalGroup, @"");
    AssertTrue(message.hasOptionalNestedMessage, @"");
    AssertTrue(message.hasOptionalForeignMessage, @"");
    AssertTrue(message.hasOptionalImportMessage, @"");
    
    AssertTrue(message.optionalGroup.hasA, @"");
    AssertTrue(message.optionalNestedMessage.hasBb, @"");
    AssertTrue(message.optionalForeignMessage.hasC, @"");
    AssertTrue(message.optionalImportMessage.hasD, @"");
    
    AssertTrue(message.hasOptionalNestedEnum, @"");
    AssertTrue(message.hasOptionalForeignEnum, @"");
    AssertTrue(message.hasOptionalImportEnum, @"");
    
    AssertTrue(message.hasOptionalStringPiece, @"");
    AssertTrue(message.hasOptionalCord, @"");
    
    AssertTrue(101 == message.optionalInt32, @"");
    AssertTrue(102 == message.optionalInt64, @"");
    AssertTrue(103 == message.optionalUint32, @"");
    AssertTrue(104 == message.optionalUint64, @"");
    AssertTrue(105 == message.optionalSint32, @"");
    AssertTrue(106 == message.optionalSint64, @"");
    AssertTrue(107 == message.optionalFixed32, @"");
    AssertTrue(108 == message.optionalFixed64, @"");
    AssertTrue(109 == message.optionalSfixed32, @"");
    AssertTrue(110 == message.optionalSfixed64, @"");
    STAssertEqualsWithAccuracy(111, message.optionalFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(112, message.optionalDouble, 0.1, @"");
    AssertTrue(true == message.optionalBool, @"");
    AssertEqualObjects(@"115", message.optionalString, @"");
    AssertEqualObjects([TestUtilities toData:@"116"], message.optionalBytes, @"");
    
    AssertTrue(117 == message.optionalGroup.a, @"");
    AssertTrue(118 == message.optionalNestedMessage.bb, @"");
    AssertTrue(119 == message.optionalForeignMessage.c, @"");
    AssertTrue(120 == message.optionalImportMessage.d, @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAZ] == message.optionalNestedEnum, @"");
    AssertTrue([ForeignEnum FOREIGN_BAZ] == message.optionalForeignEnum, @"");
    AssertTrue([ImportEnum IMPORT_BAZ] == message.optionalImportEnum, @"");
    
    AssertEqualObjects(@"124", message.optionalStringPiece, @"");
    AssertEqualObjects(@"125", message.optionalCord, @"");
    
    // -----------------------------------------------------------------
    
    AssertTrue(2 == message.repeatedInt32List.count, @"");
    AssertTrue(2 == message.repeatedInt64List.count, @"");
    AssertTrue(2 == message.repeatedUint32List.count, @"");
    AssertTrue(2 == message.repeatedUint64List.count, @"");
    AssertTrue(2 == message.repeatedSint32List.count, @"");
    AssertTrue(2 == message.repeatedSint64List.count, @"");
    AssertTrue(2 == message.repeatedFixed32List.count, @"");
    AssertTrue(2 == message.repeatedFixed64List.count, @"");
    AssertTrue(2 == message.repeatedSfixed32List.count, @"");
    AssertTrue(2 == message.repeatedSfixed64List.count, @"");
    AssertTrue(2 == message.repeatedFloatList.count, @"");
    AssertTrue(2 == message.repeatedDoubleList.count, @"");
    AssertTrue(2 == message.repeatedBoolList.count, @"");
    AssertTrue(2 == message.repeatedStringList.count, @"");
    AssertTrue(2 == message.repeatedBytesList.count, @"");
    
    AssertTrue(2 == message.repeatedGroupList.count, @"");
    AssertTrue(2 == message.repeatedNestedMessageList.count, @"");
    AssertTrue(2 == message.repeatedForeignMessageList.count, @"");
    AssertTrue(2 == message.repeatedImportMessageList.count, @"");
    AssertTrue(2 == message.repeatedNestedEnumList.count, @"");
    AssertTrue(2 == message.repeatedForeignEnumList.count, @"");
    AssertTrue(2 == message.repeatedImportEnumList.count, @"");
    
    AssertTrue(2 == message.repeatedStringPieceList.count, @"");
    AssertTrue(2 == message.repeatedCordList.count, @"");
    
    AssertTrue(201 == [message repeatedInt32AtIndex:0], @"");
    AssertTrue(202 == [message repeatedInt64AtIndex:0], @"");
    AssertTrue(203 == [message repeatedUint32AtIndex:0], @"");
    AssertTrue(204 == [message repeatedUint64AtIndex:0], @"");
    AssertTrue(205 == [message repeatedSint32AtIndex:0], @"");
    AssertTrue(206 == [message repeatedSint64AtIndex:0], @"");
    AssertTrue(207 == [message repeatedFixed32AtIndex:0], @"");
    AssertTrue(208 == [message repeatedFixed64AtIndex:0], @"");
    AssertTrue(209 == [message repeatedSfixed32AtIndex:0], @"");
    AssertTrue(210 == [message repeatedSfixed64AtIndex:0], @"");
    STAssertEqualsWithAccuracy(211, [message repeatedFloatAtIndex:0], 0.1, @"");
    STAssertEqualsWithAccuracy(212, [message repeatedDoubleAtIndex:0], 0.1, @"");
    AssertTrue(true == [message repeatedBoolAtIndex:0], @"");
    AssertEqualObjects(@"215", [message repeatedStringAtIndex:0], @"");
    AssertEqualObjects([TestUtilities toData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    AssertTrue(217 == [message repeatedGroupAtIndex:0].a, @"");
    AssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    AssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    AssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
    AssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
    AssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
    
    AssertEqualObjects(@"224", [message repeatedStringPieceAtIndex:0], @"");
    AssertEqualObjects(@"225", [message repeatedCordAtIndex:0], @"");
    
    AssertTrue(301 == [message repeatedInt32AtIndex:1], @"");
    AssertTrue(302 == [message repeatedInt64AtIndex:1], @"");
    AssertTrue(303 == [message repeatedUint32AtIndex:1], @"");
    AssertTrue(304 == [message repeatedUint64AtIndex:1], @"");
    AssertTrue(305 == [message repeatedSint32AtIndex:1], @"");
    AssertTrue(306 == [message repeatedSint64AtIndex:1], @"");
    AssertTrue(307 == [message repeatedFixed32AtIndex:1], @"");
    AssertTrue(308 == [message repeatedFixed64AtIndex:1], @"");
    AssertTrue(309 == [message repeatedSfixed32AtIndex:1], @"");
    AssertTrue(310 == [message repeatedSfixed64AtIndex:1], @"");
    STAssertEqualsWithAccuracy(311, [message repeatedFloatAtIndex:1], 0.1, @"");
    STAssertEqualsWithAccuracy(312, [message repeatedDoubleAtIndex:1], 0.1, @"");
    AssertTrue(false == [message repeatedBoolAtIndex:1], @"");
    AssertEqualObjects(@"315", [message repeatedStringAtIndex:1], @"");
    AssertEqualObjects([TestUtilities toData:@"316"], [message repeatedBytesAtIndex:1], @"");
    
    AssertTrue(317 == [message repeatedGroupAtIndex:1].a, @"");
    AssertTrue(318 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    AssertTrue(319 == [message repeatedForeignMessageAtIndex:1].c, @"");
    AssertTrue(320 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAZ] == [message repeatedNestedEnumAtIndex:1], @"");
    AssertTrue([ForeignEnum FOREIGN_BAZ] == [message repeatedForeignEnumAtIndex:1], @"");
    AssertTrue([ImportEnum IMPORT_BAZ] == [message repeatedImportEnumAtIndex:1], @"");
    
    AssertEqualObjects(@"324", [message repeatedStringPieceAtIndex:1], @"");
    AssertEqualObjects(@"325", [message repeatedCordAtIndex:1], @"");
    
    // -----------------------------------------------------------------
    
    AssertTrue(message.hasDefaultInt32, @"");
    AssertTrue(message.hasDefaultInt64, @"");
    AssertTrue(message.hasDefaultUint32, @"");
    AssertTrue(message.hasDefaultUint64, @"");
    AssertTrue(message.hasDefaultSint32, @"");
    AssertTrue(message.hasDefaultSint64, @"");
    AssertTrue(message.hasDefaultFixed32, @"");
    AssertTrue(message.hasDefaultFixed64, @"");
    AssertTrue(message.hasDefaultSfixed32, @"");
    AssertTrue(message.hasDefaultSfixed64, @"");
    AssertTrue(message.hasDefaultFloat, @"");
    AssertTrue(message.hasDefaultDouble, @"");
    AssertTrue(message.hasDefaultBool, @"");
    AssertTrue(message.hasDefaultString, @"");
    AssertTrue(message.hasDefaultBytes, @"");
    
    AssertTrue(message.hasDefaultNestedEnum, @"");
    AssertTrue(message.hasDefaultForeignEnum, @"");
    AssertTrue(message.hasDefaultImportEnum, @"");
    
    AssertTrue(message.hasDefaultStringPiece, @"");
    AssertTrue(message.hasDefaultCord, @"");
    
    AssertTrue(401 == message.defaultInt32, @"");
    AssertTrue(402 == message.defaultInt64, @"");
    AssertTrue(403 == message.defaultUint32, @"");
    AssertTrue(404 == message.defaultUint64, @"");
    AssertTrue(405 == message.defaultSint32, @"");
    AssertTrue(406 == message.defaultSint64, @"");
    AssertTrue(407 == message.defaultFixed32, @"");
    AssertTrue(408 == message.defaultFixed64, @"");
    AssertTrue(409 == message.defaultSfixed32, @"");
    AssertTrue(410 == message.defaultSfixed64, @"");
    STAssertEqualsWithAccuracy(411, message.defaultFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(412, message.defaultDouble, 0.1, @"");
    AssertTrue(false == message.defaultBool, @"");
    AssertEqualObjects(@"415", message.defaultString, @"");
    AssertEqualObjects([TestUtilities toData:@"416"], message.defaultBytes, @"");
    
    AssertTrue([TestAllTypes_NestedEnum FOO] == message.defaultNestedEnum, @"");
    AssertTrue([ForeignEnum FOREIGN_FOO] == message.defaultForeignEnum, @"");
    AssertTrue([ImportEnum IMPORT_FOO] == message.defaultImportEnum, @"");
    
    AssertEqualObjects(@"424", message.defaultStringPiece, @"");
    AssertEqualObjects(@"425", message.defaultCord, @"");
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
    
    [message setOptionalGroup:[[[TestAllTypes_OptionalGroup builder] setA:117] build]];
    [message setOptionalNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:118] build]];
    [message setOptionalForeignMessage:[[[ForeignMessage builder] setC:119] build]];
    [message setOptionalImportMessage:[[[ImportMessage builder] setD:120] build]];
    
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
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup builder] setA:217] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:218] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage builder] setC:219] build]];
    [message addRepeatedImportMessage:[[[ImportMessage builder] setD:220] build]];
    
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
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup builder] setA:317] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:318] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage builder] setC:319] build]];
    [message addRepeatedImportMessage:[[[ImportMessage builder] setD:320] build]];
    
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
                    value:[[[OptionalGroup_extension builder] setA:117] build]];
    [message setExtension:[UnittestProtoRoot optionalNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:118] build]];
    [message setExtension:[UnittestProtoRoot optionalForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:119] build]];
    [message setExtension:[UnittestProtoRoot optionalImportMessageExtension]
                    value:[[[ImportMessage builder] setD:120] build]];
    
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
                    value:[[[RepeatedGroup_extension builder] setA:217] build]];
    [message addExtension:[UnittestProtoRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:218] build]];
    [message addExtension:[UnittestProtoRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:219] build]];
    [message addExtension:[UnittestProtoRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage builder] setD:220] build]];
    
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
                    value:[[[RepeatedGroup_extension builder] setA:317] build]];
    [message addExtension:[UnittestProtoRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:318] build]];
    [message addExtension:[UnittestProtoRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:319] build]];
    [message addExtension:[UnittestProtoRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage builder] setD:320] build]];
    
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
    TestAllTypes_Builder* builder = [TestAllTypes builder];
    [self setAllFields:builder];
    return [builder build];
}


+ (TestAllExtensions*) allExtensionsSet {
    TestAllExtensions_Builder* builder = [TestAllExtensions builder];
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
    AssertFalse(message.hasOptionalInt32, @"");
    AssertFalse(message.hasOptionalInt64, @"");
    AssertFalse(message.hasOptionalUint32, @"");
    AssertFalse(message.hasOptionalUint64, @"");
    AssertFalse(message.hasOptionalSint32, @"");
    AssertFalse(message.hasOptionalSint64, @"");
    AssertFalse(message.hasOptionalFixed32, @"");
    AssertFalse(message.hasOptionalFixed64, @"");
    AssertFalse(message.hasOptionalSfixed32, @"");
    AssertFalse(message.hasOptionalSfixed64, @"");
    AssertFalse(message.hasOptionalFloat, @"");
    AssertFalse(message.hasOptionalDouble, @"");
    AssertFalse(message.hasOptionalBool, @"");
    AssertFalse(message.hasOptionalString, @"");
    AssertFalse(message.hasOptionalBytes, @"");
    
    AssertFalse(message.hasOptionalGroup, @"");
    AssertFalse(message.hasOptionalNestedMessage, @"");
    AssertFalse(message.hasOptionalForeignMessage, @"");
    AssertFalse(message.hasOptionalImportMessage, @"");
    
    AssertFalse(message.hasOptionalNestedEnum, @"");
    AssertFalse(message.hasOptionalForeignEnum, @"");
    AssertFalse(message.hasOptionalImportEnum, @"");
    
    AssertFalse(message.hasOptionalStringPiece, @"");
    AssertFalse(message.hasOptionalCord, @"");
    
    // Optional fields without defaults are set to zero or something like it.
    AssertTrue(0 == message.optionalInt32, @"");
    AssertTrue(0 == message.optionalInt64, @"");
    AssertTrue(0 == message.optionalUint32, @"");
    AssertTrue(0 == message.optionalUint64, @"");
    AssertTrue(0 == message.optionalSint32, @"");
    AssertTrue(0 == message.optionalSint64, @"");
    AssertTrue(0 == message.optionalFixed32, @"");
    AssertTrue(0 == message.optionalFixed64, @"");
    AssertTrue(0 == message.optionalSfixed32, @"");
    AssertTrue(0 == message.optionalSfixed64, @"");
    AssertTrue(0 == message.optionalFloat, @"");
    AssertTrue(0 == message.optionalDouble, @"");
    AssertTrue(false == message.optionalBool, @"");
    AssertEqualObjects(@"", message.optionalString, @"");
    AssertEqualObjects([NSData data], message.optionalBytes, @"");
    
    // Embedded messages should also be clear.
    AssertFalse(message.optionalGroup.hasA, @"");
    AssertFalse(message.optionalNestedMessage.hasBb, @"");
    AssertFalse(message.optionalForeignMessage.hasC, @"");
    AssertFalse(message.optionalImportMessage.hasD, @"");
    
    AssertTrue(0 == message.optionalGroup.a, @"");
    AssertTrue(0 == message.optionalNestedMessage.bb, @"");
    AssertTrue(0 == message.optionalForeignMessage.c, @"");
    AssertTrue(0 == message.optionalImportMessage.d, @"");
    
    // Enums without defaults are set to the first value in the enum.
    AssertTrue([TestAllTypes_NestedEnum FOO] == message.optionalNestedEnum, @"");
    AssertTrue([ForeignEnum FOREIGN_FOO] == message.optionalForeignEnum, @"");
    AssertTrue([ImportEnum IMPORT_FOO] == message.optionalImportEnum, @"");
    
    AssertEqualObjects(@"", message.optionalStringPiece, @"");
    AssertEqualObjects(@"", message.optionalCord, @"");
    
    // Repeated fields are empty.
    AssertTrue(0 == message.repeatedInt32List.count, @"");
    AssertTrue(0 == message.repeatedInt64List.count, @"");
    AssertTrue(0 == message.repeatedUint32List.count, @"");
    AssertTrue(0 == message.repeatedUint64List.count, @"");
    AssertTrue(0 == message.repeatedSint32List.count, @"");
    AssertTrue(0 == message.repeatedSint64List.count, @"");
    AssertTrue(0 == message.repeatedFixed32List.count, @"");
    AssertTrue(0 == message.repeatedFixed64List.count, @"");
    AssertTrue(0 == message.repeatedSfixed32List.count, @"");
    AssertTrue(0 == message.repeatedSfixed64List.count, @"");
    AssertTrue(0 == message.repeatedFloatList.count, @"");
    AssertTrue(0 == message.repeatedDoubleList.count, @"");
    AssertTrue(0 == message.repeatedBoolList.count, @"");
    AssertTrue(0 == message.repeatedStringList.count, @"");
    AssertTrue(0 == message.repeatedBytesList.count, @"");
    
    AssertTrue(0 == message.repeatedGroupList.count, @"");
    AssertTrue(0 == message.repeatedNestedMessageList.count, @"");
    AssertTrue(0 == message.repeatedForeignMessageList.count, @"");
    AssertTrue(0 == message.repeatedImportMessageList.count, @"");
    AssertTrue(0 == message.repeatedNestedEnumList.count, @"");
    AssertTrue(0 == message.repeatedForeignEnumList.count, @"");
    AssertTrue(0 == message.repeatedImportEnumList.count, @"");
    
    AssertTrue(0 == message.repeatedStringPieceList.count, @"");
    AssertTrue(0 == message.repeatedCordList.count, @"");
    
    // hasBlah() should also be false for all default fields.
    AssertFalse(message.hasDefaultInt32, @"");
    AssertFalse(message.hasDefaultInt64, @"");
    AssertFalse(message.hasDefaultUint32, @"");
    AssertFalse(message.hasDefaultUint64, @"");
    AssertFalse(message.hasDefaultSint32, @"");
    AssertFalse(message.hasDefaultSint64, @"");
    AssertFalse(message.hasDefaultFixed32, @"");
    AssertFalse(message.hasDefaultFixed64, @"");
    AssertFalse(message.hasDefaultSfixed32, @"");
    AssertFalse(message.hasDefaultSfixed64, @"");
    AssertFalse(message.hasDefaultFloat, @"");
    AssertFalse(message.hasDefaultDouble, @"");
    AssertFalse(message.hasDefaultBool, @"");
    AssertFalse(message.hasDefaultString, @"");
    AssertFalse(message.hasDefaultBytes, @"");
    
    AssertFalse(message.hasDefaultNestedEnum, @"");
    AssertFalse(message.hasDefaultForeignEnum, @"");
    AssertFalse(message.hasDefaultImportEnum, @"");
    
    AssertFalse(message.hasDefaultStringPiece, @"");
    AssertFalse(message.hasDefaultCord, @"");
    
    // Fields with defaults have their default values (duh).
    AssertTrue( 41 == message.defaultInt32, @"");
    AssertTrue( 42 == message.defaultInt64, @"");
    AssertTrue( 43 == message.defaultUint32, @"");
    AssertTrue( 44 == message.defaultUint64, @"");
    AssertTrue(-45 == message.defaultSint32, @"");
    AssertTrue( 46 == message.defaultSint64, @"");
    AssertTrue( 47 == message.defaultFixed32, @"");
    AssertTrue( 48 == message.defaultFixed64, @"");
    AssertTrue( 49 == message.defaultSfixed32, @"");
    AssertTrue(-50 == message.defaultSfixed64, @"");
    STAssertEqualsWithAccuracy(51.5, message.defaultFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(52e3, message.defaultDouble, 0.1, @"");
    AssertTrue(true == message.defaultBool, @"");
    AssertEqualObjects(@"hello", message.defaultString, @"");
    AssertEqualObjects([TestUtilities toData:@"world"], message.defaultBytes, @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAR] == message.defaultNestedEnum, @"");
    AssertTrue([ForeignEnum FOREIGN_BAR] == message.defaultForeignEnum, @"");
    AssertTrue([ImportEnum IMPORT_BAR] == message.defaultImportEnum, @"");
    
    AssertEqualObjects(@"abc", message.defaultStringPiece, @"");
    AssertEqualObjects(@"123", message.defaultCord, @"");
}


+ (void) assertClear:(TestAllTypes*) message {
    return [[[[TestUtilities alloc] init] autorelease] assertClear:message];
}

/**
 * Modify the repeated fields of {@code message} to contain the values
 * expected by {@code assertRepeatedFieldsModified()}.
 */
- (void) modifyRepeatedFields:(TestAllTypes_Builder*) message {
    [message replaceRepeatedInt32AtIndex:1 with:501];
    [message replaceRepeatedInt64AtIndex:1 with:502];
    [message replaceRepeatedUint32AtIndex:1 with:503];
    [message replaceRepeatedUint64AtIndex:1 with:504];
    [message replaceRepeatedSint32AtIndex:1 with:505];
    [message replaceRepeatedSint64AtIndex:1 with:506];
    [message replaceRepeatedFixed32AtIndex:1 with:507];
    [message replaceRepeatedFixed64AtIndex:1 with:508];
    [message replaceRepeatedSfixed32AtIndex:1 with:509];
    [message replaceRepeatedSfixed64AtIndex:1 with:510];
    [message replaceRepeatedFloatAtIndex:1 with:511];
    [message replaceRepeatedDoubleAtIndex:1 with:512];
    [message replaceRepeatedBoolAtIndex:1 with:true];
    [message replaceRepeatedStringAtIndex:1 with:@"515"];
    [message replaceRepeatedBytesAtIndex:1 with:[TestUtilities toData:@"516"]];
    
    [message replaceRepeatedGroupAtIndex:1 with:[[[TestAllTypes_RepeatedGroup builder] setA:517] build]];
    [message replaceRepeatedNestedMessageAtIndex:1 with:[[[TestAllTypes_NestedMessage builder] setBb:518] build]];
    [message replaceRepeatedForeignMessageAtIndex:1 with:[[[ForeignMessage builder] setC:519] build]];
    [message replaceRepeatedImportMessageAtIndex:1 with:[[[ImportMessage builder] setD:520] build]];
    
    [message replaceRepeatedNestedEnumAtIndex:1 with:[TestAllTypes_NestedEnum FOO]];
    [message replaceRepeatedForeignEnumAtIndex:1 with:[ForeignEnum FOREIGN_FOO]];
    [message replaceRepeatedImportEnumAtIndex:1 with:[ImportEnum IMPORT_FOO]];
    
    [message replaceRepeatedStringPieceAtIndex:1 with:@"524"];
    [message replaceRepeatedCordAtIndex:1 with:@"525"];
}


+ (void) modifyRepeatedFields:(TestAllTypes_Builder*) message {
    [[[[TestUtilities alloc] init] autorelease] modifyRepeatedFields:message];
}

/**
 * Assert (using {@code junit.framework.Assert}} that all fields of
 * {@code message} are set to the values assigned by {@code setAllFields}
 * followed by {@code modifyRepeatedFields}.
 */
- (void) assertRepeatedFieldsModified:(TestAllTypes*) message {
    // ModifyRepeatedFields only sets the second repeated element of each
    // field.  In addition to verifying this, we also verify that the first
    // element and size were *not* modified.
    AssertTrue(2 == message.repeatedInt32List.count, @"");
    AssertTrue(2 == message.repeatedInt64List.count, @"");
    AssertTrue(2 == message.repeatedUint32List.count, @"");
    AssertTrue(2 == message.repeatedUint64List.count, @"");
    AssertTrue(2 == message.repeatedSint32List.count, @"");
    AssertTrue(2 == message.repeatedSint64List.count, @"");
    AssertTrue(2 == message.repeatedFixed32List.count, @"");
    AssertTrue(2 == message.repeatedFixed64List.count, @"");
    AssertTrue(2 == message.repeatedSfixed32List.count, @"");
    AssertTrue(2 == message.repeatedSfixed64List.count, @"");
    AssertTrue(2 == message.repeatedFloatList.count, @"");
    AssertTrue(2 == message.repeatedDoubleList.count, @"");
    AssertTrue(2 == message.repeatedBoolList.count, @"");
    AssertTrue(2 == message.repeatedStringList.count, @"");
    AssertTrue(2 == message.repeatedBytesList.count, @"");
    
    AssertTrue(2 == message.repeatedGroupList.count, @"");
    AssertTrue(2 == message.repeatedNestedMessageList.count, @"");
    AssertTrue(2 == message.repeatedForeignMessageList.count, @"");
    AssertTrue(2 == message.repeatedImportMessageList.count, @"");
    AssertTrue(2 == message.repeatedNestedEnumList.count, @"");
    AssertTrue(2 == message.repeatedForeignEnumList.count, @"");
    AssertTrue(2 == message.repeatedImportEnumList.count, @"");
    
    AssertTrue(2 == message.repeatedStringPieceList.count, @"");
    AssertTrue(2 == message.repeatedCordList.count, @"");
    
    AssertTrue(201 == [message repeatedInt32AtIndex:0], @"");
    AssertTrue(202L == [message repeatedInt64AtIndex:0], @"");
    AssertTrue(203 == [message repeatedUint32AtIndex:0], @"");
    AssertTrue(204L == [message repeatedUint64AtIndex:0], @"");
    AssertTrue(205 == [message repeatedSint32AtIndex:0], @"");
    AssertTrue(206L == [message repeatedSint64AtIndex:0], @"");
    AssertTrue(207 == [message repeatedFixed32AtIndex:0], @"");
    AssertTrue(208L == [message repeatedFixed64AtIndex:0], @"");
    AssertTrue(209 == [message repeatedSfixed32AtIndex:0], @"");
    AssertTrue(210L == [message repeatedSfixed64AtIndex:0], @"");
    AssertTrue(211.0 == [message repeatedFloatAtIndex:0], @"");
    AssertTrue(212.0 == [message repeatedDoubleAtIndex:0], @"");
    AssertTrue(true == [message repeatedBoolAtIndex:0], @"");
    AssertEqualObjects(@"215", [message repeatedStringAtIndex:0], @"");
    AssertEqualObjects([TestUtilities toData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    AssertTrue(217 == [message repeatedGroupAtIndex:0].a, @"");
    AssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    AssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    AssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    AssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
    AssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
    AssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
    
    AssertEqualObjects(@"224", [message repeatedStringPieceAtIndex:0], @"");
    AssertEqualObjects(@"225", [message repeatedCordAtIndex:0], @"");
    
    // Actually verify the second (modified) elements now.
    AssertTrue(501 == [message repeatedInt32AtIndex:1], @"");
    AssertTrue(502L == [message repeatedInt64AtIndex:1], @"");
    AssertTrue(503 == [message repeatedUint32AtIndex:1], @"");
    AssertTrue(504L == [message repeatedUint64AtIndex:1], @"");
    AssertTrue(505 == [message repeatedSint32AtIndex:1], @"");
    AssertTrue(506L == [message repeatedSint64AtIndex:1], @"");
    AssertTrue(507 == [message repeatedFixed32AtIndex:1], @"");
    AssertTrue(508L == [message repeatedFixed64AtIndex:1], @"");
    AssertTrue(509 == [message repeatedSfixed32AtIndex:1], @"");
    AssertTrue(510L == [message repeatedSfixed64AtIndex:1], @"");
    AssertTrue(511.0 == [message repeatedFloatAtIndex:1], @"");
    AssertTrue(512.0 == [message repeatedDoubleAtIndex:1], @"");
    AssertTrue(true == [message repeatedBoolAtIndex:1], @"");
    AssertEqualObjects(@"515", [message repeatedStringAtIndex:1], @"");
    AssertEqualObjects([TestUtilities toData:@"516"], [message repeatedBytesAtIndex:1], @"");
    
    AssertTrue(517 == [message repeatedGroupAtIndex:1].a, @"");
    AssertTrue(518 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    AssertTrue(519 == [message repeatedForeignMessageAtIndex:1].c, @"");
    AssertTrue(520 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    AssertTrue([TestAllTypes_NestedEnum FOO] == [message repeatedNestedEnumAtIndex:1], @"");
    AssertTrue([ForeignEnum FOREIGN_FOO] == [message repeatedForeignEnumAtIndex:1], @"");
    AssertTrue([ImportEnum IMPORT_FOO] == [message repeatedImportEnumAtIndex:1], @"");
    
    AssertEqualObjects(@"524", [message repeatedStringPieceAtIndex:1], @"");
    AssertEqualObjects(@"525", [message repeatedCordAtIndex:1], @"");
}


+ (void) assertRepeatedFieldsModified:(TestAllTypes*) message {
    [[[[TestUtilities alloc] init] autorelease] assertRepeatedFieldsModified:message];
}

#if 0


/**
 * Set every field of {@code message} to the values expected by
 * {@code assertAllFieldsSet()}.
 */


// -------------------------------------------------------------------






// -------------------------------------------------------------------



// ===================================================================
// Like above, but for extensions

// Java gets confused with things like assertEquals(int, Integer):  it can't
// decide whether to call assertEquals(int, int) or assertEquals(Object,
// Object).  So we define these methods to help it.
private static void AssertTrue(int a, int b) {
    AssertTrue(a, b);
}
private static void AssertTrue(long a, long b) {
    AssertTrue(a, b);
}
private static void AssertTrue(float a, float b) {
    AssertTrue(a, b, 0.0);
}
private static void AssertTrue(double a, double b) {
    AssertTrue(a, b, 0.0);
}
private static void AssertTrue(boolean a, boolean b) {
    AssertTrue(a, b);
}
private static void AssertTrue(String a, String b) {
    AssertTrue(a, b);
}
private static void AssertTrue(ByteString a, ByteString b) {
    AssertTrue(a, b);
}
private static void AssertTrue(TestAllTypes_NestedEnum a,
                               TestAllTypes_NestedEnum b) {
    AssertTrue(a, b);
}
private static void AssertTrue(ForeignEnum a, ForeignEnum b) {
    AssertTrue(a, b);
}
private static void AssertTrue(ImportEnum a, ImportEnum b) {
    AssertTrue(a, b);
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
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalInt64Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalUint32Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalUint64Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalSint32Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalSint64Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalFixed32Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalFixed64Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalSfixed32Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalSfixed64Extension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalFloatExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalDoubleExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalBoolExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalStringExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
        
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalGroupExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalNestedMessageExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalForeignMessageExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalImportMessageExtension]], @"");
        
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
        
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
        AssertFalse([message hasExtension:[UnittestProtoRoot optionalCordExtension]], @"");
        
        // Optional fields without defaults are set to zero or something like it.
        AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalInt32Extension]   ));
                       AssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalInt64Extension]   ));
                                       AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalUint32Extension]  ));
                                                      AssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalUint64Extension]  ));
                                                                      AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalSint32Extension]  ));
                                                                                     AssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalSint64Extension]  ));
                                                                                                     AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalFixed32Extension] ));
                                                                                                                    AssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalFixed64Extension] ));
                                                                                                                                    AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalSfixed32Extension]));
                                                                                                                                                   AssertTrue(0L, [message getExtension:[UnittestProtoRoot optionalSfixed64Extension]));
                                                                                                                                                                   AssertTrue(0F, [message getExtension:[UnittestProtoRoot optionalFloatExtension]   ));
                                                                                                                                                                                   AssertTrue(0D, [message getExtension:[UnittestProtoRoot optionalDoubleExtension]  ));
                                                                                                                                                                                                   AssertTrue(false, [message getExtension:[UnittestProtoRoot optionalBoolExtension]    ));
                                                                                                                                                                                                                      AssertTrue("", [message getExtension:[UnittestProtoRoot optionalStringExtension]  ));
                                                                                                                                                                                                                                      AssertTrue(ByteString.EMPTY, [message getExtension:[UnittestProtoRoot optionalBytesExtension]));
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    // Embedded messages should also be clear.
                                                                                                                                                                                                                                                                    AssertFalse([message getExtension:[UnittestProtoRoot optionalGroupExtension]         ).hasA());
                                                                                                                                                                                                                                                                                   AssertFalse([message getExtension:[UnittestProtoRoot optionalNestedMessageExtension] ).hasBb());
                                                                                                                                                                                                                                                                                                  AssertFalse([message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]).hasC());
                                                                                                                                                                                                                                                                                                                 AssertFalse([message getExtension:[UnittestProtoRoot optionalImportMessageExtension] ).hasD());
                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalGroupExtension]         .a);
                                                                                                                                                                                                                                                                                                                                               AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalNestedMessageExtension] ).bb);
                                                                                                                                                                                                                                                                                                                                                              AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]).c);
                                                                                                                                                                                                                                                                                                                                                                             AssertTrue(0, [message getExtension:[UnittestProtoRoot optionalImportMessageExtension] ).d);
                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                            // Enums without defaults are set to the first value in the enum.
                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue([TestAllTypes_NestedEnum FOO],
                                                                                                                                                                                                                                                                                                                                                                                                       [message getExtension:[UnittestProtoRoot optionalNestedEnumExtension] ));
                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue([ForeignEnum FOREIGN_FOO],
                                                                                                                                                                                                                                                                                                                                                                                                                   [message getExtension:[UnittestProtoRoot optionalForeignEnumExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                    AssertTrue([ImportEnum IMPORT_FOO],
                                                                                                                                                                                                                                                                                                                                                                                                                               [message getExtension:[UnittestProtoRoot optionalImportEnumExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                AssertTrue("", [message getExtension:[UnittestProtoRoot optionalStringPieceExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                AssertTrue("", [message getExtension:[UnittestProtoRoot optionalCordExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                // Repeated fields are empty.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]    ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]         ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]    ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]    ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue(0, [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        // hasBlah() should also be false for all default fields.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultInt32Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultInt64Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultUint32Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultUint64Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultSint32Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultSint64Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultFixed32Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultFixed64Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultSfixed32Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultSfixed64Extension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultFloatExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultDoubleExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultBoolExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultStringExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertFalse([message hasExtension:[UnittestProtoRoot defaultCordExtension]], @"");
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        // Fields with defaults have their default values (duh).
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue( 41, [message getExtension:[UnittestProtoRoot defaultInt32Extension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue( 42L, [message getExtension:[UnittestProtoRoot defaultInt64Extension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue( 43, [message getExtension:[UnittestProtoRoot defaultUint32Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue( 44L, [message getExtension:[UnittestProtoRoot defaultUint64Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AssertTrue(-45, [message getExtension:[UnittestProtoRoot defaultSint32Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue( 46L, [message getExtension:[UnittestProtoRoot defaultSint64Extension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AssertTrue( 47, [message getExtension:[UnittestProtoRoot defaultFixed32Extension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  AssertTrue( 48L, [message getExtension:[UnittestProtoRoot defaultFixed64Extension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    AssertTrue( 49, [message getExtension:[UnittestProtoRoot defaultSfixed32Extension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(-50L, [message getExtension:[UnittestProtoRoot defaultSfixed64Extension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue( 51.5F, [message getExtension:[UnittestProtoRoot defaultFloatExtension]   ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue( 52e3D, [message getExtension:[UnittestProtoRoot defaultDoubleExtension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue(true, [message getExtension:[UnittestProtoRoot defaultBoolExtension]    ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AssertTrue("hello", [message getExtension:[UnittestProtoRoot defaultStringExtension]  ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      AssertTrue(toData("world"), [message getExtension:[UnittestProtoRoot defaultBytesExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   AssertTrue([TestAllTypes_NestedEnum BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              [message getExtension:[UnittestProtoRoot defaultNestedEnumExtension] ));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue([ForeignEnum FOREIGN_BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          [message getExtension:[UnittestProtoRoot defaultForeignEnumExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue([ImportEnum IMPORT_BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [message getExtension:[UnittestProtoRoot defaultImportEnumExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue("abc", [message getExtension:[UnittestProtoRoot defaultStringPieceExtension]));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue("123", [message getExtension:[UnittestProtoRoot defaultCordExtension]));
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
            AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedInt32Extension]   ));
                           AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedInt64Extension]   ));
                                          AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedUint32Extension]  ));
                                                         AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedUint64Extension]  ));
                                                                        AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSint32Extension]  ));
                                                                                       AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSint64Extension]  ));
                                                                                                      AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFixed32Extension] ));
                                                                                                                     AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFixed64Extension] ));
                                                                                                                                    AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed32Extension]));
                                                                                                                                                   AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedSfixed64Extension]));
                                                                                                                                                                  AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedFloatExtension]   ));
                                                                                                                                                                                 AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedDoubleExtension]  ));
                                                                                                                                                                                                AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedBoolExtension]    ));
                                                                                                                                                                                                               AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedStringExtension]  ));
                                                                                                                                                                                                                              AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedBytesExtension]   ));
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedGroupExtension]         ));
                                                                                                                                                                                                                                                            AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedNestedMessageExtension] ));
                                                                                                                                                                                                                                                                           AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedForeignMessageExtension]));
                                                                                                                                                                                                                                                                                          AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedImportMessageExtension] ));
                                                                                                                                                                                                                                                                                                         AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedNestedEnumExtension]    ));
                                                                                                                                                                                                                                                                                                                        AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedForeignEnumExtension]   ));
                                                                                                                                                                                                                                                                                                                                       AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedImportEnumExtension]    ));
                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                      AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedStringPieceExtension]));
                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(2, [message getExtensionCount:[UnittestProtoRoot repeatedCordExtension]));
                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                    AssertTrue(201, [message getExtension:[UnittestProtoRoot repeatedInt32Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(202L, [message getExtension:[UnittestProtoRoot repeatedInt64Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue(203, [message getExtension:[UnittestProtoRoot repeatedUint32Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(204L, [message getExtension:[UnittestProtoRoot repeatedUint64Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue(205, [message getExtension:[UnittestProtoRoot repeatedSint32Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue(206L, [message getExtension:[UnittestProtoRoot repeatedSint64Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             AssertTrue(207, [message getExtension:[UnittestProtoRoot repeatedFixed32Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AssertTrue(208L, [message getExtension:[UnittestProtoRoot repeatedFixed64Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                AssertTrue(209, [message getExtension:[UnittestProtoRoot repeatedSfixed32Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AssertTrue(210L, [message getExtension:[UnittestProtoRoot repeatedSfixed64Extension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   AssertTrue(211F, [message getExtension:[UnittestProtoRoot repeatedFloatExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(212D, [message getExtension:[UnittestProtoRoot repeatedDoubleExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue(true, [message getExtension:[UnittestProtoRoot repeatedBoolExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue("215", [message getExtension:[UnittestProtoRoot repeatedStringExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue(toData("216"), [message getExtension:[UnittestProtoRoot repeatedBytesExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue(217, [message getExtension:[UnittestProtoRoot repeatedGroupExtension], 0.a);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(218, [message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension], 0).bb);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue(219, [message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension], 0).c);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue(220, [message getExtension:[UnittestProtoRoot repeatedImportMessageExtension], 0).d);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue([TestAllTypes_NestedEnum BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue([ForeignEnum FOREIGN_BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   AssertTrue([ImportEnum IMPORT_BAR],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue("224", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  AssertTrue("225", [message getExtension:[UnittestProtoRoot repeatedCordExtension], 0));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     // Actually verify the second (modified) elements now.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     AssertTrue(501, [message getExtension:[UnittestProtoRoot repeatedInt32Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      AssertTrue(502L, [message getExtension:[UnittestProtoRoot repeatedInt64Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(503, [message getExtension:[UnittestProtoRoot repeatedUint32Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue(504L, [message getExtension:[UnittestProtoRoot repeatedUint64Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue(505, [message getExtension:[UnittestProtoRoot repeatedSint32Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            AssertTrue(506L, [message getExtension:[UnittestProtoRoot repeatedSint64Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              AssertTrue(507, [message getExtension:[UnittestProtoRoot repeatedFixed32Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue(508L, [message getExtension:[UnittestProtoRoot repeatedFixed64Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AssertTrue(509, [message getExtension:[UnittestProtoRoot repeatedSfixed32Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  AssertTrue(510L, [message getExtension:[UnittestProtoRoot repeatedSfixed64Extension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    AssertTrue(511F, [message getExtension:[UnittestProtoRoot repeatedFloatExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      AssertTrue(512D, [message getExtension:[UnittestProtoRoot repeatedDoubleExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(true, [message getExtension:[UnittestProtoRoot repeatedBoolExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue("515", [message getExtension:[UnittestProtoRoot repeatedStringExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             AssertTrue(toData("516"), [message getExtension:[UnittestProtoRoot repeatedBytesExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(517, [message getExtension:[UnittestProtoRoot repeatedGroupExtension], 1].a);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        AssertTrue(518, [message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension], 1).bb);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         AssertTrue(519, [message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension], 1).c);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          AssertTrue(520, [message getExtension:[UnittestProtoRoot repeatedImportMessageExtension], 1).d);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           AssertTrue([TestAllTypes_NestedEnum FOO],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       AssertTrue([ForeignEnum FOREIGN_FOO],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   AssertTrue([ImportEnum IMPORT_FOO],
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               AssertTrue("524", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension], 1));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  AssertTrue("525", [message getExtension:[UnittestProtoRoot repeatedCordExtension], 1));
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
                    AssertTrue(1, file.getDependencies().size());
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
                        return extension.defaultInstance.builder();
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
                            AssertTrue(message.hasField(f("optional_int32"   )));
                            AssertTrue(message.hasField(f("optional_int64"   )));
                            AssertTrue(message.hasField(f("optional_uint32"  )));
                            AssertTrue(message.hasField(f("optional_uint64"  )));
                            AssertTrue(message.hasField(f("optional_sint32"  )));
                            AssertTrue(message.hasField(f("optional_sint64"  )));
                            AssertTrue(message.hasField(f("optional_fixed32" )));
                            AssertTrue(message.hasField(f("optional_fixed64" )));
                            AssertTrue(message.hasField(f("optional_sfixed32")));
                            AssertTrue(message.hasField(f("optional_sfixed64")));
                            AssertTrue(message.hasField(f("optional_float"   )));
                            AssertTrue(message.hasField(f("optional_double"  )));
                            AssertTrue(message.hasField(f("optional_bool"    )));
                            AssertTrue(message.hasField(f("optional_string"  )));
                            AssertTrue(message.hasField(f("optional_bytes"   )));
                            
                            AssertTrue(message.hasField(f("optionalgroup"           )));
                            AssertTrue(message.hasField(f("optional_nested_message" )));
                            AssertTrue(message.hasField(f("optional_foreign_message")));
                            AssertTrue(message.hasField(f("optional_import_message" )));
                            
                            AssertTrue(
                                       ((Message)message.getField(f("optionalgroup"))).hasField(groupA));
                            AssertTrue(
                                       ((Message)message.getField(f("optional_nested_message")))
                                       .hasField(nestedB));
                            AssertTrue(
                                       ((Message)message.getField(f("optional_foreign_message")))
                                       .hasField(foreignC));
                            AssertTrue(
                                       ((Message)message.getField(f("optional_import_message")))
                                       .hasField(importD));
                            
                            AssertTrue(message.hasField(f("optional_nested_enum" )));
                            AssertTrue(message.hasField(f("optional_foreign_enum")));
                            AssertTrue(message.hasField(f("optional_import_enum" )));
                            
                            AssertTrue(message.hasField(f("optional_string_piece")));
                            AssertTrue(message.hasField(f("optional_cord")));
                            
                            AssertTrue(101, message.getField(f("optional_int32"   )));
                            AssertTrue(102L, message.getField(f("optional_int64"   )));
                            AssertTrue(103, message.getField(f("optional_uint32"  )));
                            AssertTrue(104L, message.getField(f("optional_uint64"  )));
                            AssertTrue(105, message.getField(f("optional_sint32"  )));
                            AssertTrue(106L, message.getField(f("optional_sint64"  )));
                            AssertTrue(107, message.getField(f("optional_fixed32" )));
                            AssertTrue(108L, message.getField(f("optional_fixed64" )));
                            AssertTrue(109, message.getField(f("optional_sfixed32")));
                            AssertTrue(110L, message.getField(f("optional_sfixed64")));
                            AssertTrue(111F, message.getField(f("optional_float"   )));
                            AssertTrue(112D, message.getField(f("optional_double"  )));
                            AssertTrue(true, message.getField(f("optional_bool"    )));
                            AssertTrue("115", message.getField(f("optional_string"  )));
                            AssertTrue(toData("116"), message.getField(f("optional_bytes")));
                            
                            AssertTrue(117,
                                       ((Message)message.getField(f("optionalgroup"))).getField(groupA));
                            AssertTrue(118,
                                       ((Message)message.getField(f("optional_nested_message")))
                                       .getField(nestedB));
                            AssertTrue(119,
                                       ((Message)message.getField(f("optional_foreign_message")))
                                       .getField(foreignC));
                            AssertTrue(120,
                                       ((Message)message.getField(f("optional_import_message")))
                                       .getField(importD));
                            
                            AssertTrue( nestedBaz, message.getField(f("optional_nested_enum" )));
                            AssertTrue(foreignBaz, message.getField(f("optional_foreign_enum")));
                            AssertTrue( importBaz, message.getField(f("optional_import_enum" )));
                            
                            AssertTrue("124", message.getField(f("optional_string_piece")));
                            AssertTrue("125", message.getField(f("optional_cord")));
                            
                            // -----------------------------------------------------------------
                            
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_int32"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_int64"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_float"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_double"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_bool"    )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_string"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                            
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_message" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                            
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_string_piece")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_cord")));
                            
                            AssertTrue(201, message.getRepeatedField(f("repeated_int32"   ), 0));
                            AssertTrue(202L, message.getRepeatedField(f("repeated_int64"   ), 0));
                            AssertTrue(203, message.getRepeatedField(f("repeated_uint32"  ), 0));
                            AssertTrue(204L, message.getRepeatedField(f("repeated_uint64"  ), 0));
                            AssertTrue(205, message.getRepeatedField(f("repeated_sint32"  ), 0));
                            AssertTrue(206L, message.getRepeatedField(f("repeated_sint64"  ), 0));
                            AssertTrue(207, message.getRepeatedField(f("repeated_fixed32" ), 0));
                            AssertTrue(208L, message.getRepeatedField(f("repeated_fixed64" ), 0));
                            AssertTrue(209, message.getRepeatedField(f("repeated_sfixed32"), 0));
                            AssertTrue(210L, message.getRepeatedField(f("repeated_sfixed64"), 0));
                            AssertTrue(211F, message.getRepeatedField(f("repeated_float"   ), 0));
                            AssertTrue(212D, message.getRepeatedField(f("repeated_double"  ), 0));
                            AssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 0));
                            AssertTrue("215", message.getRepeatedField(f("repeated_string"  ), 0));
                            AssertTrue(toData("216"), message.getRepeatedField(f("repeated_bytes"), 0));
                            
                            AssertTrue(217,
                                       ((Message)message.getRepeatedField(f("repeatedgroup"), 0))
                                       .getField(repeatedGroupA));
                            AssertTrue(218,
                                       ((Message)message.getRepeatedField(f("repeated_nested_message"), 0))
                                       .getField(nestedB));
                            AssertTrue(219,
                                       ((Message)message.getRepeatedField(f("repeated_foreign_message"), 0))
                                       .getField(foreignC));
                            AssertTrue(220,
                                       ((Message)message.getRepeatedField(f("repeated_import_message"), 0))
                                       .getField(importD));
                            
                            AssertTrue( nestedBar, message.getRepeatedField(f("repeated_nested_enum" ),0));
                            AssertTrue(foreignBar, message.getRepeatedField(f("repeated_foreign_enum"),0));
                            AssertTrue( importBar, message.getRepeatedField(f("repeated_import_enum" ),0));
                            
                            AssertTrue("224", message.getRepeatedField(f("repeated_string_piece"), 0));
                            AssertTrue("225", message.getRepeatedField(f("repeated_cord"), 0));
                            
                            AssertTrue(301, message.getRepeatedField(f("repeated_int32"   ), 1));
                            AssertTrue(302L, message.getRepeatedField(f("repeated_int64"   ), 1));
                            AssertTrue(303, message.getRepeatedField(f("repeated_uint32"  ), 1));
                            AssertTrue(304L, message.getRepeatedField(f("repeated_uint64"  ), 1));
                            AssertTrue(305, message.getRepeatedField(f("repeated_sint32"  ), 1));
                            AssertTrue(306L, message.getRepeatedField(f("repeated_sint64"  ), 1));
                            AssertTrue(307, message.getRepeatedField(f("repeated_fixed32" ), 1));
                            AssertTrue(308L, message.getRepeatedField(f("repeated_fixed64" ), 1));
                            AssertTrue(309, message.getRepeatedField(f("repeated_sfixed32"), 1));
                            AssertTrue(310L, message.getRepeatedField(f("repeated_sfixed64"), 1));
                            AssertTrue(311F, message.getRepeatedField(f("repeated_float"   ), 1));
                            AssertTrue(312D, message.getRepeatedField(f("repeated_double"  ), 1));
                            AssertTrue(false, message.getRepeatedField(f("repeated_bool"    ), 1));
                            AssertTrue("315", message.getRepeatedField(f("repeated_string"  ), 1));
                            AssertTrue(toData("316"), message.getRepeatedField(f("repeated_bytes"), 1));
                            
                            AssertTrue(317,
                                       ((Message)message.getRepeatedField(f("repeatedgroup"), 1))
                                       .getField(repeatedGroupA));
                            AssertTrue(318,
                                       ((Message)message.getRepeatedField(f("repeated_nested_message"), 1))
                                       .getField(nestedB));
                            AssertTrue(319,
                                       ((Message)message.getRepeatedField(f("repeated_foreign_message"), 1))
                                       .getField(foreignC));
                            AssertTrue(320,
                                       ((Message)message.getRepeatedField(f("repeated_import_message"), 1))
                                       .getField(importD));
                            
                            AssertTrue( nestedBaz, message.getRepeatedField(f("repeated_nested_enum" ),1));
                            AssertTrue(foreignBaz, message.getRepeatedField(f("repeated_foreign_enum"),1));
                            AssertTrue( importBaz, message.getRepeatedField(f("repeated_import_enum" ),1));
                            
                            AssertTrue("324", message.getRepeatedField(f("repeated_string_piece"), 1));
                            AssertTrue("325", message.getRepeatedField(f("repeated_cord"), 1));
                            
                            // -----------------------------------------------------------------
                            
                            AssertTrue(message.hasField(f("default_int32"   )));
                            AssertTrue(message.hasField(f("default_int64"   )));
                            AssertTrue(message.hasField(f("default_uint32"  )));
                            AssertTrue(message.hasField(f("default_uint64"  )));
                            AssertTrue(message.hasField(f("default_sint32"  )));
                            AssertTrue(message.hasField(f("default_sint64"  )));
                            AssertTrue(message.hasField(f("default_fixed32" )));
                            AssertTrue(message.hasField(f("default_fixed64" )));
                            AssertTrue(message.hasField(f("default_sfixed32")));
                            AssertTrue(message.hasField(f("default_sfixed64")));
                            AssertTrue(message.hasField(f("default_float"   )));
                            AssertTrue(message.hasField(f("default_double"  )));
                            AssertTrue(message.hasField(f("default_bool"    )));
                            AssertTrue(message.hasField(f("default_string"  )));
                            AssertTrue(message.hasField(f("default_bytes"   )));
                            
                            AssertTrue(message.hasField(f("default_nested_enum" )));
                            AssertTrue(message.hasField(f("default_foreign_enum")));
                            AssertTrue(message.hasField(f("default_import_enum" )));
                            
                            AssertTrue(message.hasField(f("default_string_piece")));
                            AssertTrue(message.hasField(f("default_cord")));
                            
                            AssertTrue(401, message.getField(f("default_int32"   )));
                            AssertTrue(402L, message.getField(f("default_int64"   )));
                            AssertTrue(403, message.getField(f("default_uint32"  )));
                            AssertTrue(404L, message.getField(f("default_uint64"  )));
                            AssertTrue(405, message.getField(f("default_sint32"  )));
                            AssertTrue(406L, message.getField(f("default_sint64"  )));
                            AssertTrue(407, message.getField(f("default_fixed32" )));
                            AssertTrue(408L, message.getField(f("default_fixed64" )));
                            AssertTrue(409, message.getField(f("default_sfixed32")));
                            AssertTrue(410L, message.getField(f("default_sfixed64")));
                            AssertTrue(411F, message.getField(f("default_float"   )));
                            AssertTrue(412D, message.getField(f("default_double"  )));
                            AssertTrue(false, message.getField(f("default_bool"    )));
                            AssertTrue("415", message.getField(f("default_string"  )));
                            AssertTrue(toData("416"), message.getField(f("default_bytes")));
                            
                            AssertTrue( nestedFoo, message.getField(f("default_nested_enum" )));
                            AssertTrue(foreignFoo, message.getField(f("default_foreign_enum")));
                            AssertTrue( importFoo, message.getField(f("default_import_enum" )));
                            
                            AssertTrue("424", message.getField(f("default_string_piece")));
                            AssertTrue("425", message.getField(f("default_cord")));
                        }
                                               
                                               // -------------------------------------------------------------------
                                               
                                               /**
                         * Assert (using {@code junit.framework.Assert}} that all fields of
                         * {@code message} are cleared, and that getting the fields returns their
                         * default values, using the {@link Message} reflection interface.
                         */
                                               public void assertClearViaReflection(Message message) {
                            // has_blah() should initially be false for all optional fields.
                            AssertFalse(message.hasField(f("optional_int32"   )));
                            AssertFalse(message.hasField(f("optional_int64"   )));
                            AssertFalse(message.hasField(f("optional_uint32"  )));
                            AssertFalse(message.hasField(f("optional_uint64"  )));
                            AssertFalse(message.hasField(f("optional_sint32"  )));
                            AssertFalse(message.hasField(f("optional_sint64"  )));
                            AssertFalse(message.hasField(f("optional_fixed32" )));
                            AssertFalse(message.hasField(f("optional_fixed64" )));
                            AssertFalse(message.hasField(f("optional_sfixed32")));
                            AssertFalse(message.hasField(f("optional_sfixed64")));
                            AssertFalse(message.hasField(f("optional_float"   )));
                            AssertFalse(message.hasField(f("optional_double"  )));
                            AssertFalse(message.hasField(f("optional_bool"    )));
                            AssertFalse(message.hasField(f("optional_string"  )));
                            AssertFalse(message.hasField(f("optional_bytes"   )));
                            
                            AssertFalse(message.hasField(f("optionalgroup"           )));
                            AssertFalse(message.hasField(f("optional_nested_message" )));
                            AssertFalse(message.hasField(f("optional_foreign_message")));
                            AssertFalse(message.hasField(f("optional_import_message" )));
                            
                            AssertFalse(message.hasField(f("optional_nested_enum" )));
                            AssertFalse(message.hasField(f("optional_foreign_enum")));
                            AssertFalse(message.hasField(f("optional_import_enum" )));
                            
                            AssertFalse(message.hasField(f("optional_string_piece")));
                            AssertFalse(message.hasField(f("optional_cord")));
                            
                            // Optional fields without defaults are set to zero or something like it.
                            AssertTrue(0, message.getField(f("optional_int32"   )));
                            AssertTrue(0L, message.getField(f("optional_int64"   )));
                            AssertTrue(0, message.getField(f("optional_uint32"  )));
                            AssertTrue(0L, message.getField(f("optional_uint64"  )));
                            AssertTrue(0, message.getField(f("optional_sint32"  )));
                            AssertTrue(0L, message.getField(f("optional_sint64"  )));
                            AssertTrue(0, message.getField(f("optional_fixed32" )));
                            AssertTrue(0L, message.getField(f("optional_fixed64" )));
                            AssertTrue(0, message.getField(f("optional_sfixed32")));
                            AssertTrue(0L, message.getField(f("optional_sfixed64")));
                            AssertTrue(0F, message.getField(f("optional_float"   )));
                            AssertTrue(0D, message.getField(f("optional_double"  )));
                            AssertTrue(false, message.getField(f("optional_bool"    )));
                            AssertTrue("", message.getField(f("optional_string"  )));
                            AssertTrue(ByteString.EMPTY, message.getField(f("optional_bytes")));
                            
                            // Embedded messages should also be clear.
                            AssertFalse(
                                          ((Message)message.getField(f("optionalgroup"))).hasField(groupA));
                            AssertFalse(
                                          ((Message)message.getField(f("optional_nested_message")))
                                          .hasField(nestedB));
                            AssertFalse(
                                          ((Message)message.getField(f("optional_foreign_message")))
                                          .hasField(foreignC));
                            AssertFalse(
                                          ((Message)message.getField(f("optional_import_message")))
                                          .hasField(importD));
                            
                            AssertTrue(0,
                                       ((Message)message.getField(f("optionalgroup"))).getField(groupA));
                            AssertTrue(0,
                                       ((Message)message.getField(f("optional_nested_message")))
                                       .getField(nestedB));
                            AssertTrue(0,
                                       ((Message)message.getField(f("optional_foreign_message")))
                                       .getField(foreignC));
                            AssertTrue(0,
                                       ((Message)message.getField(f("optional_import_message")))
                                       .getField(importD));
                            
                            // Enums without defaults are set to the first value in the enum.
                            AssertTrue( nestedFoo, message.getField(f("optional_nested_enum" )));
                            AssertTrue(foreignFoo, message.getField(f("optional_foreign_enum")));
                            AssertTrue( importFoo, message.getField(f("optional_import_enum" )));
                            
                            AssertTrue("", message.getField(f("optional_string_piece")));
                            AssertTrue("", message.getField(f("optional_cord")));
                            
                            // Repeated fields are empty.
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_int32"   )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_int64"   )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_float"   )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_double"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_bool"    )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_string"  )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                            
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_import_message" )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                            
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_string_piece")));
                            AssertTrue(0, message.getRepeatedFieldCount(f("repeated_cord")));
                            
                            // has_blah() should also be false for all default fields.
                            AssertFalse(message.hasField(f("default_int32"   )));
                            AssertFalse(message.hasField(f("default_int64"   )));
                            AssertFalse(message.hasField(f("default_uint32"  )));
                            AssertFalse(message.hasField(f("default_uint64"  )));
                            AssertFalse(message.hasField(f("default_sint32"  )));
                            AssertFalse(message.hasField(f("default_sint64"  )));
                            AssertFalse(message.hasField(f("default_fixed32" )));
                            AssertFalse(message.hasField(f("default_fixed64" )));
                            AssertFalse(message.hasField(f("default_sfixed32")));
                            AssertFalse(message.hasField(f("default_sfixed64")));
                            AssertFalse(message.hasField(f("default_float"   )));
                            AssertFalse(message.hasField(f("default_double"  )));
                            AssertFalse(message.hasField(f("default_bool"    )));
                            AssertFalse(message.hasField(f("default_string"  )));
                            AssertFalse(message.hasField(f("default_bytes"   )));
                            
                            AssertFalse(message.hasField(f("default_nested_enum" )));
                            AssertFalse(message.hasField(f("default_foreign_enum")));
                            AssertFalse(message.hasField(f("default_import_enum" )));
                            
                            AssertFalse(message.hasField(f("default_string_piece" )));
                            AssertFalse(message.hasField(f("default_cord" )));
                            
                            // Fields with defaults have their default values (duh).
                            AssertTrue( 41, message.getField(f("default_int32"   )));
                            AssertTrue( 42L, message.getField(f("default_int64"   )));
                            AssertTrue( 43, message.getField(f("default_uint32"  )));
                            AssertTrue( 44L, message.getField(f("default_uint64"  )));
                            AssertTrue(-45, message.getField(f("default_sint32"  )));
                            AssertTrue( 46L, message.getField(f("default_sint64"  )));
                            AssertTrue( 47, message.getField(f("default_fixed32" )));
                            AssertTrue( 48L, message.getField(f("default_fixed64" )));
                            AssertTrue( 49, message.getField(f("default_sfixed32")));
                            AssertTrue(-50L, message.getField(f("default_sfixed64")));
                            AssertTrue( 51.5F, message.getField(f("default_float"   )));
                            AssertTrue( 52e3D, message.getField(f("default_double"  )));
                            AssertTrue(true, message.getField(f("default_bool"    )));
                            AssertTrue("hello", message.getField(f("default_string"  )));
                            AssertTrue(toData("world"), message.getField(f("default_bytes")));
                            
                            AssertTrue( nestedBar, message.getField(f("default_nested_enum" )));
                            AssertTrue(foreignBar, message.getField(f("default_foreign_enum")));
                            AssertTrue( importBar, message.getField(f("default_import_enum" )));
                            
                            AssertTrue("abc", message.getField(f("default_string_piece")));
                            AssertTrue("123", message.getField(f("default_cord")));
                        }
                                               
                                               // ---------------------------------------------------------------
                                               
                                               public void assertRepeatedFieldsModifiedViaReflection(Message message) {
                            // ModifyRepeatedFields only sets the second repeated element of each
                            // field.  In addition to verifying this, we also verify that the first
                            // element and size were *not* modified.
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_int32"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_int64"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint32"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_uint64"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint32"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sint64"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed32" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_fixed64" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed32")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_sfixed64")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_float"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_double"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_bool"    )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_string"  )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_bytes"   )));
                            
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeatedgroup"           )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_message" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_message")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_message" )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_nested_enum"    )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_foreign_enum"   )));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_import_enum"    )));
                            
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_string_piece")));
                            AssertTrue(2, message.getRepeatedFieldCount(f("repeated_cord")));
                            
                            AssertTrue(201, message.getRepeatedField(f("repeated_int32"   ), 0));
                            AssertTrue(202L, message.getRepeatedField(f("repeated_int64"   ), 0));
                            AssertTrue(203, message.getRepeatedField(f("repeated_uint32"  ), 0));
                            AssertTrue(204L, message.getRepeatedField(f("repeated_uint64"  ), 0));
                            AssertTrue(205, message.getRepeatedField(f("repeated_sint32"  ), 0));
                            AssertTrue(206L, message.getRepeatedField(f("repeated_sint64"  ), 0));
                            AssertTrue(207, message.getRepeatedField(f("repeated_fixed32" ), 0));
                            AssertTrue(208L, message.getRepeatedField(f("repeated_fixed64" ), 0));
                            AssertTrue(209, message.getRepeatedField(f("repeated_sfixed32"), 0));
                            AssertTrue(210L, message.getRepeatedField(f("repeated_sfixed64"), 0));
                            AssertTrue(211F, message.getRepeatedField(f("repeated_float"   ), 0));
                            AssertTrue(212D, message.getRepeatedField(f("repeated_double"  ), 0));
                            AssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 0));
                            AssertTrue("215", message.getRepeatedField(f("repeated_string"  ), 0));
                            AssertTrue(toData("216"), message.getRepeatedField(f("repeated_bytes"), 0));
                            
                            AssertTrue(217,
                                       ((Message)message.getRepeatedField(f("repeatedgroup"), 0))
                                       .getField(repeatedGroupA));
                            AssertTrue(218,
                                       ((Message)message.getRepeatedField(f("repeated_nested_message"), 0))
                                       .getField(nestedB));
                            AssertTrue(219,
                                       ((Message)message.getRepeatedField(f("repeated_foreign_message"), 0))
                                       .getField(foreignC));
                            AssertTrue(220,
                                       ((Message)message.getRepeatedField(f("repeated_import_message"), 0))
                                       .getField(importD));
                            
                            AssertTrue( nestedBar, message.getRepeatedField(f("repeated_nested_enum" ),0));
                            AssertTrue(foreignBar, message.getRepeatedField(f("repeated_foreign_enum"),0));
                            AssertTrue( importBar, message.getRepeatedField(f("repeated_import_enum" ),0));
                            
                            AssertTrue("224", message.getRepeatedField(f("repeated_string_piece"), 0));
                            AssertTrue("225", message.getRepeatedField(f("repeated_cord"), 0));
                            
                            AssertTrue(501, message.getRepeatedField(f("repeated_int32"   ), 1));
                            AssertTrue(502L, message.getRepeatedField(f("repeated_int64"   ), 1));
                            AssertTrue(503, message.getRepeatedField(f("repeated_uint32"  ), 1));
                            AssertTrue(504L, message.getRepeatedField(f("repeated_uint64"  ), 1));
                            AssertTrue(505, message.getRepeatedField(f("repeated_sint32"  ), 1));
                            AssertTrue(506L, message.getRepeatedField(f("repeated_sint64"  ), 1));
                            AssertTrue(507, message.getRepeatedField(f("repeated_fixed32" ), 1));
                            AssertTrue(508L, message.getRepeatedField(f("repeated_fixed64" ), 1));
                            AssertTrue(509, message.getRepeatedField(f("repeated_sfixed32"), 1));
                            AssertTrue(510L, message.getRepeatedField(f("repeated_sfixed64"), 1));
                            AssertTrue(511F, message.getRepeatedField(f("repeated_float"   ), 1));
                            AssertTrue(512D, message.getRepeatedField(f("repeated_double"  ), 1));
                            AssertTrue(true, message.getRepeatedField(f("repeated_bool"    ), 1));
                            AssertTrue("515", message.getRepeatedField(f("repeated_string"  ), 1));
                            AssertTrue(toData("516"), message.getRepeatedField(f("repeated_bytes"), 1));
                            
                            AssertTrue(517,
                                       ((Message)message.getRepeatedField(f("repeatedgroup"), 1))
                                       .getField(repeatedGroupA));
                            AssertTrue(518,
                                       ((Message)message.getRepeatedField(f("repeated_nested_message"), 1))
                                       .getField(nestedB));
                            AssertTrue(519,
                                       ((Message)message.getRepeatedField(f("repeated_foreign_message"), 1))
                                       .getField(foreignC));
                            AssertTrue(520,
                                       ((Message)message.getRepeatedField(f("repeated_import_message"), 1))
                                       .getField(importD));
                            
                            AssertTrue( nestedFoo, message.getRepeatedField(f("repeated_nested_enum" ),1));
                            AssertTrue(foreignFoo, message.getRepeatedField(f("repeated_foreign_enum"),1));
                            AssertTrue( importFoo, message.getRepeatedField(f("repeated_import_enum" ),1));
                            
                            AssertTrue("524", message.getRepeatedField(f("repeated_string_piece"), 1));
                            AssertTrue("525", message.getRepeatedField(f("repeated_cord"), 1));
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