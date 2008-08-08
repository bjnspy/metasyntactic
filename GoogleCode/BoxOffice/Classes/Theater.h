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

@interface Theater : NSObject {
    NSString* identifier;
    NSString* name;
    NSString* address;
    NSString* phoneNumber;

    NSString* sellsTickets;
    NSArray* movieIdentifiers;
    
    NSString* originatingPostalCode;
}

@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* address;
@property (copy) NSString* phoneNumber;
@property (copy) NSString* sellsTickets;
@property (copy) NSString* originatingPostalCode;
@property (retain) NSArray* movieIdentifiers;

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           address:(NSString*) address
                       phoneNumber:(NSString*) phoneNumber
                      sellsTickets:(NSString*) sellsTickets
                  movieIdentifiers:(NSArray*) movieIdentifiers
             originatingPostalCode:(NSString*) originatingPostalCode;

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

+ (NSString*) processShowtime:(NSString*) showtime;

@end
