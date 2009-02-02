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

@interface Score : NSObject<NSCopying, NSCoding> {
@private
    NSString* canonicalTitle;
    NSString* synopsis;
    NSString* score;
    NSString* provider;
    NSString* identifier;
}

@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* synopsis;
@property (readonly, copy) NSString* score;
@property (readonly, copy) NSString* provider;
@property (readonly, copy) NSString* identifier;

+ (Score*) scoreWithDictionary:(NSDictionary*) dictionary;
+ (Score*) scoreWithTitle:(NSString*) title
                 synopsis:(NSString*) synopsis
                    score:(NSString*) score
                 provider:(NSString*) provider
               identifier:(NSString*) identifier;

- (NSDictionary*) dictionary;

- (NSInteger) scoreValue;

@end