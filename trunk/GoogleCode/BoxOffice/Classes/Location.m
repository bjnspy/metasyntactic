// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Location.h"

@implementation Location

@synthesize latitude;
@synthesize longitude;
@synthesize address;
@synthesize city;

- (void) dealloc {
    self.latitude = 0;
    self.longitude = 0;
    self.address = nil;
    self.city = nil;

    [super dealloc];
}


- (id) initWithLatitude:(double) latitude_
              longitude:(double) longitude_
                address:(NSString*) address_
                   city:(NSString*) city_ {
    if (self = [super init]) {
        latitude = latitude_;
        longitude = longitude_;
        self.address = address_;
        self.city = city_;
    }

    return self;
}


+ (Location*) locationWithDictionary:(NSDictionary*) dictionary {
    return [self locationWithLatitude:[[dictionary objectForKey:@"latitude"] doubleValue]
                            longitude:[[dictionary objectForKey:@"longitude"] doubleValue]
                              address:[dictionary objectForKey:@"address"]
                                 city:[dictionary objectForKey:@"city"]];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
                           address:(NSString*) address
                              city:(NSString*) city {
    return [[[Location alloc] initWithLatitude:latitude
                                     longitude:longitude
                                       address:address
                                          city:city] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dict setObject:address forKey:@"address"];
    [dict setObject:city forKey:@"city"];
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

    if (distance > 200) {
        return UNKNOWN_DISTANCE;
    }

    return distance;
}


- (BOOL) isEqual:(id) anObject {
    Location* other = anObject;

    return
        self.latitude == other.latitude &&
        self.longitude == other.longitude;
}


- (NSUInteger) hash {
    double hash = self.latitude + self.longitude;

    return *(NSUInteger*)&hash;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"(%d,%d)", latitude, longitude];
}


@end
