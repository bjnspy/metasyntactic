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

#define UNKNOWN_DISTANCE FLT_MAX

@interface Location : NSObject {
    double latitude;
    double longitude;
    NSString* address;
    NSString* city;
    NSString* state;
    NSString* postalCode;
    NSString* country;
}

@property double latitude;
@property double longitude;
@property (copy) NSString* address;
@property (copy) NSString* city;
@property (copy) NSString* state;
@property (copy) NSString* postalCode;
@property (copy) NSString* country;

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

- (double) distanceTo:(Location*) to;

@end