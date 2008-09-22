// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "LocationUtilities.h"

#import "Location.h"
#import "NetworkUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation LocationUtilities

+ (Location*) findLocationWithGeonames:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = location.coordinate;
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* url = [NSString stringWithFormat:@"http://ws.geonames.org/findNearbyPostalCodes?lat=%f&lng=%f&maxRows=1", latitude, longitude];

    XmlElement* geonamesElement = [NetworkUtilities xmlWithContentsOfAddress:url important:YES];
    XmlElement* codeElement = [geonamesElement element:@"code"];
    NSString* postalCode = [codeElement element:@"postalcode"].text;
    NSString* country = [codeElement element:@"countryCode"].text;

    if (postalCode.length == 0) {
        return nil;
    }
    
    if ([@"CA" isEqual:country]) {
        return nil;
    }

    NSString* city = [codeElement element:@"adminName1"].text;
    NSString* state = [codeElement element:@"adminCode1"].text;
    
    return [Location locationWithLatitude:latitude
                                longitude:longitude
                                  address:@""
                                     city:city
                                    state:state
                               postalCode:postalCode
                                  country:country];
}


+ (Location*) findLocationWithGeocoder:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = location.coordinate;
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* url = [NSString stringWithFormat:@"http://geocoder.ca/?latt=%f&longt=%f&geoit=xml&reverse=Reverse+GeoCode+it", latitude, longitude];

    XmlElement* geodataElement = [NetworkUtilities xmlWithContentsOfAddress:url
                                                                  important:YES];
    NSString* postalCode = [geodataElement element:@"postal"].text;
    if (postalCode.length == 0) {
        return nil;
    }
    
    NSString* city = [geodataElement element:@"city"].text;
    NSString* state = [geodataElement element:@"prov"].text;
    
    return [Location locationWithLatitude:latitude
                                longitude:longitude
                                  address:@""
                                     city:city
                                    state:state
                               postalCode:postalCode
                                  country:@"CA"];
}


+ (Location*) findLocation:(CLLocation*) location {
    Location* result = [self findLocationWithGeonames:location];
    if (result == nil) {
        result = [self findLocationWithGeocoder:location];
    }
    return result;
}

@end