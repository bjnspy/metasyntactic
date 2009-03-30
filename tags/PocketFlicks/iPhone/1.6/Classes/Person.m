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

#import "Person.h"

#import "StringUtilities.h"

@interface Person()
@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* biography;
@property (retain) NSDictionary* additionalFields;
@end


@implementation Person

property_definition(identifier);
property_definition(name);
property_definition(biography);
property_definition(additionalFields);

- (void) dealloc {
    self.identifier = nil;
    self.name = nil;
    self.biography = nil;
    self.additionalFields = nil;

    [super dealloc];
}


- (id) initWithIdentifier:(NSString*) identifier_
                            name:(NSString*) name_
                       biography:(NSString*) biography_
         additionalFields:(NSDictionary*) additionalFields_ {
    if (self = [super init]) {
        self.identifier = [StringUtilities nonNilString:identifier_];
        self.name = [StringUtilities nonNilString:name_];
        self.biography = [StringUtilities nonNilString:biography_];
        self.additionalFields = additionalFields_;
    }

    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithIdentifier:[coder decodeObjectForKey:identifier_key]
                               name:[coder decodeObjectForKey:name_key]
                          biography:[coder decodeObjectForKey:biography_key]
                   additionalFields:[coder decodeObjectForKey:additionalFields_key]];
}


+ (Person*) personWithIdentifier:(NSString*) identifier
                            name:(NSString*) name
                       biography:(NSString*) biography
                additionalFields:(NSDictionary*) additionalFields {
    return [[[Person alloc] initWithIdentifier:identifier
                                          name:name
                                     biography:biography
                              additionalFields:additionalFields] autorelease];
}


+ (Person*) personWithDictionary:(NSDictionary*) dictionary {
    return [Person personWithIdentifier:[dictionary objectForKey:identifier_key]
                                   name:[dictionary objectForKey:name_key]
                              biography:[dictionary objectForKey:biography_key]
                       additionalFields:[dictionary objectForKey:additionalFields_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:identifier        forKey:identifier_key];
    [result setObject:name              forKey:name_key];
    [result setObject:biography         forKey:biography_key];
    [result setObject:additionalFields  forKey:additionalFields_key];
    return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:identifier        forKey:identifier_key];
    [coder encodeObject:name              forKey:name_key];
    [coder encodeObject:biography         forKey:biography_key];
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