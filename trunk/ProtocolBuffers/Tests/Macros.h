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

#define AssertTrue(expr, description, ...) \
do { \
    BOOL _evaluatedExpression = (expr); \
    if (!_evaluatedExpression) { \
        NSString *_expression = [NSString stringWithUTF8String: #expr]; \
        @throw [NSException failureInCondition:_expression \
                                        isTrue:NO \
                                        inFile:[NSString stringWithUTF8String:__FILE__] \
                                        atLine:__LINE__ \
                               withDescription:STComposeString(description, ##__VA_ARGS__)]; \
    } \
} while (0)


#define AssertEqualObjects(a1, a2, description, ...) \
do { \
    id a1value = (a1); \
    id a2value = (a2); \
    if (a1value == a2value) continue; \
    if ( (@encode(__typeof__(a1value)) == @encode(id)) && \
         (@encode(__typeof__(a2value)) == @encode(id)) && \
         [(id)a1value isEqual:(id)a2value] ) continue; \
    @throw [NSException failureInEqualityBetweenObject:a1value \
                                             andObject:a2value \
                                                inFile:[NSString stringWithUTF8String:__FILE__] \
                                                atLine:__LINE__ \
                                       withDescription:STComposeString(description, ##__VA_ARGS__)]; \
} while(0)


#define AssertFalse(expr, description, ...) \
do { \
    BOOL _evaluatedExpression = (expr); \
    if (_evaluatedExpression) { \
        NSString *_expression = [NSString stringWithUTF8String: #expr];\
        @throw [NSException failureInCondition:_expression \
                                        isTrue:YES \
                                        inFile:[NSString stringWithUTF8String:__FILE__] \
                                        atLine:__LINE__ \
                               withDescription:STComposeString(description, ##__VA_ARGS__)]; \
    } \
} while (0)

