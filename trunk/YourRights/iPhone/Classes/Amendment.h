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

@interface Amendment : NSObject {
@private
    NSString* synopsis;
    NSInteger year;
    NSString* link;
    NSArray* sections;
}

@property (readonly, copy) NSString* synopsis;
@property (readonly) NSInteger year;
@property (readonly, copy) NSString* link;
@property (readonly, retain) NSArray* sections;

+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                text:(NSString*) text;

+ (Amendment*) amendmentWithSynopsis:(NSString*) synopsis
                                year:(NSInteger) year
                                link:(NSString*) link
                                sections:(NSArray*) sections;

@end