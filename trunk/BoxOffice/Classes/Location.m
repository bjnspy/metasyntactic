//
//  Location.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize latitude;
@synthesize longitude;

- (id) initWithLatitude:(double) lat
              longitude:(double) lng
{
    if (self = [super init])
    {
        latitude = lat;
        longitude = lng;
    }
    
    return self;
}

+ (Location*) locationWithDictionary:(NSDictionary*) dictionary
{
    return [self locationWithLatitude:[[dictionary valueForKey:@"latitude"] doubleValue]
                            longitude:[[dictionary valueForKey:@"longitude"] doubleValue]];
}

+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
{
    return [[[Location alloc] initWithLatitude:latitude longitude:longitude] autorelease];
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    return dict;
}

@end
