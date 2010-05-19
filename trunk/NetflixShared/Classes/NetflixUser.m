// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NetflixUser.h"

#import "NetflixCache.h"
#import "NetflixConstants.h"

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


+ (NetflixUser*) createWithDictionaryWorker:(NSDictionary*) dictionary {
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


- (BOOL) canBlurayWatch {
  return [preferredFormats containsObject:[NetflixConstants blurayFormat]];
}

@end
