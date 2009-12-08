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

@interface NetflixUser : AbstractData {
@private
  NSString* firstName;
  NSString* lastName;
  BOOL canInstantWatch;
  NSArray* preferredFormats;
}

@property (readonly, copy) NSString* firstName;
@property (readonly, copy) NSString* lastName;
@property (readonly) BOOL canInstantWatch;
@property (readonly, retain) NSArray* preferredFormats;

+ (NetflixUser*) createWithDictionary:(NSDictionary*) dictionary;
+ (NetflixUser*) userWithFirstName:(NSString*) firstName
                          lastName:(NSString*) lastName
                   canInstantWatch:(BOOL) canInstantWatch
                  preferredFormats:(NSArray*) preferredFormats;

- (BOOL) canBlurayWatch;
- (NSDictionary*) dictionary;

@end
