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

@interface DVD : NSObject {
@private
    NSString* canonicalTitle;
    NSString* price;
    NSString* format;
    NSString* discs;
    NSString* url;
}

@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* price;
@property (readonly, copy) NSString* format;
@property (readonly, copy) NSString* discs;
@property (readonly, copy) NSString* url;

+ (DVD*) dvdWithDictionary:(NSDictionary*) dictionary;
+ (DVD*) dvdWithTitle:(NSString*) title
                price:(NSString*) price
               format:(NSString*) format
                discs:(NSString*) discs
                  url:(NSString*) url;

- (NSDictionary*) dictionary;

@end