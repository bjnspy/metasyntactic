// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "Theater.h"

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
