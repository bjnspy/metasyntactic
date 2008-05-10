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
              longitude:(double) lng {
    if (self = [super init]) {
        latitude = lat;
        longitude = lng;
    }
    
    return self;
}

+ (Location*) locationWithDictionary:(NSDictionary*) dictionary {
    return [self locationWithLatitude:[[dictionary valueForKey:@"latitude"] doubleValue]
                            longitude:[[dictionary valueForKey:@"longitude"] doubleValue]];
}

+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude {
    return [[[Location alloc] initWithLatitude:latitude longitude:longitude] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    return dict;
}

- (double) distanceTo:(Location*) to {
    const double GREAT_CIRCLE_RADIUS_MILES = 3438.461;
    const double pi = 3.14159265358979323846;
    
    if (to == nil) {
        return UNKNOWN_DISTANCE;
    }
    
    double lat1 = (self.latitude / 180) * pi;
    double lng1 = (self.longitude / 180) * pi;
    double lat2 = (to.latitude / 180) * pi;
    double lng2 = (to.longitude / 180) * pi;
    
    double diff = lng1 - lng2;
    
    if (diff < 0) { diff = -diff; }
    if (diff > pi) { diff = 2 * pi; }
    
    double distance =
    GREAT_CIRCLE_RADIUS_MILES *
    acos(sin(lat2) * sin(lat1) +
         cos(lat2) * cos(lat1) * cos(diff));
    
    return distance;
}

@end
