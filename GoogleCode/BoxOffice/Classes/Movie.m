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
@synthesize releaseDate;
@synthesize poster;
@synthesize backupSynopsis;

- (void) dealloc {
    self.identifier = nil;
    self.title = nil;
    self.rating = nil;
    self.length = nil;
    self.releaseDate = nil;
    self.poster = nil;
    self.backupSynopsis = nil;
    
    [super dealloc];
}

- (id) initWithIdentifier:(NSString*) anIdentifier
                    title:(NSString*) aTitle
                   rating:(NSString*) aRating
                   length:(NSString*) aLength
              releaseDate:(NSDate*) aReleaseDate
                   poster:(NSString*) aPoster
           backupSynopsis:(NSString*) aBackupSynopsis {
    if (self = [self init]) {
        self.identifier = anIdentifier;
        self.title    = [aTitle    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.rating   = [aRating   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.length = aLength;
        self.releaseDate = aReleaseDate;
        self.poster = aPoster;
        self.backupSynopsis = aBackupSynopsis;
    }
    
    return self;
}

+ (Movie*) movieWithIdentifier:(NSString*) anIdentifier
                         title:(NSString*) aTitle
                        rating:(NSString*) aRating
                        length:(NSString*) aLength
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) aPoster
                backupSynopsis:(NSString*) aBackupSynopsis  {
    return [[[Movie alloc] initWithIdentifier:anIdentifier
                                        title:aTitle
                                       rating:aRating
                                       length:aLength
                                  releaseDate:releaseDate
                                       poster:aPoster
                               backupSynopsis:aBackupSynopsis] autorelease];
}

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary {
    return [Movie movieWithIdentifier:[dictionary objectForKey:@"identifier"]
                                title:[dictionary objectForKey:@"title"]
                               rating:[dictionary objectForKey:@"rating"]
                               length:[dictionary objectForKey:@"length"]
                          releaseDate:[dictionary objectForKey:@"releaseDate"]
                               poster:[dictionary objectForKey:@"poster"]
                       backupSynopsis:[dictionary objectForKey:@"backupSynopsis"]];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.identifier     forKey:@"identifier"];
    [dictionary setValue:self.title          forKey:@"title"];
    [dictionary setValue:self.rating         forKey:@"rating"];
    [dictionary setValue:self.length         forKey:@"length"];
    [dictionary setValue:self.releaseDate    forKey:@"releaseDate"];
    [dictionary setValue:self.poster         forKey:@"poster"];
    [dictionary setValue:self.backupSynopsis forKey:@"backupSynopsis"];
    return dictionary;
}

- (NSString*) description {
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject {
    Movie* other = anObject;
    
    return
    [self.identifier isEqual:other.identifier] &&
    [self.title isEqual:other.title];
}

- (NSUInteger) hash {
    return
    [self.identifier hash];
    [self.title hash];
}

@end
