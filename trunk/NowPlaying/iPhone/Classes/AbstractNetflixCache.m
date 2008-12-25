//
//  AbstractNetflixCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractNetflixCache.h"

#import "NowPlayingModel.h"

@implementation AbstractNetflixCache

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
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
    OAConsumer* consumer = [OAConsumer consumerWithKey:@"83k9wpqt34hcka5bfb2kkf8s"
                                                secret:@"GGR5uHEucN"];
    
    OAToken* token = [OAToken tokenWithKey:model.netflixKey
                                    secret:model.netflixSecret];
    
    OAMutableURLRequest* request =
    [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                               consumer:consumer
                                  token:token
                                  realm:nil];
    
    return request;
}

@end
