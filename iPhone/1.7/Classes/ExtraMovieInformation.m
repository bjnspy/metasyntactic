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
property_definition(link);
property_definition(synopsis);
property_definition(score);

- (void) dealloc {
    self.canonicalTitle = nil;
    self.link = nil;
    self.synopsis = nil;
    self.score = nil;

    [super dealloc];
}


- (id) initWithCanonicalTitle:(NSString*) canonicalTitle_
                         link:(NSString*) link_
                     synopsis:(NSString*) synopsis_
                        score:(NSString*) score_ {
    if (self = [super init]) {
        self.canonicalTitle = canonicalTitle_;
        self.link = link_;
        self.score = score_;
        self.synopsis = synopsis_;
    }

    return self;
}


+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                    link:(NSString*) link
                                synopsis:(NSString*) synopsis
                                   score:(NSString*) score {
    return [[[ExtraMovieInformation alloc] initWithCanonicalTitle:[Movie makeCanonical:title]
                                                             link:link
                                                         synopsis:[Utilities stripHtmlCodes:synopsis]
                                                            score:score] autorelease];
}


+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [[[ExtraMovieInformation alloc] initWithCanonicalTitle:[dictionary objectForKey:canonicalTitle_key]
                                                             link:[dictionary objectForKey:link_key]
                                                         synopsis:[dictionary objectForKey:synopsis_key]
                                                            score:[dictionary objectForKey:score_key]] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:canonicalTitle    forKey:canonicalTitle_key];
    [dictionary setObject:link              forKey:link_key];
    [dictionary setObject:synopsis          forKey:synopsis_key];
    [dictionary setObject:score             forKey:score_key];
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