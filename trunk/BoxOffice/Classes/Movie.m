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
@synthesize description;
@synthesize link;
@synthesize rating;

- (void) dealloc
{
    self.title = nil;
    self.description = nil;
    self.link = nil;
    self.rating = nil;
    [super dealloc];
}

- (id) initWithDictionary:(NSDictionary*) dictionary
{
    return [self initWithTitle:[dictionary objectForKey:@"title"]
                          link:[dictionary objectForKey:@"link"]
                   description:[dictionary objectForKey:@"description"]
                        rating:[dictionary objectForKey:@"rating"]];
    
}

- (void) assignTitle:(NSString*) aTitle
                link:(NSString*) aLink
         description:(NSString*) aDescription
              rating:(NSString*) aRating
{
    self.title = aTitle;
    self.link = aLink;
    self.description = aDescription;
    self.rating = aRating;
}

- (id) initWithTitle:(NSString*) aTitle
                link:(NSString*) aLink
         description:(NSString*) aDescription
              rating:(NSString*) aRating
{
    if (self = [self init])
    {
        [self assignTitle:aTitle link:aLink description:aDescription rating:aRating];
    }
    
    return self;
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.title         forKey:@"title"];
    [dictionary setValue:self.link          forKey:@"link"];
    [dictionary setValue:self.description   forKey:@"description"];
    [dictionary setValue:self.rating        forKey:@"rating"];
    return dictionary;
}

@end
