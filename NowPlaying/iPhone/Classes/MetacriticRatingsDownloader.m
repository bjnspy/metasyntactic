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

#import "MetacriticRatingsDownloader.h"

#import "Application.h"
#import "MovieRating.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "XmlElement.h"

@implementation MetacriticRatingsDownloader

@synthesize model;

- (void) dealloc {
    self.model = nil;
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
    }

    return self;
}


+ (MetacriticRatingsDownloader*) downloaderWithModel:(NowPlayingModel*) model {
    return [[[MetacriticRatingsDownloader alloc] initWithModel:model] autorelease];
}


+ (NSString*) lookupServerHash {
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieRatings?q=metacritic&format=xml&hash=true", [Application host]];
    NSString* value = [NetworkUtilities stringWithContentsOfAddress:address
                                                          important:YES];
    return value;
}


- (NSDictionary*) lookupMovieListings {
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieRatings?q=metacritic&format=xml", [Application host]];
    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:address
                                                                 important:YES];

    if (resultElement != nil) {
        NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

        for (XmlElement* movieElement in resultElement.children) {
            NSString* title =    [movieElement attributeValue:@"title"];
            NSString* link =     [movieElement attributeValue:@"link"];
            NSString* synopsis = [movieElement attributeValue:@"synopsis"];
            NSString* score =    [movieElement attributeValue:@"score"];

            if ([score isEqual:@"xx"]) {
                score = @"-1";
            }

            MovieRating* extraInfo = [MovieRating ratingWithTitle:title
                                                                           synopsis:synopsis
                                                                              score:score
                                                                           provider:@"metacritic"
                                                                         identifier:link];

            [ratings setObject:extraInfo forKey:extraInfo.canonicalTitle];
        }

        return ratings;
    }

    return nil;
}


- (NSString*) ratingsFile {
    return [Application ratingsFile:[self.model.ratingsProviders objectAtIndex:1]];
}


@end