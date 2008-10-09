//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

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