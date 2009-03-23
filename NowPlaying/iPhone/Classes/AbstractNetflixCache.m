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

#import "AbstractNetflixCache.h"

#import "Application.h"
#import "Model.h"

@implementation AbstractNetflixCache

- (void) dealloc {
    [super dealloc];
}


+ (NSString*) recommendationKey {
    return @"http://schemas.netflix.com/feed.recommendations";
}


+ (NSString*) dvdQueueKey {
    return @"http://schemas.netflix.com/feed.queues.disc";
}


+ (NSString*) instantQueueKey {
    return @"http://schemas.netflix.com/feed.queues.instant";
}


+ (NSString*) atHomeKey {
    return @"http://schemas.netflix.com/feed.at_home";
}


+ (NSString*) rentalHistoryKey {
    return @"http://schemas.netflix.com/feed.rental_history";
}


+ (NSString*) rentalHistoryWatchedKey {
    return @"http://schemas.netflix.com/feed.rental_history.watched";
}


+ (NSString*) rentalHistoryReturnedKey {
    return @"http://schemas.netflix.com/feed.rental_history.returned";
}


- (OAMutableURLRequest*) createURLRequest:(NSString*) address {
    OAConsumer* consumer = [OAConsumer consumerWithKey:[Application netflixKey]
                                                secret:[Application netflixSecret]];

    OAToken* token = [OAToken tokenWithKey:self.model.netflixKey
                                    secret:self.model.netflixSecret];

    OAMutableURLRequest* request =
    [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                               consumer:consumer
                                  token:token
                                  realm:nil];

    return request;
}

@end