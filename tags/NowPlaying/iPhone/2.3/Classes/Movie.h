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

@interface Movie : NSObject<NSCopying> {
@private
    NSString* identifier;
    NSString* canonicalTitle;
    NSString* rating;
    NSInteger length; // minutes;
    NSDate* releaseDate;
    NSString* imdbAddress;
    NSString* poster;
    NSString* synopsis;
    NSString* studio;
    NSArray* directors;
    NSArray* cast;
    NSArray* genres;

    NSString* displayTitle;
}

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* displayTitle;
@property (readonly, copy) NSString* rating;
@property (readonly) NSInteger length;
@property (readonly, copy) NSString* imdbAddress;
@property (readonly, copy) NSString* poster;
@property (readonly, copy) NSString* synopsis;
@property (readonly, copy) NSString* studio;
@property (readonly, retain) NSDate* releaseDate;
@property (readonly, retain) NSArray* directors;
@property (readonly, retain) NSArray* cast;
@property (readonly, retain) NSArray* genres;

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary;
+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSInteger) length
                   releaseDate:(NSDate*) releaseDate
                   imdbAddress:(NSString*) imdbAddress
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres;

- (NSDictionary*) dictionary;

- (BOOL) isUnrated;
- (NSString*) ratingString;
- (NSString*) runtimeString;
- (NSString*) ratingAndRuntimeString;

+ (NSString*) makeCanonical:(NSString*) title;
+ (NSString*) makeDisplay:(NSString*) title;

@end