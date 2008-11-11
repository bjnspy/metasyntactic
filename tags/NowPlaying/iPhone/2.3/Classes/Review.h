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

@interface Review : NSObject {
@private
    NSInteger score;
    NSString* link;
    NSString* text;
    NSString* author;
    NSString* source;
}

@property (readonly) NSInteger score;
@property (readonly, copy) NSString* link;
@property (readonly, copy) NSString* text;
@property (readonly, copy) NSString* author;
@property (readonly, copy) NSString* source;

+ (Review*) reviewWithText:(NSString*) text
                     score:(NSInteger) score
                      link:(NSString*) link
                    author:(NSString*) author
                    source:(NSString*) source;

+ (Review*) reviewWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

@end