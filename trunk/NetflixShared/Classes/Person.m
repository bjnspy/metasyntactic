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

#import "Person.h"

@interface Person()
@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* biography;
@property (copy) NSString* website;
@property (retain) NSDictionary* additionalFields;
@end


@implementation Person

property_definition(identifier);
property_definition(name);
property_definition(biography);
property_definition(website);
property_definition(additionalFields);

- (void) dealloc {
  self.identifier = nil;
  self.name = nil;
  self.biography = nil;
  self.website = nil;
  self.additionalFields = nil;

  [super dealloc];
}


- (id) initWithIdentifier:(NSString*) identifier_
                     name:(NSString*) name_
                biography:(NSString*) biography_
                website:(NSString*) website_
         additionalFields:(NSDictionary*) additionalFields_ {
  if ((self = [super init])) {
    self.identifier = [StringUtilities nonNilString:identifier_];
    self.name = [StringUtilities nonNilString:name_];
    self.biography = [HtmlUtilities removeHtml:[StringUtilities nonNilString:biography_]];
    self.website = [StringUtilities nonNilString:website_];
    self.additionalFields = additionalFields_;
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithIdentifier:[coder decodeObjectForKey:identifier_key]
                             name:[coder decodeObjectForKey:name_key]
                        biography:[coder decodeObjectForKey:biography_key]
                          website:[coder decodeObjectForKey:website_key]
                 additionalFields:[coder decodeObjectForKey:additionalFields_key]];
}


+ (Person*) personWithIdentifier:(NSString*) identifier
                            name:(NSString*) name
                       biography:(NSString*) biography
                         website:(NSString*) website
                additionalFields:(NSDictionary*) additionalFields {
  return [[[Person alloc] initWithIdentifier:identifier
                                        name:name
                                   biography:biography
                                     website:website
                            additionalFields:additionalFields] autorelease];
}


+ (Person*) createWithDictionaryWorker:(NSDictionary*) dictionary {
  return [Person personWithIdentifier:[dictionary objectForKey:identifier_key]
                                 name:[dictionary objectForKey:name_key]
                            biography:[dictionary objectForKey:biography_key]
                              website:[dictionary objectForKey:website_key]
                     additionalFields:[dictionary objectForKey:additionalFields_key]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  [result setObject:identifier        forKey:identifier_key];
  [result setObject:name              forKey:name_key];
  [result setObject:biography         forKey:biography_key];
  [result setObject:website           forKey:website_key];
  [result setObject:additionalFields  forKey:additionalFields_key];
  return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeObject:identifier        forKey:identifier_key];
  [coder encodeObject:name              forKey:name_key];
  [coder encodeObject:biography         forKey:biography_key];
  [coder encodeObject:website           forKey:website_key];
  [coder encodeObject:additionalFields  forKey:additionalFields_key];
}


- (id) copyWithZone:(NSZone*) zone {
  return [self retain];
}


- (NSString*) description {
  return name;
}


- (BOOL) isEqual:(id) anObject {
  Person* other = anObject;

  return [identifier isEqual:other.identifier];
}


- (NSUInteger) hash {
  return identifier.hash;
}

@end
