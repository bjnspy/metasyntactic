//
//  NetflixCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixCache.h"

#import "Application.h"
#import "Feed.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OAToken.h"
#import "ThreadingUtilities.h"
#import "XmlElement.h"

@interface NetflixCache()
@property (retain) NSArray* feedsData;
@property (retain) NSMutableDictionary* queuesData;
@end


@implementation NetflixCache

static NSSet* allowableFeeds = nil;

+ (void) initialize {
    if (self == [NetflixCache class]) {
        allowableFeeds = [[NSSet setWithObjects:
                          @"http://schemas.netflix.com/feed.queues.disc",
                          @"http://schemas.netflix.com/feed.queues.disc.recent",
                          @"http://schemas.netflix.com/feed.queues.instant",
                          @"http://schemas.netflix.com/feed.queues.instant.recent",
                          @"http://schemas.netflix.com/feed.at_home",
                          @"http://schemas.netflix.com/feed.rental_history.watched",
                          @"http://schemas.netflix.com/feed.rental_history.returned",
                          @"http://schemas.netflix.com/feed.recommendations", nil] retain];
    }
}

@synthesize feedsData;
@synthesize queuesData;

- (void) dealloc {
    self.feedsData = nil;
    self.queuesData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
}


+ (NetflixCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[NetflixCache alloc] initWithModel:model] autorelease];
}


- (NSString*) noInformationFound {
    if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
        return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
        return NSLocalizedString(@"Network unavailable", nil);
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSSet set];
}


- (NSString*) feedsFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Feeds.plist"];
}


- (NSString*) queuesFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Queues.plist"];
}


- (NSArray*) loadFeeds {
    NSArray* array = [FileUtilities readObject:self.feedsFile];
    if (array.count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Feed feedWithDictionary:dictionary]];
    }
    return result;
}


- (NSArray*) feeds {
    if (feedsData == nil) {
        self.feedsData = [self loadFeeds];
    }
    
    return feedsData;
}


- (NSMutableDictionary*) loadQueues {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSDictionary* dictionary = [FileUtilities readObject:self.queuesFile];
    
    for (NSString* key in dictionary) {
        NSArray* array = [dictionary objectForKey:key];
        NSMutableArray* movies = [NSMutableArray array];
        
        for (NSDictionary* encodedMovie in array) {
            [movies addObject:[Movie movieWithDictionary:encodedMovie]];
        }
        
        [result setObject:array forKey:key];
    }
    
    return result;
}


- (NSMutableDictionary*) queues {
    if (queuesData == nil) {
        self.queuesData = [self loadQueues];
    }
    
    return queuesData;
}


- (NSArray*) queueForFeed:(Feed*) feed {
    return [self.queues objectForKey:feed.key];
}


- (void) clear {
    [Application resetNetflixDirectories];
    self.feedsData = nil;
    self.queuesData = nil;
    
    [NowPlayingAppDelegate majorRefresh:YES];
}


- (void) update {
    if (model.netflixUserId.length == 0) {
        [self clear];
        return;
    }
        
    [ThreadingUtilities performSelector:@selector(updateBackgroundEntryPoint)
                               onTarget:self
                   inBackgroundWithGate:gate
                                visible:YES];
}


- (NSArray*) downloadFeeds {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", model.netflixUserId];
    
    OAConsumer* consumer = [OAConsumer consumerWithKey:@"83k9wpqt34hcka5bfb2kkf8s"
                                                secret:@"GGR5uHEucN"];
    
    OAToken* token = [OAToken tokenWithKey:model.netflixKey
                                    secret:model.netflixSecret];
    
    OAMutableURLRequest* request =
    [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                               consumer:consumer
                                  token:token
                                  realm:nil];
    [request prepare];
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];

    NSMutableArray* feeds = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        if ([child.name isEqual:@"link"]) {
            NSString* key = [child attributeValue:@"rel"];
            
            if ([allowableFeeds containsObject:key]) {
                Feed* feed = [Feed feedWithUrl:[child attributeValue:@"href"]
                                           key:key
                                          name:[child attributeValue:@"title"]];
                
                [feeds addObject:feed];
            }
        }
    }
    
    return feeds;
}


- (void) downloadQueue {
    NSString* address = [NSString stringWithFormat:@""];
}


- (void) saveFeeds:(NSArray*) feeds {
    NSMutableArray* result = [NSMutableArray array];
    
    for (Feed* feed in feeds) {
        [result addObject:feed.dictionary];
    }
    
    [FileUtilities writeObject:result toFile:self.feedsFile];
}


- (void) downloadQueues:(NSArray*) feeds {
    
}


- (void) updateBackgroundEntryPoint {
    if (model.netflixUserId.length == 0) {
        return;
    }
    
    //[NSThread sleepForTimeInterval:5];

    NSArray* feeds = [self downloadFeeds];
    if (feeds.count > 0) {
        [self saveFeeds:feeds];
        [self performSelectorOnMainThread:@selector(reportResults:) withObject:feeds waitUntilDone:NO];

        [self downloadQueues:feeds];
    }
}


- (BOOL) feedsContainsKey:(NSString*) key {
    for (Feed* feed in self.feeds) {
        if ([feed.key isEqual:key]) {
            return YES;
        }
    }

    return NO;
}


- (void) saveQueues {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    for (NSString* key in self.queues) {
        NSArray* movies = [self.queues objectForKey:key];
        NSMutableArray* encoded = [NSMutableArray array];
        
        for (Movie* movie in movies) {
            [encoded addObject:movie.dictionary];
        }
        
        [result setObject:encoded forKey:key];
    }
    
    [FileUtilities writeObject:result toFile:self.queuesFile];
}


- (void) reportResults:(NSArray*) feeds {
    self.feedsData = feeds;
    
    for (NSString* key in self.queues.allKeys) {
        if (![self feedsContainsKey:key]) {
            [self.queues removeObjectForKey:key];
        }
    }
    [self saveQueues];
    
    [NowPlayingAppDelegate majorRefresh:YES];
}

@end