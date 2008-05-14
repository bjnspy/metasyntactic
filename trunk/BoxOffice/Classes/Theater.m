//
//  Theater.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Theater.h"


@implementation Theater

@synthesize name;
@synthesize address;
@synthesize phoneNumber;
@synthesize movieToShowtimesMap;

- (void) dealloc {
    self.name = nil;
    self.address = nil;
    self.phoneNumber = nil;
    self.movieToShowtimesMap = nil;
    
    [super dealloc];
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithName:[dictionary objectForKey:@"name"]
                            address:[dictionary objectForKey:@"address"]
                        phoneNumber:[dictionary objectForKey:@"phoneNumber"]
                movieToShowtimesMap:[dictionary objectForKey:@"movieToShowtimeMap"]];
}

- (id)         initWithName:(NSString*) aName
                    address:(NSString*) anAddress
                phoneNumber:(NSString*) aPhoneNumber
        movieToShowtimesMap:(NSDictionary*) aDictionary {
    if (self = [self init]) {
        self.name = [aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [anAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.phoneNumber = aPhoneNumber != nil ? aPhoneNumber : @"";
        self.movieToShowtimesMap = aDictionary;
    }
    
    return self;
}

+ (Theater*) theaterWithName:(NSString*) aName
                     address:(NSString*) anAddress
                 phoneNumber:(NSString*) phoneNumber
         movieToShowtimesMap:(NSDictionary*) aDictionary {
    return [[[Theater alloc] initWithName:aName
                                  address:anAddress
                              phoneNumber:phoneNumber
                      movieToShowtimesMap:aDictionary] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.address forKey:@"address"];
    [dictionary setObject:self.phoneNumber forKey:@"phoneNumber"];
    [dictionary setObject:self.movieToShowtimesMap forKey:@"movieToShowtimeMap"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Theater* other = anObject;
    return
        [self.name isEqual:other.name] &&
        [self.address isEqual:other.address] &&
        [self.phoneNumber isEqual:other.phoneNumber] &&
        [self.movieToShowtimesMap isEqual:other.movieToShowtimesMap];
}

- (NSUInteger) hash {
    return
        [self.name hash] +
        [self.address hash] +
        [self.phoneNumber hash] + 
        [self.movieToShowtimesMap hash];
}

@end
