// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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

- (void) dealloc {
    self.identifier = nil;
    self.canonicalTitle = nil;
    self.rating = nil;
    self.length = nil;
    self.releaseDate = nil;
    self.poster = nil;
    self.synopsis = nil;
    self.displayTitle = nil;

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
                 synopsis:(NSString*) synopsis_ {
    if (self = [self init]) {
        self.identifier = identifier_;
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.displayTitle   = [Movie makeDisplay:title_];

        self.rating = [rating_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (self.rating == nil) {
            self.rating = @"NR";
        }
        self.length = length_;
        self.releaseDate = releaseDate_;
        self.poster = poster_;
        self.synopsis = synopsis_;

        self.synopsis = [synopsis stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
        self.synopsis = [synopsis stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
        self.synopsis = [synopsis stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    }

    return self;
}


+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis  {
    return [[[Movie alloc] initWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:length
                                  releaseDate:releaseDate
                                       poster:poster
                                     synopsis:synopsis] autorelease];
}


+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [Movie movieWithIdentifier:[dictionary objectForKey:@"identifier"]
                                title:[dictionary objectForKey:@"canonicalTitle"]
                               rating:[dictionary objectForKey:@"rating"]
                               length:[dictionary objectForKey:@"length"]
                          releaseDate:[dictionary objectForKey:@"releaseDate"]
                               poster:[dictionary objectForKey:@"poster"]
                             synopsis:[dictionary objectForKey:@"synopsis"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.identifier     forKey:@"identifier"];
    [dictionary setValue:self.canonicalTitle forKey:@"canonicalTitle"];
    [dictionary setValue:self.rating         forKey:@"rating"];
    [dictionary setValue:self.length         forKey:@"length"];
    [dictionary setValue:self.releaseDate    forKey:@"releaseDate"];
    [dictionary setValue:self.poster         forKey:@"poster"];
    [dictionary setValue:self.synopsis       forKey:@"synopsis"];
    return dictionary;
}


- (NSString*) description {
    return [[self dictionary] description];
}


- (BOOL) isEqual:(id) anObject {
    Movie* other = anObject;

    return
    [self.identifier isEqual:other.identifier] &&
    [self.canonicalTitle isEqual:other.canonicalTitle];
}


- (NSUInteger) hash {
    return
    [self.identifier hash];
    [self.canonicalTitle hash];
}


- (NSString*) ratingAndRuntimeString {
    NSInteger movieLength = [self.length intValue];
    NSInteger hours = movieLength / 60;
    NSInteger minutes = movieLength % 60;

    NSString* ratingString;
    if ([Utilities isNilOrEmpty:rating] || [rating isEqual:@"NR"]) {
        ratingString = NSLocalizedString(@"Unrated.", nil);
    }  else {
        ratingString = [NSString stringWithFormat:NSLocalizedString(@"Rated %@.", nil), self.rating];
    }

    NSMutableString* text = [NSMutableString stringWithString:ratingString];
    if (movieLength != 0) {
        if (hours == 1) {
            [text appendString:@" 1 hour"];
        } else if (hours > 1) {
            [text appendFormat:@" %d hours", hours];
        }

        if (minutes == 1) {
            [text appendString:@" 1 minute"];
        } else if (minutes > 1) {
            [text appendFormat:@" %d minutes", minutes];
        }
    }

    return text;
}


@end
