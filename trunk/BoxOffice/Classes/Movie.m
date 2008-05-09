//
//  Movie.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"


@implementation Movie

@synthesize title;
@synthesize synopsis;
@synthesize link;
@synthesize rating;

- (void) dealloc
{
    self.title = nil;
    self.synopsis = nil;
    self.link = nil;
    self.rating = nil;
    [super dealloc];
}

+ (Movie*) movieWithTitle:(NSString*) aTitle
                     link:(NSString*) aLink
                 synopsis:(NSString*) aSynopsis
                   rating:(NSString*) aRating
{
    return [[[Movie alloc] initWithTitle:aTitle link:aLink synopsis:aSynopsis rating:aRating] autorelease];
}

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary
{
    return [Movie movieWithTitle:[dictionary objectForKey:@"title"]
                            link:[dictionary objectForKey:@"link"]
                        synopsis:[dictionary objectForKey:@"synopsis"]
                          rating:[dictionary objectForKey:@"rating"]];
}

- (void) assignTitle:(NSString*) aTitle
                link:(NSString*) aLink
            synopsis:(NSString*) aSynopsis
              rating:(NSString*) aRating
{
    self.title    = [aTitle    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.link     = [aLink     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.synopsis = [aSynopsis stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.rating   = [aRating   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (id) initWithTitle:(NSString*) aTitle
                link:(NSString*) aLink
            synopsis:(NSString*) aSynopsis
              rating:(NSString*) aRating
{
    if (self = [self init])
    {
        [self assignTitle:aTitle link:aLink synopsis:aSynopsis rating:aRating];
    }
    
    return self;
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.title         forKey:@"title"];
    [dictionary setValue:self.link          forKey:@"link"];
    [dictionary setValue:self.synopsis      forKey:@"synopsis"];
    [dictionary setValue:self.rating        forKey:@"rating"];
    return dictionary;
}

- (NSString*) description
{
    return [[self dictionary] description];
}

- (BOOL) isEqual:(id) anObject
{
    Movie* other = anObject;
    
    return
        [self.title isEqual:other.title] &&
        [self.link isEqual:other.link] &&
        [self.synopsis isEqual:other.synopsis] &&
        [self.rating isEqual:other.rating];
}

- (NSUInteger) hash
{
    return
        [self.title hash] +
        [self.link hash] +
        [self.synopsis hash] +
        [self.rating hash];
}

- (NSInteger) ratingValue
{
    int value = [self.rating intValue]; 
    if (value >= 0 && value <= 100)
    {
        return value;
    }
    
    return -1;
}

@end
