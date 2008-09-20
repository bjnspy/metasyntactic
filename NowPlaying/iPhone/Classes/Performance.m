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

#import "Performance.h"

#import "Utilities.h"

@implementation Performance

property_definition(identifier);
property_definition(time);
property_definition(url);

- (void) dealloc {
    self.identifier = nil;
    self.time = nil;
    self.url = nil;

    [super dealloc];
}


- (id) initWithIdentifier:(NSString*) identifier_
                     time:(NSString*) time_
                      url:(NSString*) url_ {
    if (self = [super init]) {
        self.identifier = [Utilities nonNilString:identifier_];
        self.time = [Utilities nonNilString:time_];
        self.url = [Utilities nonNilString:url_];
    }

    return self;
}


+ (Performance*) performanceWithIdentifier:(NSString*) identifier
                                      time:(NSString*) time
                                       url:(NSString*) url {
    return [[[Performance alloc] initWithIdentifier:identifier
                                               time:time
                                                url:url] autorelease];
}


+ (Performance*) performanceWithDictionary:(NSDictionary*) dictionary {
    return [Performance performanceWithIdentifier:[dictionary valueForKey:identifier_key]
                                             time:[dictionary valueForKey:time_key]
                                              url:[dictionary valueForKey:url_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:identifier forKey:identifier_key];
    [dictionary setObject:time forKey:time_key];
    [dictionary setObject:url forKey:url_key];

    return dictionary;
}


@end