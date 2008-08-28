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

@synthesize canonicalTitle;
@synthesize link;
@synthesize synopsis;
@synthesize score;

- (void) dealloc {
    self.canonicalTitle = nil;
    self.link = nil;
    self.synopsis = nil;
    self.score = nil;

    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
                link:(NSString*) link_
            synopsis:(NSString*) synopsis_
               score:(NSString*) score_ {
    if (self = [super init]) {
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.link = link_;
        self.score = score_;

        self.synopsis = [Utilities stripHtmlCodes:synopsis_];
    }

    return self;
}


+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                    link:(NSString*) link
                                synopsis:(NSString*) synopsis
                                   score:(NSString*) score {
    return [[[ExtraMovieInformation alloc] initWithTitle:title
                                                    link:link
                                                synopsis:synopsis
                                                   score:score] autorelease];
}


+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [ExtraMovieInformation infoWithTitle:[dictionary objectForKey:@"canonicalTitle"]
                                           link:[dictionary objectForKey:@"link"]
                                       synopsis:[dictionary objectForKey:@"synopsis"]
                                          score:[dictionary objectForKey:@"score"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:canonicalTitle forKey:@"canonicalTitle"];
    [dictionary setObject:link forKey:@"link"];
    [dictionary setObject:synopsis forKey:@"synopsis"];
    [dictionary setObject:score forKey:@"score"];
    return dictionary;
}


- (NSInteger) scoreValue {
    int value = self.score.intValue;
    if (value >= 0 && value <= 100) {
        return value;
    }

    return -1;
}


@end
