//
//  Movie.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"


@implementation Movie

@synthesize identifier;
@synthesize title;
@synthesize rating;
@synthesize length;
@synthesize poster;

- (void) dealloc {
    self.identifier = nil;
    self.title = nil;
    self.rating = nil;
    self.length = nil;
    self.poster = nil;
    [super dealloc];
}

- (id) initWithIdentifier:(NSString*) anIdentifier
                    title:(NSString*) aTitle
                   rating:(NSString*) aRating
                   length:(NSString*) aLength 
                   poster:(NSString*) aPoster {
    if (self = [self init]) {
        self.identifier = anIdentifier;
        self.title    = [aTitle    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.rating   = [aRating   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.length = aLength;
        self.poster = aPoster;
    }
    
    return self;
}

+ (Movie*) movieWithIdentifier:(NSString*) anIdentifier
                         title:(NSString*) aTitle
                        rating:(NSString*) aRating
                        length:(NSString*) aLength
                        poster:(NSString*) aPoster {
    return [[[Movie alloc] initWithIdentifier:anIdentifier
                                        title:aTitle
                                       rating:aRating
                                       length:aLength
                                       poster:aPoster] autorelease];
}

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [Movie movieWithIdentifier:[dictionary objectForKey:@"identifier"]
                                title:[dictionary objectForKey:@"title"]
                               rating:[dictionary objectForKey:@"rating"]
                               length:[dictionary objectForKey:@"length"]
                               poster:[dictionary objectForKey:@"poster"]];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.identifier    forKey:@"identifier"];
    [dictionary setValue:self.title         forKey:@"title"];
    [dictionary setValue:self.rating        forKey:@"rating"];
    [dictionary setValue:self.length        forKey:@"length"];
    [dictionary setValue:self.poster        forKey:@"poster"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Movie* other = anObject;
    
    return
    [self.identifier isEqual:other.identifier] &&
    [self.title isEqual:other.title] &&
    [self.rating isEqual:other.rating] &&
    [self.length isEqual:other.length] &&
    [self.poster isEqual:other.poster];
}

- (NSUInteger) hash {
    return
    [self.identifier hash];
    [self.title hash] +
    [self.rating hash] +
    [self.length hash] +
    [self.poster hash];
}

@end
