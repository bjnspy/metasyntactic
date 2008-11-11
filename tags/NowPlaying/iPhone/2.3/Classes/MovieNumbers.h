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

@interface MovieNumbers : NSObject {
@private
    NSString* identifier;
    NSString* canonicalTitle;
    NSInteger currentRank;
    NSInteger previousRank;
    NSInteger currentGross;
    NSInteger totalGross;
    NSInteger theaters;
    NSInteger days;
}

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* canonicalTitle;
@property (readonly) NSInteger currentRank;
@property (readonly) NSInteger previousRank;
@property (readonly) NSInteger currentGross;
@property (readonly) NSInteger totalGross;
@property (readonly) NSInteger theaters;
@property (readonly) NSInteger days;

+ (MovieNumbers*) numbersWithDictionary:(NSDictionary*) dictionary;
+ (MovieNumbers*) numbersWithIdentifier:(NSString*) identifier
                                  title:(NSString*) title
                            currentRank:(NSInteger) currentRank
                           previousRank:(NSInteger) previousRank
                           currentGross:(NSInteger) currentGross
                             totalGross:(NSInteger) totalGross
                               theaters:(NSInteger) theaters
                                   days:(NSInteger) days;

- (NSDictionary*) dictionary;


@end