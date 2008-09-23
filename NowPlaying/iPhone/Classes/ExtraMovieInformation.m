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

#import "ExtraMovieInformation.h"

#import "Movie.h"
#import "Utilities.h"

@implementation ExtraMovieInformation

property_definition(canonicalTitle);
property_definition(synopsis);
property_definition(score);
property_definition(provider);
property_definition(identifier);

- (void) dealloc {
    self.canonicalTitle = nil;
    self.synopsis = nil;
    self.score = nil;
    self.provider = nil;
    self.identifier = nil;

    [super dealloc];
}


- (id) initWithCanonicalTitle:(NSString*) canonicalTitle_
                     synopsis:(NSString*) synopsis_
                        score:(NSString*) score_
                     provider:(NSString*) provider_
                   identifier:(NSString*) identifier_ {
    if (self = [super init]) {
        self.canonicalTitle = [Utilities nonNilString:canonicalTitle_];
        self.score = [Utilities nonNilString:score_];
        self.synopsis = [Utilities nonNilString:synopsis_];
        self.provider = provider_;
        self.identifier = [Utilities nonNilString:identifier_];
    }

    return self;
}


+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                synopsis:(NSString*) synopsis
                                   score:(NSString*) score
                                provider:(NSString*) provider
                              identifier:(NSString*) identifier {
    return [[[ExtraMovieInformation alloc] initWithCanonicalTitle:[Movie makeCanonical:title]
                                                         synopsis:[Utilities stripHtmlCodes:synopsis]
                                                            score:score
                                                         provider:provider
                                                       identifier:identifier] autorelease];
}


+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [[[ExtraMovieInformation alloc] initWithCanonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                                         synopsis:[dictionary objectForKey:synopsis_key]
                                                            score:[dictionary objectForKey:score_key]
                                                         provider:[dictionary objectForKey:provider_key]
                                                       identifier:[dictionary objectForKey:identifier_key]] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:canonicalTitle    forKey:canonicalTitle_key];
    [dictionary setObject:synopsis          forKey:synopsis_key];
    [dictionary setObject:score             forKey:score_key];
    [dictionary setObject:provider          forKey:provider_key];
    [dictionary setObject:identifier        forKey:identifier_key];
    return dictionary;
}


- (NSInteger) scoreValue {
    int value = score.intValue;
    if (value >= 0 && value <= 100) {
        return value;
    }

    return -1;
}


@end