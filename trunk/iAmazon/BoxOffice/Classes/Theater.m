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

- (id) initWithName:(NSString*) aName
            address:(NSString*) anAddress
movieToShowtimesMap:(NSDictionary*) aDictionary
{
    if (self = [self init])
    {
        self.name = aName;
        self.address = anAddress;
        self.movieToShowtimesMap = aDictionary;
    }
    
    return self;
}

- (id) initWithDictionary:(NSDictionary*) dictionary
{
    return [self initWithName:[dictionary objectForKey:@"name"]
                      address:[dictionary objectForKey:@"address"]
          movieToShowtimesMap:[dictionary objectForKey:@"movieToShowtimeMap"]];
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.address forKey:@"address"];
    [dictionary setValue:self.movieToShowtimesMap forKey:@"movieToShowtimeMap"];
    return dictionary;
}

@end
