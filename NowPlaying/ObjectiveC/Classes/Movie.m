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

#import "Movie.h"

#import "Utilities.h"

@implementation Movie

@synthesize identifier;
@synthesize canonicalTitle;
@synthesize rating;
@synthesize length;
@synthesize releaseDate;
@synthesize poster;
@synthesize synopsis;
@synthesize displayTitle;
@synthesize studio;
@synthesize directors;
@synthesize cast;
@synthesize genres;

- (void) dealloc {
    self.identifier = nil;
    self.canonicalTitle = nil;
    self.rating = nil;
    self.length = nil;
    self.releaseDate = nil;
    self.poster = nil;
    self.synopsis = nil;
    self.displayTitle = nil;
    self.studio = nil;
    self.directors = nil;
    self.cast = nil;
    self.genres = nil;

    [super dealloc];
}


static NSString* articles[] = {
@"Der", @"Das", @"Ein", @"Eine", @"The",
@"A", @"An", @"La", @"Las", @"Le",
@"Les", @"Los", @"El", @"Un", @"Une",
@"Una", @"Il", @"O", @"Het", @"De",
@"Os", @"Az", @"Den", @"Al", @"En",
@"L'"
};

+ (NSString*) makeCanonical:(NSString*) title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    int count = sizeof(articles) / sizeof(NSString*);
    for (int i = 0; i < count; i++) {
        NSString* article = articles[i];
        if ([title hasSuffix:[NSString stringWithFormat:@", %@", article]]) {
            return [NSString stringWithFormat:@"%@ %@", article, [title substringToIndex:(title.length - article.length - 2)]];
        }
    }

    return title;
}


+ (NSString*) makeDisplay:(NSString*) title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    int count = sizeof(articles) / sizeof(NSString*);
    for (int i = 0; i < count; i++) {
        NSString* article = articles[i];
        if ([title hasPrefix:[NSString stringWithFormat:@"%@ ", article]]) {
            return [NSString stringWithFormat:@"%@, %@", [title substringFromIndex:(article.length + 1)], article];
        }
    }

    return title;
}


- (id) initWithIdentifier:(NSString*) identifier_
                    title:(NSString*) title_
                   rating:(NSString*) rating_
                   length:(NSString*) length_
              releaseDate:(NSDate*) releaseDate_
                   poster:(NSString*) poster_
                 synopsis:(NSString*) synopsis_
                   studio:(NSString*) studio_
                directors:(NSArray*) directors_
                     cast:(NSArray*) cast_
                   genres:(NSArray*) genres_ {
    if (self = [self init]) {
        self.identifier = identifier_;
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.displayTitle   = [Movie makeDisplay:title_];

        self.rating = [rating_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (rating == nil) {
            self.rating = @"NR";
        }
        self.length = length_;
        self.releaseDate = releaseDate_;
        self.poster = poster_;
        self.synopsis = [Utilities stripHtmlCodes:synopsis_];
        self.studio = studio_;
        self.directors = directors_;
        self.cast = cast_;
        self.genres = genres_;
    }

    return self;
}


+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres {
    return [[[Movie alloc] initWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:length
                                  releaseDate:releaseDate
                                       poster:poster
                                     synopsis:synopsis
                                       studio:studio
                                    directors:directors
                                         cast:cast
                                       genres:genres] autorelease];
}


+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [Movie movieWithIdentifier:[dictionary objectForKey:@"identifier"]
                                title:[dictionary objectForKey:@"canonicalTitle"]
                               rating:[dictionary objectForKey:@"rating"]
                               length:[dictionary objectForKey:@"length"]
                          releaseDate:[dictionary objectForKey:@"releaseDate"]
                               poster:[dictionary objectForKey:@"poster"]
                             synopsis:[dictionary objectForKey:@"synopsis"]
                               studio:[dictionary objectForKey:@"studio"]
                            directors:[dictionary objectForKey:@"directors"]
                                 cast:[dictionary objectForKey:@"cast"]
                               genres:[dictionary objectForKey:@"genres"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:identifier     forKey:@"identifier"];
    [dictionary setValue:canonicalTitle forKey:@"canonicalTitle"];
    [dictionary setValue:rating         forKey:@"rating"];
    [dictionary setValue:length         forKey:@"length"];
    [dictionary setValue:releaseDate    forKey:@"releaseDate"];
    [dictionary setValue:poster         forKey:@"poster"];
    [dictionary setValue:synopsis       forKey:@"synopsis"];
    [dictionary setValue:studio         forKey:@"studio"];
    [dictionary setValue:directors      forKey:@"directors"];
    [dictionary setValue:cast           forKey:@"cast"];
    [dictionary setValue:genres         forKey:@"genres"];
    return dictionary;
}


- (NSString*) description {
    return self.dictionary.description;
}


- (BOOL) isEqual:(id) anObject {
    Movie* other = anObject;

    return
    [identifier isEqual:other.identifier] &&
    [canonicalTitle isEqual:other.canonicalTitle];
}


- (NSUInteger) hash {
    return identifier.hash + canonicalTitle.hash;
}


- (BOOL) isUnrated {
    return [Utilities isNilOrEmpty:rating] || [rating isEqual:@"NR"];
}


- (NSString*) ratingString {
    if (self.isUnrated) {
        return NSLocalizedString(@"Unrated.", nil);
    }  else {
        return [NSString stringWithFormat:NSLocalizedString(@"Rated %@.", nil), rating];
    }
}


- (NSString*) ratingAndRuntimeString {
    NSInteger movieLength = length.intValue;
    NSInteger hours = movieLength / 60;
    NSInteger minutes = movieLength % 60;

    NSString* ratingString = self.ratingString;

    NSMutableString* text = [NSMutableString stringWithString:ratingString];
    if (movieLength != 0) {
        if (hours == 1) {
            [text appendString:@" "];
            [text appendString:NSLocalizedString(@"1 hour", nil)];
        } else if (hours > 1) {
            [text appendString:@" "];
            [text appendFormat:NSLocalizedString(@"%d hours", nil), hours];
        }

        if (minutes == 1) {
            [text appendString:@" "];
            [text appendString:NSLocalizedString(@"1 minute", nil)];
        } else if (minutes > 1) {
            [text appendString:@" "];
            [text appendFormat:NSLocalizedString(@"%d minutes", nil), minutes];
        }
    }

    return text;
}


@end