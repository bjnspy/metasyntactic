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

#import "GoogleScoreProvider.h"

#import "NowPlaying.pb.h"

#import "Application.h"
#import "DateUtilities.h"
#import "Location.h"
#import "MovieRating.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "UserLocationCache.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation GoogleScoreProvider

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


+ (GoogleScoreProvider*) downloaderWithModel:(NowPlayingModel*) model {
    return [[[GoogleScoreProvider alloc] initWithModel:model] autorelease];
}


+ (NSString*) serverUrl:(NowPlayingModel*) model {
    Location* location = [model.userLocationCache locationForUserAddress:model.userAddress];
    
    if (location.postalCode == nil) {
        return nil;
    }
    
    NSString* country = location.country.length == 0 ? [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
    : location.country;
    
    
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                   fromDate:[DateUtilities today]
                                                                     toDate:model.searchDate
                                                                    options:0];
    NSInteger day = components.day;
    day = MIN(MAX(day, 0), 7);
    
    NSString* address = [NSString stringWithFormat:
                         @"http://%@.appspot.com/LookupTheaterListings2?country=%@&language=%@&postalcode=%@&day=%d&format=pb&latitude=%d&longitude=%d",
                         [Application host],
                         country,
                         [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                         [Utilities stringByAddingPercentEscapes:location.postalCode],
                         day,
                         (int)(location.latitude * 1000000),
                         (int)(location.longitude * 1000000)];
    
    return address;
}


+ (NSString*) lookupServerHash:(NowPlayingModel*) model {
    NSString* baseAddress = [self serverUrl:model];
    NSString* address = [baseAddress stringByAppendingString:@"&hash=true"];
    NSString* value = [NetworkUtilities stringWithContentsOfAddress:address
                                                          important:YES];
    return value;
}


- (NSDictionary*) lookupMovieListings {
    NSString* address = [GoogleScoreProvider serverUrl:self.model];
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:address
                                                     important:YES];
    if (data != nil) {
        @try {
            TheaterListingsProto* theaterListings = [TheaterListingsProto parseFromData:data];
            NSArray* movieProtos = theaterListings.moviesList;

            NSMutableDictionary* ratings = [NSMutableDictionary dictionary];

            for (MovieProto* movieProto in movieProtos) {
                NSString* identifier = movieProto.identifier;
                NSString* title = movieProto.title;
                NSInteger score = -1;
                if (movieProto.hasScore) {
                    score = movieProto.score;
                }

                MovieRating* info = [MovieRating ratingWithTitle:title
                                                        synopsis:@""
                                                           score:[NSString stringWithFormat:@"%d", score]
                                                        provider:@"google"
                                                      identifier:identifier];

                [ratings setObject:info forKey:info.canonicalTitle];
            }

            return ratings;
        } @catch (NSException* e) {
        }
    }

    return nil;
}


- (NSString*) ratingsFile {
    return [Application ratingsFile:[self.model.ratingsProviders objectAtIndex:2]];
}

@end