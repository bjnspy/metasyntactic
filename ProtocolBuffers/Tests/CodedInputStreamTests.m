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

#import "CodedInputStreamTests.h"

#import "ProtocolBuffers.h"

@implementation CodedInputStreamTests

- (void) testDecodeZigZag {
    STAssertEquals( 0, decodeZigZag32(0), nil);
    STAssertEquals(-1, decodeZigZag32(1), nil);
    STAssertEquals( 1, decodeZigZag32(2), nil);
    STAssertEquals(-2, decodeZigZag32(3), nil);
    STAssertEquals((int32_t)0x3FFFFFFF, decodeZigZag32(0x7FFFFFFE), nil);
    STAssertEquals((int32_t)0xC0000000, decodeZigZag32(0x7FFFFFFF), nil);
    STAssertEquals((int32_t)0x7FFFFFFF, decodeZigZag32(0xFFFFFFFE), nil);
    STAssertEquals((int32_t)0x80000000, decodeZigZag32(0xFFFFFFFF), nil);
    
    STAssertEquals((int64_t) 0, decodeZigZag64(0), nil);
    STAssertEquals((int64_t)-1, decodeZigZag64(1), nil);
    STAssertEquals((int64_t) 1, decodeZigZag64(2), nil);
    STAssertEquals((int64_t)-2, decodeZigZag64(3), nil);
    STAssertEquals((int64_t)0x000000003FFFFFFFL, decodeZigZag64(0x000000007FFFFFFEL), nil);
    STAssertEquals((int64_t)0xFFFFFFFFC0000000L, decodeZigZag64(0x000000007FFFFFFFL), nil);
    STAssertEquals((int64_t)0x000000007FFFFFFFL, decodeZigZag64(0x00000000FFFFFFFEL), nil);
    STAssertEquals((int64_t)0xFFFFFFFF80000000L, decodeZigZag64(0x00000000FFFFFFFFL), nil);
    STAssertEquals((int64_t)0x7FFFFFFFFFFFFFFFL, decodeZigZag64(0xFFFFFFFFFFFFFFFEL), nil);
    STAssertEquals((int64_t)0x8000000000000000L, decodeZigZag64(0xFFFFFFFFFFFFFFFFL), nil);
}


@end