// Copyright 2010 Cyrus Najmabadi
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
#import "XmlElement.h"

@implementation LocationUtilities

+ (Location*) findLocationWithGeonames:(CLLocation*) location {
  CLLocationCoordinate2D coordinates = location.coordinate;
  double latitude = coordinates.latitude;
  double longitude = coordinates.longitude;
  NSString* url = [NSString stringWithFormat:@"http://ws5.geonames.org/findNearbyPostalCodes?lat=%f&lng=%f&maxRows=1", latitude, longitude];

  XmlElement* geonamesElement = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];
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

  XmlElement* geodataElement = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];
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


+ (Location*) findLocationWithGoogle:(CLLocation*) location {
  CLLocationCoordinate2D coordinates = location.coordinate;
  double latitude = coordinates.latitude;
  double longitude = coordinates.longitude;
  NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f,%f&output=xml&oe=utf8&sensor=false&key=ABQIAAAAE33gn89pf9QC1N10Oi1IxBTjs0lgCCfZJx1z0ucxfREoQjAihRQgAaDiNU3GwvKqQjMaH59qEdSkAg", latitude, longitude];

  XmlElement* kmlElement = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];

  NSString* postalCode = [[kmlElement element:@"PostalCodeNumber" recurse:YES] text];

  if (postalCode.length == 0) {
    return nil;
  }

  NSString* country = [[kmlElement element:@"CountryNameCode" recurse:YES] text];
  NSString* state = [[kmlElement element:@"AdministrativeAreaName" recurse:YES] text];
  NSString* city = [[kmlElement element:@"SubAdministrativeAreaName" recurse:YES] text];
  NSString* locality = [[kmlElement element:@"LocalityName" recurse:YES] text];

  return  [Location locationWithLatitude:latitude
                               longitude:longitude
                                 address:@""
                                    city:city.length > 0 ? city : locality
                                   state:state
                              postalCode:postalCode
                                 country:country];
}


+ (Location*) findLocation:(CLLocation*) location {
  Location* result = [self findLocationWithGoogle:location];
  if (result != nil) {
    return result;
  }

  result = [self findLocationWithGeonames:location];
  if (result != nil) {
    return result;
  }

  result = [self findLocationWithGeocoder:location];
  if (result != nil) {
    return result;
  }

  return nil;
}

@end
