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


+ (NSData*) goldenData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"golden_message" ofType:nil];
    if (path == nil) {
        path = @"golden_message";
    }
    NSData* goldenData = [NSData dataWithContentsOfFile:path];
    return goldenData;
}


- (void) failWithException:(NSException *) anException {
    @throw anException;
}


// -------------------------------------------------------------------

/**
 * Modify the repeated extensions of {@code message} to contain the values
 * expected by {@code assertRepeatedExtensionsModified()}.
 */
+ (void) modifyRepeatedExtensions:(TestAllExtensions_Builder*) message {
    [message setExtension:[UnittestProtoRoot repeatedInt32Extension] index:1 value:[NSNumber numberWithInt:501]];
    [message setExtension:[UnittestProtoRoot repeatedInt64Extension] index:1 value:[NSNumber numberWithInt:502]];
    [message setExtension:[UnittestProtoRoot repeatedUint32Extension] index:1 value:[NSNumber numberWithInt:503]];
    [message setExtension:[UnittestProtoRoot repeatedUint64Extension] index:1 value:[NSNumber numberWithInt:504]];
    [message setExtension:[UnittestProtoRoot repeatedSint32Extension] index:1 value:[NSNumber numberWithInt:505]];
    [message setExtension:[UnittestProtoRoot repeatedSint64Extension] index:1 value:[NSNumber numberWithInt:506]];
    [message setExtension:[UnittestProtoRoot repeatedFixed32Extension] index:1 value:[NSNumber numberWithInt:507]];
    [message setExtension:[UnittestProtoRoot repeatedFixed64Extension] index:1 value:[NSNumber numberWithInt:508]];
    [message setExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:1 value:[NSNumber numberWithInt:509]];
    [message setExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:1 value:[NSNumber numberWithInt:510]];
    [message setExtension:[UnittestProtoRoot repeatedFloatExtension] index:1 value:[NSNumber numberWithFloat:511.0]];
    [message setExtension:[UnittestProtoRoot repeatedDoubleExtension] index:1 value:[NSNumber numberWithDouble:512.0]];
    [message setExtension:[UnittestProtoRoot repeatedBoolExtension] index:1 value:[NSNumber numberWithBool:true]];
    [message setExtension:[UnittestProtoRoot repeatedStringExtension] index:1 value:@"515"];
    [message setExtension:[UnittestProtoRoot repeatedBytesExtension] index:1 value:[TestUtilities toData:@"516"]];
    
    [message setExtension:[UnittestProtoRoot repeatedGroupExtension] index:1 value:
     [[[RepeatedGroup_extension builder] setA:517] build]];
    [message setExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:1 value:
     [[[TestAllTypes_NestedMessage builder] setBb:518] build]];
    [message setExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:1 value:
     [[[ForeignMessage builder] setC:519] build]];
    [message setExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:1 value:
     [[[ImportMessage builder] setD:520] build]];
    
    [message setExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:1 value:
     [TestAllTypes_NestedEnum FOO]];
    [message setExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:1 value:
     [ForeignEnum FOREIGN_FOO]];
    [message setExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:1 value:
     [ImportEnum IMPORT_FOO]];
    
    [message setExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:1 value:@"524"];
    [message setExtension:[UnittestProtoRoot repeatedCordExtension] index:1 value:@"525"];
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


- (void) assertRepeatedExtensionsModified:(TestAllExtensions*) message {
    // ModifyRepeatedFields only sets the second repeated element of each
    // field.  In addition to verifying this, we also verify that the first
    // element and size were *not* modified.
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedStringExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedBytesExtension]] count], @"");
    
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedImportEnumExtension]] count], @"");
    
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedStringPieceExtension]] count], @"");
    STAssertTrue(2 == [[message getExtension:[UnittestProtoRoot repeatedCordExtension]] count], @"");
    
    STAssertTrue(201  == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:0] intValue], @"");
    STAssertTrue(202L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:0] intValue], @"");
    STAssertTrue(203  == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:0] intValue], @"");
    STAssertTrue(204L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:0] intValue], @"");
    STAssertTrue(205  == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:0] intValue], @"");
    STAssertTrue(206L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:0] intValue], @"");
    STAssertTrue(207  == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:0] intValue], @"");
    STAssertTrue(208L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:0] intValue], @"");
    STAssertTrue(209  == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:0] intValue], @"");
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
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] ==
                 [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:0], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] ==
                 [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:0], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] ==
                 [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:0], @"");
    
    STAssertEqualObjects(@"224", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:0], @"");
    STAssertEqualObjects(@"225", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:0], @"");
    
    // Actually verify the second (modified) elements now.
    STAssertTrue(501  == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension] index:1] intValue], @"");
    STAssertTrue(502L == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension] index:1] intValue], @"");
    STAssertTrue(503  == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension] index:1] intValue], @"");
    STAssertTrue(504L == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension] index:1] intValue], @"");
    STAssertTrue(505  == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension] index:1] intValue], @"");
    STAssertTrue(506L == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension] index:1] intValue], @"");
    STAssertTrue(507  == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension] index:1] intValue], @"");
    STAssertTrue(508L == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension] index:1] intValue], @"");
    STAssertTrue(509  == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension] index:1] intValue], @"");
    STAssertTrue(510L == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension] index:1] intValue], @"");
    STAssertTrue(511.0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension] index:1] floatValue], @"");
    STAssertTrue(512.0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension] index:1] doubleValue], @"");
    STAssertTrue(true == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension] index:1] boolValue], @"");
    STAssertEqualObjects(@"515", [message getExtension:[UnittestProtoRoot repeatedStringExtension] index:1], @"");
    STAssertEqualObjects([TestUtilities toData:@"516"], [message getExtension:[UnittestProtoRoot repeatedBytesExtension] index:1], @"");
    
    STAssertTrue(517 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension] index:1] a], @"");
    STAssertTrue(518 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension] index:1] bb], @"");
    STAssertTrue(519 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension] index:1] c], @"");
    STAssertTrue(520 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension] index:1] d], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum FOO] ==
                 [message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension] index:1], @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] ==
                 [message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension] index:1], @"");
    STAssertTrue([ImportEnum IMPORT_FOO] ==
                 [message getExtension:[UnittestProtoRoot repeatedImportEnumExtension] index:1], @"");
    
    STAssertEqualObjects(@"524", [message getExtension:[UnittestProtoRoot repeatedStringPieceExtension] index:1], @"");
    STAssertEqualObjects(@"525", [message getExtension:[UnittestProtoRoot repeatedCordExtension] index:1], @"");
}


+ (void) assertRepeatedExtensionsModified:(TestAllExtensions*) message {
    [[[[TestUtilities alloc] init] autorelease] assertRepeatedExtensionsModified:message];
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
    STAssertEqualsWithAccuracy(111.0f, message.optionalFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(112.0, message.optionalDouble, 0.1, @"");
    STAssertTrue(true == message.optionalBool, @"");
    STAssertEqualObjects(@"115", message.optionalString, @"");
    STAssertEqualObjects([TestUtilities toData:@"116"], message.optionalBytes, @"");
    
    STAssertTrue(117 == message.optionalGroup.a, @"");
    STAssertTrue(118 == message.optionalNestedMessage.bb, @"");
    STAssertTrue(119 == message.optionalForeignMessage.c, @"");
    STAssertTrue(120 == message.optionalImportMessage.d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == message.optionalNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == message.optionalForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == message.optionalImportEnum, @"");
    
    STAssertEqualObjects(@"124", message.optionalStringPiece, @"");
    STAssertEqualObjects(@"125", message.optionalCord, @"");
    
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
    STAssertEqualsWithAccuracy(211.0f, [message repeatedFloatAtIndex:0], 0.1, @"");
    STAssertEqualsWithAccuracy(212.0, [message repeatedDoubleAtIndex:0], 0.1, @"");
    STAssertTrue(true == [message repeatedBoolAtIndex:0], @"");
    STAssertEqualObjects(@"215", [message repeatedStringAtIndex:0], @"");
    STAssertEqualObjects([TestUtilities toData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    STAssertTrue(217 == [message repeatedGroupAtIndex:0].a, @"");
    STAssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    STAssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    STAssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
    
    STAssertEqualObjects(@"224", [message repeatedStringPieceAtIndex:0], @"");
    STAssertEqualObjects(@"225", [message repeatedCordAtIndex:0], @"");
    
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
    STAssertEqualsWithAccuracy(311.0f, [message repeatedFloatAtIndex:1], 0.1, @"");
    STAssertEqualsWithAccuracy(312.0, [message repeatedDoubleAtIndex:1], 0.1, @"");
    STAssertTrue(false == [message repeatedBoolAtIndex:1], @"");
    STAssertEqualObjects(@"315", [message repeatedStringAtIndex:1], @"");
    STAssertEqualObjects([TestUtilities toData:@"316"], [message repeatedBytesAtIndex:1], @"");
    
    STAssertTrue(317 == [message repeatedGroupAtIndex:1].a, @"");
    STAssertTrue(318 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    STAssertTrue(319 == [message repeatedForeignMessageAtIndex:1].c, @"");
    STAssertTrue(320 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAZ] == [message repeatedNestedEnumAtIndex:1], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAZ] == [message repeatedForeignEnumAtIndex:1], @"");
    STAssertTrue([ImportEnum IMPORT_BAZ] == [message repeatedImportEnumAtIndex:1], @"");
    
    STAssertEqualObjects(@"324", [message repeatedStringPieceAtIndex:1], @"");
    STAssertEqualObjects(@"325", [message repeatedCordAtIndex:1], @"");
    
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
    STAssertEqualsWithAccuracy(411.0f, message.defaultFloat, 0.1, @"");
    STAssertEqualsWithAccuracy(412.0, message.defaultDouble, 0.1, @"");
    STAssertTrue(false == message.defaultBool, @"");
    STAssertEqualObjects(@"415", message.defaultString, @"");
    STAssertEqualObjects([TestUtilities toData:@"416"], message.defaultBytes, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum FOO] == message.defaultNestedEnum, @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == message.defaultForeignEnum, @"");
    STAssertTrue([ImportEnum IMPORT_FOO] == message.defaultImportEnum, @"");
    
    STAssertEqualObjects(@"424", message.defaultStringPiece, @"");
    STAssertEqualObjects(@"425", message.defaultCord, @"");
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


- (void) assertExtensionsClear:(TestAllExtensions*) message {
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
    STAssertTrue(0     == [[message getExtension:[UnittestProtoRoot optionalInt32Extension]] intValue], @"");
    STAssertTrue(0L    == [[message getExtension:[UnittestProtoRoot optionalInt64Extension]] intValue], @"");
    STAssertTrue(0     == [[message getExtension:[UnittestProtoRoot optionalUint32Extension]] intValue], @"");
    STAssertTrue(0L    == [[message getExtension:[UnittestProtoRoot optionalUint64Extension]] intValue], @"");
    STAssertTrue(0     == [[message getExtension:[UnittestProtoRoot optionalSint32Extension]] intValue], @"");
    STAssertTrue(0L    == [[message getExtension:[UnittestProtoRoot optionalSint64Extension]] intValue], @"");
    STAssertTrue(0     == [[message getExtension:[UnittestProtoRoot optionalFixed32Extension]] intValue], @"");
    STAssertTrue(0L    == [[message getExtension:[UnittestProtoRoot optionalFixed64Extension]] intValue], @"");
    STAssertTrue(0     == [[message getExtension:[UnittestProtoRoot optionalSfixed32Extension]] intValue], @"");
    STAssertTrue(0L    == [[message getExtension:[UnittestProtoRoot optionalSfixed64Extension]] intValue], @"");
    STAssertTrue(0    == [[message getExtension:[UnittestProtoRoot optionalFloatExtension]] floatValue], @"");
    STAssertTrue(0    == [[message getExtension:[UnittestProtoRoot optionalDoubleExtension]] doubleValue], @"");
    STAssertTrue(false == [[message getExtension:[UnittestProtoRoot optionalBoolExtension]] boolValue], @"");
    STAssertEqualObjects(@"", [message getExtension:[UnittestProtoRoot optionalStringExtension]], @"");
    STAssertEqualObjects([NSData data], [message getExtension:[UnittestProtoRoot optionalBytesExtension]], @"");
    
    // Embedded messages should also be clear.
    
    STAssertFalse([[message getExtension:[UnittestProtoRoot optionalGroupExtension]] hasA], @"");
    STAssertFalse([[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] hasBb], @"");
    STAssertFalse([[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] hasC], @"");
    STAssertFalse([[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] hasD], @"");
    
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot optionalGroupExtension]] a], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot optionalNestedMessageExtension]] bb], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot optionalForeignMessageExtension]] c], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot optionalImportMessageExtension]] d], @"");
    
    // Enums without defaults are set to the first value in the enum.
    STAssertTrue([TestAllTypes_NestedEnum FOO] ==
                 [message getExtension:[UnittestProtoRoot optionalNestedEnumExtension]], @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == 
                 [message getExtension:[UnittestProtoRoot optionalForeignEnumExtension]], @"");
    STAssertTrue([ImportEnum IMPORT_FOO] ==
                 [message getExtension:[UnittestProtoRoot optionalImportEnumExtension]], @"");
    
    STAssertEqualObjects(@"", [message getExtension:[UnittestProtoRoot optionalStringPieceExtension]], @"");
    STAssertEqualObjects(@"", [message getExtension:[UnittestProtoRoot optionalCordExtension]], @"");
    
    // Repeated fields are empty.
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedInt32Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedInt64Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedUint32Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedUint64Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedSint32Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedSint64Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedFixed32Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedFixed64Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedSfixed32Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedSfixed64Extension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedFloatExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedDoubleExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedBoolExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedStringExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedBytesExtension]] count], @"");
    
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedGroupExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedNestedMessageExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedForeignMessageExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedImportMessageExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedNestedEnumExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedForeignEnumExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedImportEnumExtension]] count], @"");
    
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedStringPieceExtension]] count], @"");
    STAssertTrue(0 == [[message getExtension:[UnittestProtoRoot repeatedCordExtension]] count], @"");
    
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
    STAssertTrue( 41     == [[message getExtension:[UnittestProtoRoot defaultInt32Extension]] intValue], @"");
    STAssertTrue( 42L    == [[message getExtension:[UnittestProtoRoot defaultInt64Extension]] intValue], @"");
    STAssertTrue( 43     == [[message getExtension:[UnittestProtoRoot defaultUint32Extension]] intValue], @"");
    STAssertTrue( 44L    == [[message getExtension:[UnittestProtoRoot defaultUint64Extension]] intValue], @"");
    STAssertTrue(-45     == [[message getExtension:[UnittestProtoRoot defaultSint32Extension]] intValue], @"");
    STAssertTrue( 46L    == [[message getExtension:[UnittestProtoRoot defaultSint64Extension]] intValue], @"");
    STAssertTrue( 47     == [[message getExtension:[UnittestProtoRoot defaultFixed32Extension]] intValue], @"");
    STAssertTrue( 48L    == [[message getExtension:[UnittestProtoRoot defaultFixed64Extension]] intValue], @"");
    STAssertTrue( 49     == [[message getExtension:[UnittestProtoRoot defaultSfixed32Extension]] intValue], @"");
    STAssertTrue(-50L    == [[message getExtension:[UnittestProtoRoot defaultSfixed64Extension]] intValue], @"");
    STAssertTrue( 51.5  == [[message getExtension:[UnittestProtoRoot defaultFloatExtension]] floatValue], @"");
    STAssertTrue( 52e3  == [[message getExtension:[UnittestProtoRoot defaultDoubleExtension]] doubleValue], @"");
    STAssertTrue(true    == [[message getExtension:[UnittestProtoRoot defaultBoolExtension]] boolValue], @"");
    STAssertEqualObjects(@"hello", [message getExtension:[UnittestProtoRoot defaultStringExtension]], @"");
    STAssertEqualObjects([TestUtilities toData:@"world"], [message getExtension:[UnittestProtoRoot defaultBytesExtension]], @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] ==
                 [message getExtension:[UnittestProtoRoot defaultNestedEnumExtension]], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] ==
                 [message getExtension:[UnittestProtoRoot defaultForeignEnumExtension]], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] ==
                 [message getExtension:[UnittestProtoRoot defaultImportEnumExtension]], @"");
    
    STAssertEqualObjects(@"abc", [message getExtension:[UnittestProtoRoot defaultStringPieceExtension]], @"");
    STAssertEqualObjects(@"123", [message getExtension:[UnittestProtoRoot defaultCordExtension]], @"");
}


+ (void) assertExtensionsClear:(TestAllExtensions*) message {
    [[[[TestUtilities alloc] init] autorelease] assertExtensionsClear:message];
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
    STAssertTrue(211.0 == [message repeatedFloatAtIndex:0], @"");
    STAssertTrue(212.0 == [message repeatedDoubleAtIndex:0], @"");
    STAssertTrue(true == [message repeatedBoolAtIndex:0], @"");
    STAssertEqualObjects(@"215", [message repeatedStringAtIndex:0], @"");
    STAssertEqualObjects([TestUtilities toData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    STAssertTrue(217 == [message repeatedGroupAtIndex:0].a, @"");
    STAssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    STAssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    STAssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum BAR] == [message repeatedNestedEnumAtIndex:0], @"");
    STAssertTrue([ForeignEnum FOREIGN_BAR] == [message repeatedForeignEnumAtIndex:0], @"");
    STAssertTrue([ImportEnum IMPORT_BAR] == [message repeatedImportEnumAtIndex:0], @"");
    
    STAssertEqualObjects(@"224", [message repeatedStringPieceAtIndex:0], @"");
    STAssertEqualObjects(@"225", [message repeatedCordAtIndex:0], @"");
    
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
    STAssertTrue(511.0 == [message repeatedFloatAtIndex:1], @"");
    STAssertTrue(512.0 == [message repeatedDoubleAtIndex:1], @"");
    STAssertTrue(true == [message repeatedBoolAtIndex:1], @"");
    STAssertEqualObjects(@"515", [message repeatedStringAtIndex:1], @"");
    STAssertEqualObjects([TestUtilities toData:@"516"], [message repeatedBytesAtIndex:1], @"");
    
    STAssertTrue(517 == [message repeatedGroupAtIndex:1].a, @"");
    STAssertTrue(518 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    STAssertTrue(519 == [message repeatedForeignMessageAtIndex:1].c, @"");
    STAssertTrue(520 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    STAssertTrue([TestAllTypes_NestedEnum FOO] == [message repeatedNestedEnumAtIndex:1], @"");
    STAssertTrue([ForeignEnum FOREIGN_FOO] == [message repeatedForeignEnumAtIndex:1], @"");
    STAssertTrue([ImportEnum IMPORT_FOO] == [message repeatedImportEnumAtIndex:1], @"");
    
    STAssertEqualObjects(@"524", [message repeatedStringPieceAtIndex:1], @"");
    STAssertEqualObjects(@"525", [message repeatedCordAtIndex:1], @"");
}


+ (void) assertRepeatedFieldsModified:(TestAllTypes*) message {
    [[[[TestUtilities alloc] init] autorelease] assertRepeatedFieldsModified:message];
}

@end