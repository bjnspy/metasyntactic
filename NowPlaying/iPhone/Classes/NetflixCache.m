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
@property (retain) NSMutableDictionary* queues;
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
@synthesize queues;

- (void) dealloc {
    self.feedsData = nil;
    self.queues = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.queues = [NSMutableDictionary dictionary];
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
    return [NSSet setWithObjects:
            [Application netflixDirectory],
            [Application netflixQueuesDirectory], nil];
}


- (NSString*) feedsFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Feeds.plist"];
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


- (NSString*) queueFile:(Feed*) feed {
    return [[[Application netflixQueuesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:feed.key]]
            stringByAppendingPathExtension:@"plist"];
}


- (NSArray*) loadQueue:(Feed*) feed {
    NSArray* array = [FileUtilities readObject:[self queueFile:feed]];
    if (array.count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray* result = [NSMutableArray array];        
    for (NSDictionary* encodedMovie in array) {
        [result addObject:[Movie movieWithDictionary:encodedMovie]];
    }
    
    return result;
}


- (NSArray*) queueForFeed:(Feed*) feed {
    NSArray* queue = [queues objectForKey:feed.key];
    if (queue == nil) {
        queue = [self loadQueue:feed];
        [queues setObject:queue forKey:feed.key];
    }
    return queue;
}


- (void) clear {
    [Application resetNetflixDirectories];
    self.feedsData = nil;
    self.queues = nil;
    
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


- (void) saveFeeds:(NSArray*) feeds {
    NSMutableArray* result = [NSMutableArray array];
    
    for (Feed* feed in feeds) {
        [result addObject:feed.dictionary];
    }
    
    [FileUtilities writeObject:result toFile:self.feedsFile];
}


- (Movie*) processItem:(XmlElement*) element {
    if (![@"queue_item" isEqual:element.name] &&
        ![@"rental_history_item" isEqual:element.name] &&
        ![@"at_home_item" isEqual:element.name] &&
        ![@"recommendation" isEqual:element.name]) {
        return nil;
    }
    
    NSString* identifier = nil;
    NSString* title = nil;
    NSString* link = nil;
    NSString* poster = nil;
    NSString* rating = nil;
    NSArray* genres = nil;
    
    for (XmlElement* child in element.children) {
        if ([@"id" isEqual:child.name]) {
            identifier = child.text;
        } else if ([@"link" isEqual:child.name]) {
            NSString* rel = [child attributeValue:@"rel"];
            if ([@"alternate" isEqual:rel]) {
                link = [child attributeValue:@"href"];
            }
        } else if ([@"title" isEqual:child.name]) {
            title = [child attributeValue:@"short"];
            if (title == nil) {
                title = [child attributeValue:@"medium"];
            }
        } else if ([@"box_art" isEqual:child.name]) {
            poster = [child attributeValue:@"large"];
            if (poster == nil) {
                poster = [child attributeValue:@"medium"];
                if (poster == nil) {
                    poster = [child attributeValue:@"small"];
                }
            } 
        } else if ([@"category" isEqual:child.name]) {
            NSString* scheme = [child attributeValue:@"scheme"];
            if ([@"http://api.netflix.com/categories/mpaa_ratings" isEqual:scheme]) {
                rating = [child attributeValue:@"label"];
            } else if ([@"http://api.netflix.com/categories/genres" isEqual:scheme]) {
                genres = [NSArray arrayWithObject:[child attributeValue:@"label"]];
            }
        }
    }
    /*
     <position>1</position> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866" rel="http://schemas.netflix.com/catalog/title" title="2010: The Year We Make Contact" /> 
     <title short="2010: The Year We Make Contact" regular="2010: The Year We Make Contact" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/synopsis" rel="http://schemas.netflix.com/catalog/titles/synopsis" title="synopsis" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/cast" rel="http://schemas.netflix.com/catalog/people.cast" title="cast" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/directors" rel="http://schemas.netflix.com/catalog/people.directors" title="directors" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/awards" rel="http://schemas.netflix.com/catalog/titles/awards" title="awards" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/format_availability" rel="http://schemas.netflix.com/catalog/titles/format_availability" title="formats" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/screen_formats" rel="http://schemas.netflix.com/catalog/titles/screen_formats" title="screen formats" /> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/languages_and_audio" rel="http://schemas.netflix.com/catalog/titles/languages_and_audio" title="languages and audio" /> 
     <average_rating>3.5</average_rating> 
     <link href="http://api.netflix.com/catalog/titles/movies/207866/similars" rel="http://schemas.netflix.com/catalog/titles.similars" title="similars" /> 
     <link href="http://www.netflix.com/Movie/2010_The_Year_We_Make_Contact/207866" rel="alternate" title="web page" /> 
     </queue_item>
     */
    
    Movie* movie = [Movie movieWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:0
                                  releaseDate:nil
                                  imdbAddress:nil
                                       poster:poster
                                     synopsis:nil
                                       studio:nil
                                    directors:nil
                                         cast:nil
                                       genres:genres];
                
    return movie;
}


- (void) saveQueue:(NSArray*) queue feed:(Feed*) feed {
    NSMutableArray* encoded = [NSMutableArray array];
    
    for (Movie* movie in queue) {
        [encoded addObject:movie.dictionary];
    }
    
    [FileUtilities writeObject:encoded toFile:[self queueFile:feed]];
}


- (void) downloadQueue:(Feed*) feed {
    NSRange range = [feed.url rangeOfString:@"&output=atom"];
    NSString* url = feed.url;
    if (range.length > 0) {
        url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
    }
    
    NSString* address = [NSString stringWithFormat:@"%@&max_results=500", url];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES];
    
    NSMutableArray* queue = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = [self processItem:child];
            if (movie != nil) {
                [queue addObject:movie];
            }
        }
        [pool release];
    }
    
    if (queue.count > 0) {
        [self saveQueue:queue feed:feed];
        [self performSelectorOnMainThread:@selector(reportQueue:)
                               withObject:[NSArray arrayWithObjects:feed, queue, nil]
                            waitUntilDone:NO];
    }
}


- (void) reportQueue:(NSArray*) arguments {
    Feed* feed = [arguments objectAtIndex:0];
    NSArray* queue = [arguments objectAtIndex:1];
    
    [queues setObject:queue forKey:feed.key];
}


- (void) downloadQueues:(NSArray*) feeds {
    for (Feed* feed in feeds) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadQueue:feed];
        }
        [pool release];
    }
}


- (void) updateBackgroundEntryPoint {
    if (model.netflixUserId.length == 0) {
        return;
    }

    NSArray* feeds = [self downloadFeeds];
    if (feeds.count > 0) {
        [self saveFeeds:feeds];
        [self performSelectorOnMainThread:@selector(reportFeeds:) withObject:feeds waitUntilDone:NO];

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



- (void) reportFeeds:(NSArray*) feeds {
    self.feedsData = feeds;
    
    for (NSString* key in self.queues.allKeys) {
        if (![self feedsContainsKey:key]) {
            [self.queues removeObjectForKey:key];
        }
    }
    
    [NowPlayingAppDelegate majorRefresh:YES];
}

@end