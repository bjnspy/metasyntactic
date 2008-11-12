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

#import "Location.h"

#import "Application.h"
#import "Utilities.h"

@interface Location()
@property double latitude;
@property double longitude;
@property (copy) NSString* address;
@property (copy) NSString* city;
@property (copy) NSString* state;
@property (copy) NSString* postalCode;
@property (copy) NSString* country;
@end


@implementation Location

property_definition(latitude);
property_definition(longitude);
property_definition(address);
property_definition(city);
property_definition(state);
property_definition(postalCode);
property_definition(country);

- (void) dealloc {
    self.latitude = 0;
    self.longitude = 0;
    self.address = nil;
    self.city = nil;
    self.state = nil;
    self.postalCode = nil;
    self.country = nil;

    [super dealloc];
}


- (id) initWithLatitude:(double) latitude_
              longitude:(double) longitude_
                address:(NSString*) address_
                   city:(NSString*) city_
                  state:(NSString*) state_
             postalCode:(NSString*) postalCode_
                country:(NSString*) country_ {
    if (self = [super init]) {
        latitude        = latitude_;
        longitude       = longitude_;
        self.address    = [Utilities nonNilString:address_];
        self.city       = [Utilities nonNilString:city_];
        self.state      = [Utilities nonNilString:state_];
        self.postalCode = [Utilities nonNilString:postalCode_];
        self.country    = [Utilities nonNilString:country_];

        if ([country isEqual:@"US"] && [postalCode rangeOfString:@"-"].length > 0) {
            NSRange range = [postalCode rangeOfString:@"-"];
            self.postalCode = [postalCode substringToIndex:range.location];
        }
    }

    return self;
}


+ (Location*) locationWithDictionary:(NSDictionary*) dictionary {
    return [self locationWithLatitude:[[dictionary objectForKey:latitude_key] doubleValue]
                            longitude:[[dictionary objectForKey:longitude_key] doubleValue]
                              address:[dictionary objectForKey:address_key]
                                 city:[dictionary objectForKey:city_key]
                                state:[dictionary objectForKey:state_key]
                           postalCode:[dictionary objectForKey:postalCode_key]
                              country:[dictionary objectForKey:country_key]];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
                           address:(NSString*) address
                              city:(NSString*) city
                             state:(NSString*) state
                        postalCode:(NSString*) postalCode
                           country:(NSString*) country{
    return [[[Location alloc] initWithLatitude:latitude
                                     longitude:longitude
                                       address:address
                                          city:city
                                         state:state
                                    postalCode:postalCode
                                       country:country] autorelease];
}


+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude {
    return [Location locationWithLatitude:latitude longitude:longitude address:nil city:nil state:nil postalCode:nil country:nil];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:latitude]    forKey:latitude_key];
    [dict setObject:[NSNumber numberWithDouble:longitude]   forKey:longitude_key];
    [dict setObject:address                                 forKey:address_key];
    [dict setObject:city                                    forKey:city_key];
    [dict setObject:state                                   forKey:state_key];
    [dict setObject:postalCode                              forKey:postalCode_key];
    [dict setObject:country                                 forKey:country_key];
    return dict;
}


+ (BOOL) canReadDictionary:(NSDictionary*) dictionary {
    return
    [[dictionary objectForKey:latitude_key] isKindOfClass:[NSNumber class]] &&
    [[dictionary objectForKey:longitude_key] isKindOfClass:[NSNumber class]] &&
    [[dictionary objectForKey:address_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:city_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:state_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:postalCode_key] isKindOfClass:[NSString class]] &&
    [[dictionary objectForKey:country_key] isKindOfClass:[NSString class]];
}


- (double) distanceTo:(Location*) to
        useKilometers:(BOOL) useKilometers {
    const double GREAT_CIRCLE_RADIUS_KILOMETERS = 6371.797;
    const double GREAT_CIRCLE_RADIUS_MILES = 3438.461;

    if (to == nil) {
        return UNKNOWN_DISTANCE;
    }

    double lat1 = (self.latitude / 180) * M_PI;
    double lng1 = (self.longitude / 180) * M_PI;
    double lat2 = (to.latitude / 180) * M_PI;
    double lng2 = (to.longitude / 180) * M_PI;

    double diff = lng1 - lng2;

    if (diff < 0) { diff = -diff; }
    if (diff > M_PI) { diff = 2 * M_PI; }

    double distance =
    acos(sin(lat2) * sin(lat1) +
         cos(lat2) * cos(lat1) * cos(diff));

    if (useKilometers) {
        distance *= GREAT_CIRCLE_RADIUS_KILOMETERS;
    } else {
        distance *= GREAT_CIRCLE_RADIUS_MILES;
    }

    return distance;
}


- (double) distanceTo:(Location*) to {
    return [self distanceTo:to useKilometers:[Application useKilometers]];
}


- (double) distanceToMiles:(Location*) to {
    return [self distanceTo:to useKilometers:NO];
}


- (double) distanceToKilometers:(Location*) to {
    return [self distanceTo:to useKilometers:YES];
}


- (BOOL) isEqual:(id) anObject {
    Location* other = anObject;

    return latitude == other.latitude &&
           longitude == other.longitude;
}


- (NSUInteger) hash {
    double hash = latitude + longitude;

    return *(NSUInteger*)&hash;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"(%d,%d)", latitude, longitude];
}


- (NSString*) fullDisplayString {
    //TODO: switch on Locale here

    if (city.length || state.length || postalCode.length) {
        if (city.length) {
            if (state.length || postalCode.length) {
                return [NSString stringWithFormat:@"%@, %@ %@", city, state, postalCode];
            } else {
                return city;
            }
        } else {
            return [NSString stringWithFormat:@"%@ %@", state, postalCode];
        }
    }

    return @"";
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}


- (NSString*) mapUrl {
    NSString* arguments = [NSString stringWithFormat:@"%@, %@, %@ %@",
            address,
            city,
            state,
            postalCode];

    return [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",
            [Utilities stringByAddingPercentEscapes:arguments]];
}

@end