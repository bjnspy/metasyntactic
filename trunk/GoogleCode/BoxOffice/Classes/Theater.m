//
//  Theater.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

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

- (void) dealloc {
    self.identifier = nil;
    self.name = nil;
    self.address = nil;
    self.phoneNumber = nil;
    self.sellsTickets = nil;
    self.movieIdentifiers = nil;
    
    [super dealloc];
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithIdentifier:[dictionary objectForKey:@"identifier"]
                                     name:[dictionary objectForKey:@"name"]
                                  address:[dictionary objectForKey:@"address"]
                              phoneNumber:[dictionary objectForKey:@"phoneNumber"]
                             sellsTickets:[dictionary objectForKey:@"sellsTickets"]
                              movieIdentifiers:[dictionary objectForKey:@"movieIdentifiers"]];
}

NSComparisonResult compareDateStrings(id t1, id t2, void* context) {
    NSString* s1 = t1;
    NSString* s2 = t2;
    
    NSDate* d1 = [DateUtilities dateWithNaturalLanguageString:s1];
    NSDate* d2 = [DateUtilities dateWithNaturalLanguageString:s2];
    
    return [d1 compare:d2];
}

- (id)         initWithIdentifier:(NSString*) identifier_
                             name:(NSString*) name_
                          address:(NSString*) address_
                      phoneNumber:(NSString*) phoneNumber_
                     sellsTickets:(NSString*) sellsTickets_
                      movieIdentifiers:(NSArray*) movieIdentifiers_ {
    if (self = [self init]) {
        self.identifier = identifier_;
        self.name = [name_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [address_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.phoneNumber = phoneNumber_ != nil ? phoneNumber_ : @"";
        self.sellsTickets = sellsTickets_;
        self.movieIdentifiers = movieIdentifiers_;
    }
    
    return self;
}

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           address:(NSString*) address
                       phoneNumber:(NSString*) phoneNumber
                      sellsTickets:(NSString*) sellsTickets
                       movieIdentifiers:(NSArray*) movieIdentifiers {
    return [[[Theater alloc] initWithIdentifier:identifier
                                           name:name
                                        address:address
                                    phoneNumber:phoneNumber
                                   sellsTickets:sellsTickets
                                    movieIdentifiers:movieIdentifiers] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:identifier forKey:@"identifier"];
    [dictionary setObject:name forKey:@"name"];
    [dictionary setObject:address forKey:@"address"];
    [dictionary setObject:phoneNumber forKey:@"phoneNumber"];
    [dictionary setObject:sellsTickets forKey:@"sellsTickets"];
    [dictionary setObject:movieIdentifiers forKey:@"movieIdentifiers"];
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