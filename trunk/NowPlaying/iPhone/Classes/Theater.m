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

#import "Theater.h"

#import "DateUtilities.h"
#import "Location.h"
#import "Utilities.h"

@implementation Theater

property_definition(identifier);
property_definition(name);
property_definition(location);
property_definition(mapUrl);
property_definition(phoneNumber);
property_definition(movieTitles);
property_definition(originatingPostalCode);

- (void) dealloc {
    self.identifier = nil;
    self.name = nil;
    self.location = nil;
    self.mapUrl = nil;
    self.phoneNumber = nil;
    self.movieTitles = nil;
    self.originatingPostalCode = nil;

    [super dealloc];
}


+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary {
    return [Theater theaterWithIdentifier:[dictionary objectForKey:identifier_key]
                                     name:[dictionary objectForKey:name_key]
                                  location:[Location locationWithDictionary:[dictionary objectForKey:location_key]]
                                   mapUrl:[dictionary objectForKey:mapUrl_key]
                              phoneNumber:[dictionary objectForKey:phoneNumber_key]
                              movieTitles:[dictionary objectForKey:movieTitles_key]
                    originatingPostalCode:[dictionary objectForKey:originatingPostalCode_key]];
}


- (id)      initWithIdentifier:(NSString*) identifier_
                          name:(NSString*) name_
                       location:(Location*) location_
                        mapUrl:(NSString*) mapUrl_
                   phoneNumber:(NSString*) phoneNumber_
                   movieTitles:(NSArray*) movieTitles_
         originatingPostalCode:(NSString*) originatingPostalCode_ {
    if (self = [self init]) {
        self.identifier = [Utilities nonNilString:identifier_];
        self.name = [[Utilities nonNilString:name_] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.location = location_;
        self.mapUrl = [Utilities nonNilString:mapUrl_];
        self.phoneNumber = [Utilities nonNilString:phoneNumber_];
        self.movieTitles = [Utilities nonNilArray:movieTitles_];
        self.originatingPostalCode = [Utilities nonNilString:originatingPostalCode_];
    }

    return self;
}


+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           location:(Location*) location
                            mapUrl:(NSString*) mapUrl
                       phoneNumber:(NSString*) phoneNumber
                       movieTitles:(NSArray*) movieTitles
             originatingPostalCode:(NSString*) originatingPostalCode {
    return [[[Theater alloc] initWithIdentifier:identifier
                                           name:name
                                        location:location
                                         mapUrl:mapUrl
                                    phoneNumber:phoneNumber
                                    movieTitles:movieTitles
                          originatingPostalCode:originatingPostalCode] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:identifier                            forKey:identifier_key];
    [dictionary setObject:name                                  forKey:name_key];
    [dictionary setObject:location.dictionary                   forKey:location_key];
    [dictionary setObject:mapUrl                                forKey:mapUrl_key];
    [dictionary setObject:phoneNumber                           forKey:phoneNumber_key];
    [dictionary setObject:movieTitles                           forKey:movieTitles_key];
    [dictionary setObject:originatingPostalCode                 forKey:originatingPostalCode_key];
    return dictionary;
}


- (NSString*) description {
    return self.dictionary.description;
}


- (BOOL) isEqual:(id) anObject {
    Theater* other = anObject;
    return [name isEqual:other.name];
}


- (NSUInteger) hash {
    return name.hash;
}


+ (NSString*) processShowtime:(NSString*) showtime {
    if ([DateUtilities use24HourTime]) {
        return showtime;
    }

    if ([showtime hasSuffix:@" PM"]) {
        return [NSString stringWithFormat:@"%@pm", [showtime substringToIndex:showtime.length - 3]];
    } else if ([showtime hasSuffix:@" AM"]) {
        return [NSString stringWithFormat:@"%@am", [showtime substringToIndex:showtime.length - 3]];
    }

    if (![showtime hasSuffix:@"am"] && ![showtime hasSuffix:@"pm"]) {
        return [NSString stringWithFormat:@"%@pm", showtime];
    }

    return showtime;
}


@end