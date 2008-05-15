//
//  Theater.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Theater.h"


@implementation Theater

@synthesize name;
@synthesize address;
@synthesize phoneNumber;
@synthesize movieToShowtimesMap;

- (void) dealloc {
    self.name = nil;
    self.address = nil;
    self.phoneNumber = nil;
    self.movieToShowtimesMap = nil;
    
    [super dealloc];
}

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithName:[dictionary objectForKey:@"name"]
                            address:[dictionary objectForKey:@"address"]
                        phoneNumber:[dictionary objectForKey:@"phoneNumber"]
                movieToShowtimesMap:[dictionary objectForKey:@"movieToShowtimeMap"]];
}

NSComparisonResult compareDateStrings(id t1, id t2, void* context) {
    NSString* s1 = t1;
    NSString* s2 = t2;
    
    NSDate* d1 = [NSDate dateWithNaturalLanguageString:s1];
    NSDate* d2 = [NSDate dateWithNaturalLanguageString:s2];
    
    return [d1 compare:d2];
}

+ (NSArray*) processShowtimes:(NSArray*) showtimes {
    NSArray* sortedArray = [showtimes sortedArrayUsingFunction:compareDateStrings context:nil];
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSString* dateString in sortedArray) {
        NSDate* date = [NSDate dateWithNaturalLanguageString:dateString];
        
        NSDateComponents* components = 
            [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit)
                                            fromDate:date];
        
        int hour = [components hour];
        int minute = [components minute];
        NSString* formattedString = 
        [NSString stringWithFormat:@"%d:%02d%@",
         (hour > 12 ? hour - 12 : hour),
         minute,
         (hour > 12) ? @"pm" : @"am" ];
        
        [result addObject:formattedString];
    }
    
    return result;
}

+ (NSDictionary*) prepareShowtimesMap:(NSDictionary*) movieToShowtimesMap {
    return movieToShowtimesMap;
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    for (NSString* movie in movieToShowtimesMap) {
        [result setObject:[self processShowtimes:[movieToShowtimesMap objectForKey:movie]]
                   forKey:movie];
    }
    
    return result;
}

- (id)         initWithName:(NSString*) aName
                    address:(NSString*) anAddress
                phoneNumber:(NSString*) aPhoneNumber
        movieToShowtimesMap:(NSDictionary*) aDictionary {
    if (self = [self init]) {
        self.name = [aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.address = [anAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.phoneNumber = aPhoneNumber != nil ? aPhoneNumber : @"";
        self.movieToShowtimesMap = aDictionary;
    }
    
    return self;
}

+ (Theater*) theaterWithName:(NSString*) aName
                     address:(NSString*) anAddress
                 phoneNumber:(NSString*) phoneNumber
         movieToShowtimesMap:(NSDictionary*) aDictionary {
    return [[[Theater alloc] initWithName:aName
                                  address:anAddress
                              phoneNumber:phoneNumber
                      movieToShowtimesMap:aDictionary] autorelease];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.address forKey:@"address"];
    [dictionary setObject:self.phoneNumber forKey:@"phoneNumber"];
    [dictionary setObject:self.movieToShowtimesMap forKey:@"movieToShowtimeMap"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Theater* other = anObject;
    return
        [self.name isEqual:other.name] &&
        [self.address isEqual:other.address] &&
        [self.phoneNumber isEqual:other.phoneNumber] &&
        [self.movieToShowtimesMap isEqual:other.movieToShowtimesMap];
}

- (NSUInteger) hash {
    return
        [self.name hash] +
        [self.address hash] +
        [self.phoneNumber hash] + 
        [self.movieToShowtimesMap hash];
}

@end
