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

#import "NetworkUtilities.h"
#import "XmlElement.h"

@implementation LocationUtilities

+ (NSString*) findUSPostalCode:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = location.coordinate;
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* url = [NSString stringWithFormat:@"http://ws.geonames.org/findNearbyPostalCodes?lat=%f&lng=%f&maxRows=1", latitude, longitude];

    XmlElement* geonamesElement = [NetworkUtilities xmlWithContentsOfAddress:url important:YES];
    XmlElement* codeElement = [geonamesElement element:@"code"];
    XmlElement* postalElement = [codeElement element:@"postalcode"];
    XmlElement* countryElement = [codeElement element:@"countryCode"];

    if ([@"CA" isEqual:countryElement.text]) {
        return nil;
    }

    return postalElement.text;
}


+ (NSString*) findCAPostalCode:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = location.coordinate;
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* url = [NSString stringWithFormat:@"http://geocoder.ca/?latt=%f&longt=%f&geoit=xml&reverse=Reverse+GeoCode+it", latitude, longitude];

    XmlElement* geodataElement = [NetworkUtilities xmlWithContentsOfAddress:url
                                                                  important:YES];
    XmlElement* postalElement = [geodataElement element:@"postal"];
    return postalElement.text;
}


+ (NSString*) findPostalCode:(CLLocation*) location {
    NSString* postalCode = [self findUSPostalCode:location];
    if (postalCode == nil) {
        postalCode = [self findCAPostalCode:location];
    }
    return postalCode;
}

@end