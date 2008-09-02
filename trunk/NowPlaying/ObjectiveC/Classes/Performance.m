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

@implementation Performance

property_definition(identifier);
property_definition(time);

- (void) dealloc {
    self.identifier = nil;
    self.time = nil;

    [super dealloc];
}


- (id) initWithIdentifier:(NSString*) identifier_
                     time:(NSString*) time_ {
    if (self = [super init]) {
        self.identifier = identifier_;
        self.time = time_;
    }

    return self;
}


+ (Performance*) performanceWithIdentifier:(NSString*) identifier
                                      time:(NSString*) time {
    return [[[Performance alloc] initWithIdentifier:identifier time:time] autorelease];
}


+ (Performance*) performanceWithDictionary:(NSDictionary*) dictionary {
    return [Performance performanceWithIdentifier:[dictionary valueForKey:identifier_key]
                                             time:[dictionary valueForKey:time_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:identifier forKey:identifier_key];
    [dictionary setObject:time forKey:time_key];

    return dictionary;
}


@end