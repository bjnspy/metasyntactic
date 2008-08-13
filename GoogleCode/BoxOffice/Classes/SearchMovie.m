// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchMovie.h"

#import "MovieKey.h"
#import "PersonKey.h"
#import "Utilities.h"

@implementation SearchMovie

@synthesize key;
@synthesize producers;
@synthesize writers;
@synthesize directors;
@synthesize music;
@synthesize cast;
@synthesize imageUrl;
@synthesize imageData;
@synthesize genres;
@synthesize outline;
@synthesize plot;
@synthesize votes;
@synthesize rating;

- (void) dealloc {
    self.key = nil;
    self.producers = nil;
    self.writers = nil;
    self.directors = nil;
    self.music = nil;
    self.cast = nil;
    self.imageUrl = nil;
    self.imageData = nil;
    self.genres = nil;
    self.outline = nil;
    self.plot = nil;
    self.votes = nil;
    self.rating = nil;

    [super dealloc];
}


- (id) initWithKey:(MovieKey*) key_
         producers:(NSArray*) producers_
           writers:(NSArray*) writers_
         directors:(NSArray*) directors_
             music:(NSArray*) music_
              cast:(NSArray*) cast_
          imageUrl:(NSString*) imageUrl_
         imageData:(NSData*) imageData_
            genres:(NSArray*) genres_
           outline:(NSString*) outline_
              plot:(NSString*) plot_
             votes:(NSString*) votes_
            rating:(NSString*) rating_ {
    if (self = [super init]) {
        self.key = key_;
        self.producers = [Utilities nonNilArray:producers_];
        self.writers = [Utilities nonNilArray:writers_];
        self.directors = [Utilities nonNilArray:directors_];
        self.music = [Utilities nonNilArray:music_];
        self.cast = [Utilities nonNilArray:cast_];
        self.imageUrl = [Utilities nonNilString:imageUrl_];
        self.imageData = imageData_;
        self.genres = [Utilities nonNilArray:genres_];
        self.outline = [Utilities nonNilString:outline_];
        self.plot = [Utilities nonNilString:plot_];
        self.votes = [Utilities nonNilString:votes_];
        self.rating = [Utilities nonNilString:rating_];
    }

    return self;
}


+ (SearchMovie*) movieWithKey:(MovieKey*) key
                    producers:(NSArray*) producers
                      writers:(NSArray*) writers
                    directors:(NSArray*) directors
                        music:(NSArray*) music
                         cast:(NSArray*) cast
                     imageUrl:(NSString*) imageUrl
                    imageData:(NSData*) imageData
                       genres:(NSArray*) genres
                      outline:(NSString*) outline
                         plot:(NSString*) plot
                        votes:(NSString*) votes
                       rating:(NSString*) rating {
    return [[[SearchMovie alloc] initWithKey:key
                                   producers:producers
                                     writers:writers
                                   directors:directors
                                       music:music
                                        cast:cast
                                    imageUrl:imageUrl
                                   imageData:imageData
                                      genres:genres
                                     outline:outline
                                        plot:plot
                                       votes:votes
                                      rating:rating] autorelease];
}


- (NSArray*) encodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (Key* k in array) {
        [result addObject:[k dictionary]];
    }
    return result;
}


+ (NSArray*) decodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        [result addObject:[PersonKey keyWithDictionary:dict]];
    }
    return result;
}


+ (SearchMovie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [SearchMovie movieWithKey:[MovieKey keyWithDictionary:[dictionary objectForKey:@"key"]]
                           producers:[SearchMovie decodeArray:[dictionary objectForKey:@"producers"]]
                             writers:[SearchMovie decodeArray:[dictionary objectForKey:@"writers"]]
                           directors:[SearchMovie decodeArray:[dictionary objectForKey:@"directors"]]
                               music:[SearchMovie decodeArray:[dictionary objectForKey:@"music"]]
                                cast:[SearchMovie decodeArray:[dictionary objectForKey:@"cast"]]
                            imageUrl:[dictionary objectForKey:@"imageUrl"]
                           imageData:[dictionary objectForKey:@"imageData"]
                              genres:[dictionary objectForKey:@"genres"]
                             outline:[dictionary objectForKey:@"outline"]
                                plot:[dictionary objectForKey:@"plot"]
                               votes:[dictionary objectForKey:@"votes"]
                              rating:[dictionary objectForKey:@"rating"]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[key dictionary] forKey:@"key"];
    [dict setObject:[self encodeArray:producers]    forKey:@"producers"];
    [dict setObject:[self encodeArray:writers]      forKey:@"writers"];
    [dict setObject:[self encodeArray:directors]    forKey:@"directors"];
    [dict setObject:[self encodeArray:music]        forKey:@"music"];
    [dict setObject:[self encodeArray:cast]         forKey:@"cast"];
    [dict setObject:imageUrl                        forKey:@"imageUrl"];
    if (imageData != nil) {
        [dict setObject:imageData                       forKey:@"imageData"];
    }
    [dict setObject:genres                          forKey:@"genres"];
    [dict setObject:outline                         forKey:@"outline"];
    [dict setObject:plot                            forKey:@"plot"];
    [dict setObject:votes                           forKey:@"votes"];
    [dict setObject:rating                          forKey:@"rating"];
    return dict;
}


@end
