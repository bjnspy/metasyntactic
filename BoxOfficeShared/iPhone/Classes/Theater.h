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

@interface Theater : AbstractData<NSCoding,MapPoint> {
@private
  NSString* identifier;
  NSString* name;
  NSString* phoneNumber;

  Location* location;
  Location* originatingLocation;

  NSArray* movieTitles;

  NSString* simpleAddress;
}

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* name;
@property (readonly, copy) NSString* phoneNumber;
@property (readonly, retain) Location* location;
@property (readonly, retain) Location* originatingLocation;
@property (readonly, retain) NSArray* movieTitles;

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                       phoneNumber:(NSString*) phoneNumber
                          location:(Location*) location
               originatingLocation:(Location*) originatingLocation
                       movieTitles:(NSArray*) movieTitles;

- (NSString*) simpleAddress;

@end
