// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "Location.h"

@implementation Location

@synthesize latitude;
@synthesize longitude;
@synthesize address;
@synthesize city;
@synthesize country;

- (void) dealloc {
    self.latitude = 0;
    self.longitude = 0;
    self.address = nil;
    self.city = nil;
    self.country = nil;

    [super dealloc];
}


- (id) initWithLatitude:(double) latitude_
              longitude:(double) longitude_
                address:(NSString*) address_
                   city:(NSString*) city_
                country:(NSString*) country_ {
    if (self = [super init]) {
        latitude = latitude_;
        longitude = longitude_;
        self.address = address_;
        self.city = city_;
        self.country = country_;
    }

    return self;
}


+ (Location*) locationWithDictionary:(NSDictionary*) dictionary {
    return [self locationWithLatitude:[[dictionary objectForKey:@"latitude"] doubleValue]
                            longitude:[[dictionary objectForKey:@"longitude"] doubleValue]
                              address:[dictionary objectForKey:@"address"]
                                 city:[dictionary objectForKey:@"city"]
                              country:[dictionary objectForKey:@"country"]];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
                           address:(NSString*) address
                              city:(NSString*) city
                           country:(NSString*) country{
    return [[[Location alloc] initWithLatitude:latitude
                                     longitude:longitude
                                       address:address
                                          city:city
                                       country:country] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [dict setObject:address forKey:@"address"];
    [dict setObject:city forKey:@"city"];
    [dict setObject:country forKey:@"country"];
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
