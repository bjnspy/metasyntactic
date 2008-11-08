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

#if 0
#define RETRIEVING NAN
#define NOT_ENOUGH_DATA INFINITY
#define IS_RETRIEVING isnan
#define IS_NOT_ENOUGH_DATA isinf

@interface NumbersCache : NSObject {
    NSLock* gate;
    NSDictionary* indexData;
}

@property (retain) NSLock* gate;
@property (retain) NSDictionary* indexData;

+ (NumbersCache*) cache;

- (void) updateIndex;

- (NSArray*) weekendNumbers;
- (NSArray*) dailyNumbers;

- (double) dailyChange:(MovieNumbers*) movie;
- (double) weekendChange:(MovieNumbers*) movie;
- (double) totalChange:(MovieNumbers*) movie;
- (NSInteger) budgetForMovie:(MovieNumbers*) movie;

@end
#endif