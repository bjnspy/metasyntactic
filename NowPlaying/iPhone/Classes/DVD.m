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

#import "DVD.h"

#import "Movie.h";
#import "Utilities.h"

@implementation DVD

property_definition(canonicalTitle);
property_definition(price);
property_definition(format);
property_definition(discs);

- (void) dealloc {
    self.canonicalTitle = nil;
    self.price = nil;
    self.format = nil;
    self.discs = nil;

    [super dealloc];
}


- (id) initWithCanonicalTitle:(NSString*) canonicalTitle_
                        price:(NSString*) price_
                       format:(NSString*) format_
                        discs:(NSString*) discs_ {
    if (self = [super init]) {
        self.canonicalTitle = [Utilities nonNilString:canonicalTitle_];
        self.price = [Utilities nonNilString:price_];
        self.format = [Utilities nonNilString:format_];
        self.discs = [Utilities nonNilString:discs_];
    }
    
    return self;
}


+ (DVD*) dvdWithCanonicalTitle:(NSString*) canonicalTitle
                price:(NSString*) price
               format:(NSString*) format
                         discs:(NSString*) discs {
    return [[[DVD alloc] initWithCanonicalTitle:canonicalTitle
                                          price:price
                                         format:format
                                          discs:discs] autorelease];
}


+ (DVD*) dvdWithTitle:(NSString*) title
                price:(NSString*) price
               format:(NSString*) format
                discs:(NSString*) discs {
    return [DVD dvdWithCanonicalTitle:[Movie makeCanonical:title]
                                price:price
                               format:format
                                discs:discs];
}


+ (DVD*) dvdWithDictionary:(NSDictionary*) dictionary {
    return [DVD dvdWithCanonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                price:[dictionary objectForKey:price_key]
                               format:[dictionary objectForKey:format_key]
                                discs:[dictionary objectForKey:discs_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:canonicalTitle    forKey:canonicalTitle_key];
    [result setObject:price             forKey:price_key];
    [result setObject:format            forKey:format_key];
    [result setObject:discs             forKey:discs_key];
    return result;
}

@end