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

@interface Theater : NSObject {
    NSString* identifier;
    NSString* name;
    NSString* phoneNumber;

    Location* location;
    Location* originatingLocation;

    NSArray* movieTitles;
}

@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* phoneNumber;
@property (retain) Location* location;
@property (retain) Location* originatingLocation;
@property (retain) NSArray* movieTitles;

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                       phoneNumber:(NSString*) phoneNumber
                          location:(Location*) location
               originatingLocation:(Location*) originatingLocation
                       movieTitles:(NSArray*) movieTitles;

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;
- (NSString*) mapUrl;

+ (NSString*) processShowtime:(NSString*) showtime;

@end