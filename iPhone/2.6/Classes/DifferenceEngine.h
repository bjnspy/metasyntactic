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

@interface DifferenceEngine : NSObject {
@private
    NSInteger addCost;
    NSInteger deleteCost;
    NSInteger switchCost;
    NSInteger transposeCost;

    NSInteger costTable[128][128];

    NSInteger cached_S_length;
    NSInteger cached_T_length;

    NSInteger costThreshold;
}

+ (DifferenceEngine*) engine;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold;

- (BOOL) similar:(NSString*) s1
           other:(NSString*) s2;

+ (BOOL) areSimilar:(NSString*) s1
              other:(NSString*) s2;


- (NSInteger) findClosestMatchIndex:(NSString*) string
                            inArray:(NSArray*) array;
- (NSString*) findClosestMatch:(NSString*) string
                       inArray:(NSArray*) array;

@end