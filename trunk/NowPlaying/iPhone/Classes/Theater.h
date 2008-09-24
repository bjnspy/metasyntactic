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

@interface Theater : NSObject {
    NSString* identifier;
    NSString* name;
    NSString* phoneNumber;
    
    Location* location;
    Location* originatingLocation;
    
    NSArray* movieTitles;
}

@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* phoneNumber;
@property (retain) Location* location;
@property (retain) Location* originatingLocation;
@property (retain) NSArray* movieTitles;

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                       phoneNumber:(NSString*) phoneNumber
                          location:(Location*) location
               originatingLocation:(Location*) originatingLocation
                       movieTitles:(NSArray*) movieTitles;

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;
- (NSString*) mapUrl;

+ (NSString*) processShowtime:(NSString*) showtime;

@end