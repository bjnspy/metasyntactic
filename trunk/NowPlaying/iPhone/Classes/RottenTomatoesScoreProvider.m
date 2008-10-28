// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RottenTomatoesScoreProvider.h"

#import "Application.h"
#import "Score.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "XmlElement.h"

@implementation RottenTomatoesScoreProvider

- (void) dealloc {
    [super dealloc];
}


- (id) initWithCache:(ScoreCache*) cache_ {
    if (self = [super initWithCache:cache_]) {
    }

    return self;
}


+ (RottenTomatoesScoreProvider*) providerWithCache:(ScoreCache*) cache {
    return [[[RottenTomatoesScoreProvider alloc] initWithCache:cache] autorelease];
}


- (NSString*) providerName {
    return @"RottenTomatoes";
}


- (NSString*) lookupServerHash {
    NSString* value = [NetworkUtilities stringWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieRatings?q=rottentomatoes&format=xml&hash=true", [Application host]]
                                                          important:YES];
    return value;
}


- (NSDictionary*) lookupServerScores {
    XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:[NSString stringWithFormat:@"http://%@.appspot.com/LookupMovieRatings?q=rottentomates&format=xml", [Application host]]
                                                                 important:YES];

    if (resultElement != nil) {
        NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

        for (XmlElement* movieElement in resultElement.children) {
            NSString* title =    [movieElement attributeValue:@"title"];
            NSString* link =     [movieElement attributeValue:@"link"];
            NSString* synopsis = [movieElement attributeValue:@"synopsis"];
            NSString* score =    [movieElement attributeValue:@"score"];

            Score* extraInfo = [Score scoreWithTitle:title
                                                         synopsis:synopsis
                                                            score:score
                                                         provider:@"rottentomatoes"
                                                       identifier:link];


            [ratings setObject:extraInfo forKey:extraInfo.canonicalTitle];
        }

        return ratings;
    }

    return nil;
}


@end