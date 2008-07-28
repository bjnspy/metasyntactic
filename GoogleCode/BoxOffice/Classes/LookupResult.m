//
//  LookupResults.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LookupResult.h"


@implementation LookupResult

@synthesize movies;
@synthesize theaters;
@synthesize performances;

- (id) initWithMovies:(NSArray*) movies_
             theaters:(NSArray*) theaters_ 
         performances:(NSDictionary*) performances_ {
    if (self = [super init]) {
        self.movies = movies_;
        self.theaters = theaters_;
        self.performances = performances_;
    }
     
    return self;
}

+ (LookupResult*) resultWithMovies:(NSArray*) movies 
                          theaters:(NSArray*) theaters 
                      performances:(NSDictionary*) performances {
    return [[[LookupResult alloc] initWithMovies:movies
                                        theaters:theaters
                                    performances:performances] autorelease];
}

@end
