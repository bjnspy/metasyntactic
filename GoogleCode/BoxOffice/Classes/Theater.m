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

#import "Theater.h"
#import "Performance.h"
#import "Application.h"
#import "DateUtilities.h"

@implementation Theater

@synthesize identifier;
@synthesize name;
@synthesize address;
@synthesize phoneNumber;
@synthesize sellsTickets;
@synthesize movieIdentifiers;
@synthesize originatingPostalCode;

- (void) dealloc {
    self.identifier = nil;
    self.name = nil;
    self.address = nil;
    self.phoneNumber = nil;
    self.sellsTickets = nil;
    self.movieIdentifiers = nil;
    self.originatingPostalCode = nil;

    [super dealloc];
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithIdentifier:[dictionary objectForKey:@"identifier"]
                                     name:[dictionary objectForKey:@"name"]
                                  address:[dictionary objectForKey:@"address"]
                              phoneNumber:[dictionary objectForKey:@"phoneNumber"]
                             sellsTickets:[dictionary objectForKey:@"sellsTickets"]
                         movieIdentifiers:[dictionary objectForKey:@"movieIdentifiers"]
                    originatingPostalCode:[dictionary objectForKey:@"originatingPostalCode"]];
}

- (id)         initWithIdentifier:(NSString*) identifier_
                             name:(NSString*) name_
                          address:(NSString*) address_
                      phoneNumber:(NSString*) phoneNumber_
                     sellsTickets:(NSString*) sellsTickets_
                 movieIdentifiers:(NSArray*) movieIdentifiers_
            originatingPostalCode:(NSString*) originatingPostalCode_ {
    if (self = [self init]) {
        self.identifier = identifier_;
        self.name = [name_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [address_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.phoneNumber = phoneNumber_ != nil ? phoneNumber_ : @"";
        self.sellsTickets = sellsTickets_;
        self.movieIdentifiers = movieIdentifiers_;
        self.originatingPostalCode = originatingPostalCode_;
    }

    return self;
}

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           address:(NSString*) address
                       phoneNumber:(NSString*) phoneNumber
                      sellsTickets:(NSString*) sellsTickets
                  movieIdentifiers:(NSArray*) movieIdentifiers
             originatingPostalCode:(NSString*) originatingPostalCode{
    return [[[Theater alloc] initWithIdentifier:identifier
                                           name:name
                                        address:address
                                    phoneNumber:phoneNumber
                                   sellsTickets:sellsTickets
                               movieIdentifiers:movieIdentifiers
                          originatingPostalCode:originatingPostalCode] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:identifier            forKey:@"identifier"];
    [dictionary setObject:name                  forKey:@"name"];
    [dictionary setObject:address               forKey:@"address"];
    [dictionary setObject:phoneNumber           forKey:@"phoneNumber"];
    [dictionary setObject:sellsTickets          forKey:@"sellsTickets"];
    [dictionary setObject:movieIdentifiers      forKey:@"movieIdentifiers"];
    [dictionary setObject:originatingPostalCode forKey:@"originatingPostalCode"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Theater* other = anObject;
    return
        [self.identifier isEqual:other.identifier] &&
        [self.name isEqual:other.name];
}

- (NSUInteger) hash {
    return
        [self.identifier hash] +
        [self.name hash];
}

+ (NSString*) processShowtime:(NSString*) showtime {
    if ([showtime hasSuffix:@" PM"]) {
        return [NSString stringWithFormat:@"%@pm", [showtime substringToIndex:[showtime length] - 3]];
    } else if ([showtime hasSuffix:@" AM"]) {
        return [NSString stringWithFormat:@"%@am", [showtime substringToIndex:[showtime length] - 3]];
    }

    return showtime;
}

@end