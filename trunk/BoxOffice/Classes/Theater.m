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
@synthesize movieToShowtimesMap;

- (void) dealloc
{
    self.name = nil;
    self.address = nil;
    self.movieToShowtimesMap = nil;
    
    [super dealloc];
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary
{
    return [Theater theaterWithName:[dictionary objectForKey:@"name"]
                            address:[dictionary objectForKey:@"address"]
                movieToShowtimesMap:[dictionary objectForKey:@"movieToShowtimeMap"]];
}

+ (Theater*) theaterWithName:(NSString*) aName
                     address:(NSString*) anAddress
         movieToShowtimesMap:(NSDictionary*) aDictionary
{
    return [[[Theater alloc] initWithName:aName address:anAddress movieToShowtimesMap:aDictionary] autorelease];
}

- (id) initWithName:(NSString*) aName
            address:(NSString*) anAddress
movieToShowtimesMap:(NSDictionary*) aDictionary
{
    if (self = [self init])
    {
        self.name = [aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [anAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.movieToShowtimesMap = aDictionary;
    }
    
    return self;
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.address forKey:@"address"];
    [dictionary setValue:self.movieToShowtimesMap forKey:@"movieToShowtimeMap"];
    return dictionary;
}

- (NSString*) description
{
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject
{
    Theater* other = anObject;
    return
        [self.name isEqual:other.name] &&
        [self.address isEqual:other.address] &&
        [self.movieToShowtimesMap isEqual:other.movieToShowtimesMap];
}

- (NSUInteger) hash
{
    return [self.name hash] + [self.address hash] + [self.movieToShowtimesMap hash];
}

@end
