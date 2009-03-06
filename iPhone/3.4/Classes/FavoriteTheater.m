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

#import "FavoriteTheater.h"

#import "Location.h"

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
    if (self = [super init]) {
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


+ (FavoriteTheater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [FavoriteTheater theaterWithName:[dictionary objectForKey:name_key]
                        originatingLocation:[Location locationWithDictionary:[dictionary objectForKey:originatingLocation_key]]];
}


+ (BOOL) canReadDictionary:(NSDictionary*) dictionary {
    return
    [[dictionary objectForKey:name_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:originatingLocation_key] isKindOfClass:[NSDictionary class]] &&
    [Location canReadDictionary:[dictionary objectForKey:originatingLocation_key]];
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