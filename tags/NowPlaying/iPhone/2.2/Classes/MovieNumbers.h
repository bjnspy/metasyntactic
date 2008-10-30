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
    NSString* identifier;
    NSString* canonicalTitle;
    NSInteger currentRank;
    NSInteger previousRank;
    NSInteger currentGross;
    NSInteger totalGross;
    NSInteger theaters;
    NSInteger days;
}

@property (copy) NSString* identifier;
@property (copy) NSString* canonicalTitle;
@property NSInteger currentRank;
@property NSInteger previousRank;
@property NSInteger currentGross;
@property NSInteger totalGross;
@property NSInteger theaters;
@property NSInteger days;

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