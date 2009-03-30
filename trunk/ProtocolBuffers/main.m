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

#import <SenTestingKit/SenTestingKit.h>

#import "CodedInputStreamTests.h"
#import "CodedOuputStreamTests.h"
#import "CoreTests.h"
#import "DescriptorTests.h"
#import "GeneratedMessageTests.h"
#import "MessageTests.h"
#import "UnknownFieldSetTest.h"
#import "UtilitiesTests.h"
#import "WireFormatTests.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    [SenTestObserver class];

    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[CodedInputStreamTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[CoreTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[DescriptorTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[GeneratedMessageTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[MessageTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[UnknownFieldSetTest class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[UtilitiesTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[WireFormatTests class]] run];
    [(SenTestSuite*)[SenTestSuite testSuiteForTestCaseClass:[CodedOutputStreamTests class]] run];

    [pool release];
    return 0;
}