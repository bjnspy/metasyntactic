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

#import "FavoriteTheater.h"

@interface FavoriteTheater()
@property (copy) NSString* name;
@property (retain) Location* originatingLocation;
@end


@implementation FavoriteTheater

property_definition(name);
property_definition(originatingLocation);

- (void) dealloc {
  self.name = nil;
  self.originatingLocation = nil;

  [super dealloc];
}


- (id)       initWithName:(NSString*) name_
      originatingLocation:(Location*) originatingLocation_ {
  if ((self = [super init])) {
    self.name = name_;
    self.originatingLocation = originatingLocation_;
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithName:[coder decodeObjectForKey:name_key]
        originatingLocation:[coder decodeObjectForKey:originatingLocation_key]];
}


+ (FavoriteTheater*) theaterWithName:(NSString*) name
                 originatingLocation:(Location*) originatingLocation {
  return [[[FavoriteTheater alloc] initWithName:name
                            originatingLocation:originatingLocation] autorelease];
}


+ (FavoriteTheater*) createWithDictionaryWorker:(NSDictionary*) dictionary {
  return [FavoriteTheater theaterWithName:[dictionary objectForKey:name_key]
                      originatingLocation:[Location locationWithDictionary:[dictionary objectForKey:originatingLocation_key]]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  [result setObject:name                              forKey:name_key];
  [result setObject:originatingLocation.dictionary    forKey:originatingLocation_key];
  return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeObject:name                forKey:name_key];
  [coder encodeObject:originatingLocation forKey:originatingLocation_key];
}


- (id) copyWithZone:(NSZone*) zone {
  return [self retain];
}


- (NSString*) description {
  return self.dictionary.description;
}


- (BOOL) isEqual:(id) anObject {
  FavoriteTheater* other = anObject;
  return [name isEqual:other.name];
}


- (NSUInteger) hash {
  return name.hash;
}

@end
