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

#define UNKNOWN_DISTANCE FLT_MAX

@interface Location : NSObject<NSCopying, NSCoding> {
@private
  double latitude;
  double longitude;
  NSString* address;
  NSString* city;
  NSString* state;
  NSString* postalCode;
  NSString* country;
}

@property (readonly) double latitude;
@property (readonly) double longitude;
@property (readonly, copy) NSString* address;
@property (readonly, copy) NSString* city;
@property (readonly, copy) NSString* state;
@property (readonly, copy) NSString* postalCode;
@property (readonly, copy) NSString* country;

+ (Location*) locationWithDictionary:(NSDictionary*) dictionary;
+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude;
+ (Location*) locationWithLatitude:(double) latitude
                         longitude:(double) longitude
                           address:(NSString*) address
                              city:(NSString*) city
                             state:(NSString*) state
                        postalCode:(NSString*) postalCode
                           country:(NSString*) country;

- (NSDictionary*) dictionary;

- (NSString*) mapUrl;

- (double) distanceTo:(Location*) to;
- (double) distanceToMiles:(Location*) to;
- (double) distanceToKilometers:(Location*) to;

- (NSString*) fullDisplayString;

- (CLLocationCoordinate2D) coordinate;

+ (double) distanceFrom:(CLLocationCoordinate2D) from to:(CLLocationCoordinate2D) to useKilometers:(BOOL) useKilometers;

@end
