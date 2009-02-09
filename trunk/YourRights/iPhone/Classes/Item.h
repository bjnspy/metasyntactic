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

@interface Item : NSObject<NSCopying,NSCoding> {
@private
    NSString* title;
    NSString* link;
    NSString* description;
    NSString* date;
    NSString* author;
}

@property (readonly, copy) NSString* title;
@property (readonly, copy) NSString* link;
@property (readonly, copy) NSString* description;
@property (readonly, copy) NSString* date;
@property (readonly, copy) NSString* author;

+ (Item*) itemWithDictionary:(NSDictionary*) dictionary;
+ (Item*) itemWithTitle:(NSString*) title
                   link:(NSString*) link
            description:(NSString*) description
                   date:(NSString*) date
                 author:(NSString*) author;

- (NSDictionary*) dictionary;

@end