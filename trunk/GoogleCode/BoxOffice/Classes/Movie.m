//
//  Movie.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"
#import "Utilities.h"

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

- (id) initWithIdentifier:(NSString*) identifier_
                    title:(NSString*) title_
                   rating:(NSString*) rating_
                   length:(NSString*) length_
              releaseDate:(NSDate*) releaseDate_
                   poster:(NSString*) poster_
           backupSynopsis:(NSString*) backupSynopsis_ {
    if (self = [self init]) {
        self.identifier = identifier_;
        self.title    = [title_    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.rating   = [rating_   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (self.rating == nil) {
            self.rating = @"NR";
        }
        self.length = length_;
        self.releaseDate = releaseDate_;
        self.poster = poster_;
        self.backupSynopsis = backupSynopsis_;
    }
    
    return self;
}

+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) poster
                backupSynopsis:(NSString*) backupSynopsis  {
    return [[[Movie alloc] initWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:length
                                  releaseDate:releaseDate
                                       poster:poster
                               backupSynopsis:backupSynopsis] autorelease];
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
        //[text appendString:@" -"];
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
