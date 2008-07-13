//
//  Theater.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Theater.h"
#import "Performance.h"

@implementation Theater

@synthesize identifier;
@synthesize name;
@synthesize address;
@synthesize phoneNumber;
@synthesize sellsTickets;
@synthesize movieToShowtimesMap;
@synthesize sourceZipCode;

- (void) dealloc {
    self.identifier = nil;
    self.name = nil;
    self.address = nil;
    self.phoneNumber = nil;
    self.sellsTickets = nil;
    self.movieToShowtimesMap = nil;
    self.sourceZipCode = nil;
    
    [super dealloc];
}

+ (NSDictionary*) decodeShowtimeMap:(NSDictionary*) map {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (NSString* key in map) {
        NSArray* performances = [map objectForKey:key];
        NSMutableArray* decodedPerformances = [NSMutableArray array];
        
        for (NSDictionary* performance in performances) {
            [decodedPerformances addObject:[Performance performanceWithDictionary:performance]];
        }
        
        [dictionary setObject:decodedPerformances forKey:key];
    }
    
    return dictionary;
}

+ (NSDictionary*) encodeShowtimeMap:(NSDictionary*) map {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (NSString* key in map) {
        NSArray* performances = [map objectForKey:key];
        NSMutableArray* encodedPerformances = [NSMutableArray array];
        
        for (Performance* performance in performances) {
            [encodedPerformances addObject:[performance dictionary]];
        }
        
        [dictionary setObject:encodedPerformances forKey:key];
    }
    
    return dictionary;
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithIdentifier:[dictionary objectForKey:@"identifier"]
                                     name:[dictionary objectForKey:@"name"]
                                  address:[dictionary objectForKey:@"address"]
                              phoneNumber:[dictionary objectForKey:@"phoneNumber"]
                             sellsTickets:[dictionary objectForKey:@"sellsTickets"]
                      movieToShowtimesMap:[Theater decodeShowtimeMap:[dictionary objectForKey:@"movieToShowtimeMap"]]
                            sourceZipCode:[dictionary objectForKey:@"sourceZipCode"]];
}

NSComparisonResult compareDateStrings(id t1, id t2, void* context) {
    NSString* s1 = t1;
    NSString* s2 = t2;
    
    NSDate* d1 = [NSDate dateWithNaturalLanguageString:s1];
    NSDate* d2 = [NSDate dateWithNaturalLanguageString:s2];
    
    return [d1 compare:d2];
}

- (id)         initWithIdentifier:(NSString*) anIdentifier
                             name:(NSString*) aName
                          address:(NSString*) anAddress
                      phoneNumber:(NSString*) aPhoneNumber
                     sellsTickets:(NSString*) aSellsTickets
              movieToShowtimesMap:(NSDictionary*) aDictionary
                    sourceZipCode:(NSString*) aSourceZipcode {
    if (self = [self init]) {
        self.identifier = anIdentifier;
        self.name = [aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [anAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.phoneNumber = aPhoneNumber != nil ? aPhoneNumber : @"";
        self.sellsTickets = aSellsTickets;
        self.movieToShowtimesMap = aDictionary;
        self.sourceZipCode = aSourceZipcode;
    }
    
    return self;
}

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           address:(NSString*) address
                       phoneNumber:(NSString*) phoneNumber
                      sellsTickets:(NSString*) sellsTickets
               movieToShowtimesMap:(NSDictionary*) map
                     sourceZipCode:(NSString*) sourceZipCode {
    return [[[Theater alloc] initWithIdentifier:identifier
                                           name:name
                                        address:address
                                    phoneNumber:phoneNumber
                                   sellsTickets:sellsTickets
                            movieToShowtimesMap:map
                                  sourceZipCode:sourceZipCode] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.identifier forKey:@"identifier"];
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.address forKey:@"address"];
    [dictionary setObject:self.phoneNumber forKey:@"phoneNumber"];
    [dictionary setObject:self.sellsTickets forKey:@"sellsTickets"];
    [dictionary setObject:[Theater encodeShowtimeMap:self.movieToShowtimesMap] forKey:@"movieToShowtimeMap"];
    [dictionary setObject:self.sourceZipCode forKey:@"sourceZipCode"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Theater* other = anObject;
    return
        [self.identifier isEqual:other.identifier] &&
        [self.name isEqual:other.name] &&
        [self.address isEqual:other.address] &&
        [self.phoneNumber isEqual:other.phoneNumber] &&
        [self.sellsTickets isEqual:other.sellsTickets] &&
        [self.movieToShowtimesMap isEqual:other.movieToShowtimesMap];
}

- (NSUInteger) hash {
    return
        [self.identifier hash] +
        [self.name hash] +
        [self.address hash] +
        [self.phoneNumber hash] + 
        [self.sellsTickets hash] +
        [self.movieToShowtimesMap hash];
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
