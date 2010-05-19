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

#import "Theater.h"

@interface Theater()
@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* phoneNumber;
@property (retain) Location* location;
@property (retain) Location* originatingLocation;
@property (retain) NSArray* movieTitles;
@property (copy) NSString* simpleAddress;
@end


@implementation Theater

property_definition(identifier);
property_definition(name);
property_definition(phoneNumber);
property_definition(location);
property_definition(originatingLocation);
property_definition(movieTitles);
@synthesize simpleAddress;

- (void) dealloc {
  self.identifier = nil;
  self.name = nil;
  self.phoneNumber = nil;
  self.location = nil;
  self.originatingLocation = nil;
  self.movieTitles = nil;
  self.simpleAddress = nil;

  [super dealloc];
}


+ (Theater*) createWithDictionaryWorker:(NSDictionary*) dictionary {
  return [Theater theaterWithIdentifier:[dictionary objectForKey:identifier_key]
                                   name:[dictionary objectForKey:name_key]
                            phoneNumber:[dictionary objectForKey:phoneNumber_key]
                               location:[Location locationWithDictionary:[dictionary objectForKey:location_key]]
                    originatingLocation:[Location locationWithDictionary:[dictionary objectForKey:originatingLocation_key]]
                            movieTitles:[dictionary objectForKey:movieTitles_key]];
}


- (id) initWithIdentifier:(NSString*) identifier_
                     name:(NSString*) name_
              phoneNumber:(NSString*) phoneNumber_
                 location:(Location*) location_
      originatingLocation:(Location*) originatingLocation_
              movieTitles:(NSArray*) movieTitles_ {
  if ((self = [super init])) {
    self.identifier = [StringUtilities nonNilString:identifier_];
    self.name = [[StringUtilities nonNilString:name_] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.phoneNumber = [StringUtilities nonNilString:phoneNumber_];
    self.location = location_;
    self.originatingLocation = originatingLocation_;
    self.movieTitles = [CollectionUtilities nonNilArray:movieTitles_];
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithIdentifier:[coder decodeObjectForKey:identifier_key]
                             name:[coder decodeObjectForKey:name_key]
                      phoneNumber:[coder decodeObjectForKey:phoneNumber_key]
                         location:[coder decodeObjectForKey:location_key]
              originatingLocation:[coder decodeObjectForKey:originatingLocation_key]
                      movieTitles:[coder decodeObjectForKey:movieTitles_key]];
}


+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                       phoneNumber:(NSString*) phoneNumber
                          location:(Location*) location
               originatingLocation:(Location*) originatingLocation
                       movieTitles:(NSArray*) movieTitles {
  return [[[Theater alloc] initWithIdentifier:identifier
                                         name:name
                                  phoneNumber:phoneNumber
                                     location:location
                          originatingLocation:originatingLocation
                                  movieTitles:movieTitles] autorelease];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:identifier                        forKey:identifier_key];
  [dictionary setObject:name                              forKey:name_key];
  [dictionary setObject:phoneNumber                       forKey:phoneNumber_key];
  [dictionary setObject:location.dictionary               forKey:location_key];
  [dictionary setObject:originatingLocation.dictionary    forKey:originatingLocation_key];
  [dictionary setObject:movieTitles                       forKey:movieTitles_key];
  return dictionary;
}


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeObject:identifier          forKey:identifier_key];
  [coder encodeObject:name                forKey:name_key];
  [coder encodeObject:phoneNumber         forKey:phoneNumber_key];
  [coder encodeObject:location            forKey:location_key];
  [coder encodeObject:originatingLocation forKey:originatingLocation_key];
  [coder encodeObject:movieTitles         forKey:movieTitles_key];
}


- (NSString*) description {
  return self.dictionary.description;
}


- (BOOL) isEqual:(id) anObject {
  if (self == anObject) {
    return YES;
  }

  if (![anObject isKindOfClass:[Theater class]]) {
    return NO;
  }

  Theater* other = anObject;
  return [name isEqual:other.name];
}


- (NSUInteger) hash {
  return name.hash;
}


- (NSString*) mapUrl {
  return location.mapUrl;
}


- (NSString*) simpleAddressWorker {
  if (location.address.length != 0 && location.city.length != 0) {
    return [NSString stringWithFormat:@"%@, %@", location.address, location.city];
  } else {
    return location.address;
  }
}


- (NSString*) simpleAddress {
  if (simpleAddress == nil) {
    self.simpleAddress = [self simpleAddressWorker];
  }

  return simpleAddress;
}


- (CLLocationCoordinate2D) coordinate {
  return location.coordinate;
}


- (NSString*) title {
  return name;
}


- (NSString*) subtitle {
  return location.address;
}

@end
