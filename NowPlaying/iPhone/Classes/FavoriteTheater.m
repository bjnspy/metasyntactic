// Copyright (C) 2008 Cyrus Najmabadi
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


@implementation FavoriteTheater

property_definition(name);
property_definition(originatingPostalCode);

- (void) dealloc {
    self.name = nil;
    self.originatingPostalCode = nil;

    [super dealloc];
}


- (id)         initWithName:(NSString*) name_
      originatingPostalCode:(NSString*) originatingPostalCode_ {
    if (self = [super init]) {
        self.name = name_;
        self.originatingPostalCode = originatingPostalCode_;
    }

    return self;
}


+ (FavoriteTheater*) theaterWithName:(NSString*) name
               originatingPostalCode:(NSString*) originatingPostalCode {
    return [[[FavoriteTheater alloc] initWithName:name
                            originatingPostalCode:originatingPostalCode] autorelease];
}


+ (FavoriteTheater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [FavoriteTheater theaterWithName:[dictionary objectForKey:name_key]
                      originatingPostalCode:[dictionary objectForKey:originatingPostalCode_key]];
}


+ (BOOL) canReadDictionary:(NSDictionary*) dictionary {
    return
    [[dictionary objectForKey:name_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:originatingPostalCode_key] isKindOfClass:[NSString class]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:name                  forKey:name_key];
    [result setObject:originatingPostalCode forKey:originatingPostalCode_key];
    return result;
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