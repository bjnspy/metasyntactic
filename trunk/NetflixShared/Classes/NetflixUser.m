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

#import "NetflixUser.h"

@interface NetflixUser()
@property (copy) NSString* firstName;
@property (copy) NSString* lastName;
@property BOOL canInstantWatch;
@property (retain) NSArray* preferredFormats;
@end


@implementation NetflixUser

property_definition(firstName);
property_definition(lastName);
property_definition(canInstantWatch);
property_definition(preferredFormats);

- (void) dealloc {
  self.firstName = nil;
  self.lastName = nil;
  self.canInstantWatch = NO;
  self.preferredFormats = nil;
  [super dealloc];
}


- (id) initWithFirstName:(NSString*) firstName_
                lastName:(NSString*) lastName_
         canInstantWatch:(BOOL) canInstantWatch_
        preferredFormats:(NSArray*) preferredFormats_ {
  if ((self = [super init])) {
    self.firstName = firstName_;
    self.lastName = lastName_;
    self.canInstantWatch = canInstantWatch_;
    self.preferredFormats = preferredFormats_;
  }

  return self;
}


+ (NetflixUser*) userWithFirstName:(NSString*) firstName
                          lastName:(NSString*) lastName
                   canInstantWatch:(BOOL) canInstantWatch
                  preferredFormats:(NSArray*) preferredFormats {
  return [[[NetflixUser alloc] initWithFirstName:firstName
                                        lastName:lastName
                                 canInstantWatch:canInstantWatch
                                preferredFormats:preferredFormats] autorelease];
}


+ (NetflixUser*) newWithDictionary:(NSDictionary*) dictionary {
  return [self userWithFirstName:[dictionary objectForKey:firstName_key]
                        lastName:[dictionary objectForKey:lastName_key]
                 canInstantWatch:[[dictionary objectForKey:canInstantWatch_key] boolValue]
                preferredFormats:[dictionary objectForKey:preferredFormats_key]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:firstName forKey:firstName_key];
  [dictionary setObject:lastName forKey:lastName_key];
  [dictionary setObject:[NSNumber numberWithBool:canInstantWatch] forKey:canInstantWatch_key];
  [dictionary setObject:preferredFormats forKey:preferredFormats_key];
  return dictionary;
}

@end
