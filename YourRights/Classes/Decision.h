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

typedef enum {
    FreedomOfAssociation,
    FreedomOfThePress,
    FreedomOfExpression,
    EqualityUnderTheLaw,
    RightToFairProcedures,
    RightToPrivacy,
    ChecksAndBalances,
    SeparationOfChurchAndState,
    FreeExerciseOfReligion,
} Category;

@interface Decision : NSObject {
@private
    NSInteger year;
    Category category;
    NSString* title;
    NSString* synopsis;
    NSString* link;
}

@property (readonly) NSInteger year;
@property (readonly) Category category;
@property (readonly, retain) NSString* title;
@property (readonly, retain) NSString* synopsis;
@property (readonly, retain) NSString* link;

+ (Decision*) decisionWithYear:(NSInteger) year
                      category:(Category) category
                         title:(NSString*) title
                      synopsis:(NSString*) synopsis
                          link:(NSString*) link;

+ (NSArray*) greatestHits;

@end
