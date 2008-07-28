//
//  MetacriticDownloader.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MetacriticDownloader.h"
#import "Application.h"
#import "ExtraMovieInformation.h"
#import "Utilities.h"

@implementation MetacriticDownloader

@synthesize model;

- (void) dealloc {
    self.model = nil;

    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
    }

    return self;
}

+ (MetacriticDownloader*) downloaderWithModel:(BoxOfficeModel*) model {
    return [[[MetacriticDownloader alloc] initWithModel:model] autorelease];
}

- (NSDictionary*) lookupMovieListings {
    NSMutableArray* hosts = [Application hosts];
    NSString* host = [Utilities removeRandomElement:hosts];

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieListings?q=Metacritic", host]];
    NSError* httpError = nil;
    NSString* movieListings = [NSString stringWithContentsOfURL:url encoding:NSISOLatin1StringEncoding error:&httpError];

    if (httpError == nil && movieListings != nil) {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

        NSArray* rows = [movieListings componentsSeparatedByString:@"\n"];

        for (NSString* row in rows) {
            NSArray* columns = [row componentsSeparatedByString:@"\t"];

            if (columns.count >= 3) {
                NSString* synopsis = @"";
                NSString* score = [columns objectAtIndex:0];
                NSString* link  = [columns objectAtIndex:1];
                NSString* title = [columns objectAtIndex:2];
                if ([score isEqual:@"xx"]) {
                    score = @"-1";
                }

                ExtraMovieInformation* extraInfo = [ExtraMovieInformation infoWithTitle:title
                                                                                   link:link
                                                                               synopsis:synopsis
                                                                                  score:score];


                [dictionary setObject:extraInfo forKey:[extraInfo title]];
            }
        }

        return dictionary;
    }

    return nil;
}

@end
