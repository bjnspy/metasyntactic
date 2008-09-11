//
//  FavoriteTheater.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 9/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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
