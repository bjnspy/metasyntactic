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
#import "NetflixReorderQueueDelegate.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "IdentitySet.h"
#import "Queue.h"
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
                          @"http://schemas.netflix.com/feed.queues.instant",
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


- (Queue*) loadQueue:(Feed*) feed {
    NSDictionary* dictionary = [FileUtilities readObject:[self queueFile:feed]];
    if (dictionary.count == 0) {
        return nil;
    }
    
    return [Queue queueWithDictionary:dictionary];
}


- (Queue*) queueForFeed:(Feed*) feed {
    Queue* queue = [queues objectForKey:feed.key];
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


- (void) processItem:(XmlElement*) element
              movies:(NSMutableArray*) movies
               saved:(NSMutableArray*) saved {
    if (![@"queue_item" isEqual:element.name] &&
        ![@"rental_history_item" isEqual:element.name] &&
        ![@"at_home_item" isEqual:element.name] &&
        ![@"recommendation" isEqual:element.name]) {
        return;
    }
    
    NSString* identifier = nil;
    NSString* title = nil;
    NSString* link = nil;
    NSString* poster = nil;
    NSString* rating = nil;
    NSArray* genres = nil;
    BOOL save = NO;
    
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
            } else if ([@"http://api.netflix.com/categories/queue_availability" isEqual:scheme]) {
                save = [[child attributeValue:@"label"] isEqual:@"saved"];
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
                
    if (save) {
        [saved addObject:movie];
    } else {
        [movies addObject:movie];
    }
}


- (void) saveQueue:(Queue*) queue fromFeed:(Feed*) feed {
    [FileUtilities writeObject:queue.dictionary toFile:[self queueFile:feed]];
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
    
    NSString* etag = [[element element:@"etag"] text];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self processItem:child movies:movies saved:saved];
        }
        [pool release];
    }
    
    if (movies.count > 0 || saved.count > 0) {
        Queue* queue = [Queue queueWithFeedKey:feed.key etag:etag movies:movies saved:saved];
        [self saveQueue:queue fromFeed:feed];
        [self performSelectorOnMainThread:@selector(reportQueue:)
                               withObject:[NSArray arrayWithObjects:queue, feed, nil]
                            waitUntilDone:NO];
    }
}


- (void) reportQueue:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    
    [queues setObject:queue forKey:feed.key];
    [NowPlayingAppDelegate majorRefresh];
}


- (void) reportMoveFailure:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    Movie* movie = [arguments objectAtIndex:2];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:3];
    
    [delegate moveFailedWithError:nil forMovie:movie inQueue:queue fromFeed:feed];
}


- (void) reportMoveSuccess:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    Movie* movie = [arguments objectAtIndex:2];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:3];
    
    [self reportQueue:arguments];
    
    [delegate moveSucceededForMovie:movie inQueue:queue fromFeed:feed];
}


- (void) reportQueueAndError:(NSArray*) arguments {
    [self reportQueue:arguments];

    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:2];
    
    [delegate modifyFailedWithError:nil inQueue:queue fromFeed:feed];
}


- (void) reportQueueAndSuccess:(NSArray*) arguments {
    [self reportQueue:arguments];
    
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:2];
    
    [delegate modifySucceededInQueue:queue fromFeed:feed];
}


- (void) saveQueue:(Queue*) queue
          fromFeed:(Feed*) feed
    andReportError:(id<NetflixModifyQueueDelegate>) delegate {
    [self saveQueue:queue fromFeed:feed];
    NSArray* arguments = [NSArray arrayWithObjects:queue, feed, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndError:) withObject:arguments waitUntilDone:NO];
}


- (void) saveQueue:(Queue*) queue
          fromFeed:(Feed*) feed
    andReportSuccess:(id<NetflixModifyQueueDelegate>) delegate {
    [self saveQueue:queue fromFeed:feed];
    NSArray* arguments = [NSArray arrayWithObjects:queue, feed, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportQueueAndSuccess:) withObject:arguments waitUntilDone:NO];
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
    
    [NowPlayingAppDelegate majorRefresh];
}


- (void) updateQueue:(Queue*) queue
            fromFeed:(Feed*) feed
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixModifyQueueDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:queue, feed, movie, delegate, nil];
    
    [ThreadingUtilities performSelector:@selector(moveMovieToTopOfQueueBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate
                                visible:YES];
}


- (Queue*) moveMovie:(Movie*) movie
          toPosition:(NSInteger) position
             inQueue:(Queue*) queue
            fromFeed:(Feed*) feed
            delegate:(id<NetflixModifyQueueDelegate>) delegate {
    NSString* queueType = queue.isDVDQueue ? @"disc" : @"instant";
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/queues/%@", model.netflixUserId, queueType];
    
    OAConsumer* consumer = [OAConsumer consumerWithKey:@"83k9wpqt34hcka5bfb2kkf8s"
                                                secret:@"GGR5uHEucN"];
    
    OAToken* token = [OAToken tokenWithKey:model.netflixKey
                                    secret:model.netflixSecret];
    
    OAMutableURLRequest* request =
    [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                               consumer:consumer
                                  token:token
                                  realm:nil];
    
    [request setHTTPMethod:@"POST"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"title_ref" value:movie.identifier],
                           [OARequestParameter parameterWithName:@"position" value:[NSString stringWithFormat:@"%d", position + 1]],
                           [OARequestParameter parameterWithName:@"etag" value:queue.etag], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];
    
    NSInteger status = [[[element element:@"status_code"] text] intValue];
    if (status < 200 || status >= 300) {
        return nil;
    }
    
    NSString* etag = [[element element:@"etag"] text];
    NSMutableArray* movies = [NSMutableArray arrayWithArray:queue.movies];
    [movies removeObjectIdenticalTo:movie];
    [movies insertObject:movie atIndex:position];
    
    Queue* finalQueue = [Queue queueWithFeedKey:queue.feedKey etag:etag movies:movies saved:queue.saved];
    
    return finalQueue;
}


- (void) moveMovieToTopOfQueueBackgroundEntryPoint:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    Movie* movie = [arguments objectAtIndex:2];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:3];
    
    Queue* finalQueue = [self moveMovie:movie
                             toPosition:0 
                                inQueue:queue
                               fromFeed:feed
                               delegate:delegate];
    if (finalQueue == nil) {
        [self performSelectorOnMainThread:@selector(reportMoveFailure:) withObject:arguments waitUntilDone:NO];
        return;
    }
    
    [self saveQueue:finalQueue fromFeed:feed];
    
    NSArray* finalArguments = [NSArray arrayWithObjects:finalQueue, feed, movie, delegate, nil];
    [self performSelectorOnMainThread:@selector(reportMoveSuccess:)
                           withObject:finalArguments
                        waitUntilDone:NO];
}


- (void) updateQueue:(Queue*) queue
            fromFeed:(Feed*) feed
    byDeletingMovies:(IdentitySet*) deletedMovies
 andReorderingMovies:(IdentitySet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate {
    NSArray* arguments = [NSArray arrayWithObjects:queue, feed, deletedMovies, reorderedMovies, movies, delegate, nil];
    
    [ThreadingUtilities performSelector:@selector(updateQueueBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate
                                visible:YES];
}


- (BOOL) deleteMovie:(Movie*) movie
             inQueue:(Queue*) queue
            fromFeed:(Feed*) feed
            delegate:(id<NetflixModifyQueueDelegate>) delegate {
    NSString* address = movie.identifier;
    
    OAConsumer* consumer = [OAConsumer consumerWithKey:@"83k9wpqt34hcka5bfb2kkf8s"
                                                secret:@"GGR5uHEucN"];
    
    OAToken* token = [OAToken tokenWithKey:model.netflixKey
                                    secret:model.netflixSecret];
    
    OAMutableURLRequest* request =
    [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                               consumer:consumer
                                  token:token
                                  realm:nil];
    
    [request setHTTPMethod:@"DELETE"];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];
    NSInteger status = [[[element element:@"status"] text] intValue];
    if (status < 200 || status >= 300) {
        NSArray* arguments = [NSArray arrayWithObjects:queue, feed, delegate, nil];
        [self performSelectorOnMainThread:@selector(reportModifyFailure:) withObject:arguments waitUntilDone:NO];
        return NO;
    }

    return YES;
}
    

- (void) reportModifyFailure:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:2];
    
    [delegate modifyFailedWithError:nil inQueue:queue fromFeed:feed];
}


NSInteger orderMovies(id t1, id t2, void* context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    NSArray* moviesInOrder = context;
    
    NSInteger i1 = [moviesInOrder indexOfObjectIdenticalTo:movie1];
    NSInteger i2 = [moviesInOrder indexOfObjectIdenticalTo:movie2];
    
    if (i1 < i2) {
        return NSOrderedAscending;
    } else if (i1 > i2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}


- (void) updateQueueBackgroundEntryPoint:(NSArray*) arguments {
    Queue* queue = [arguments objectAtIndex:0];
    Feed* feed = [arguments objectAtIndex:1];
    IdentitySet* deletedMovies = [arguments objectAtIndex:2];
    IdentitySet* reorderedMovies = [arguments objectAtIndex:3];
    NSArray* moviesInOrder = [arguments objectAtIndex:4];
    id<NetflixModifyQueueDelegate> delegate = [arguments objectAtIndex:5];
    
    Queue* finalQueue = queue;
    
    NSArray* orderedMoviesToReorder = [reorderedMovies.allObjects sortedArrayUsingFunction:orderMovies context:moviesInOrder];
    for (Movie* movie in orderedMoviesToReorder) {
        Queue* resultantQueue = [self moveMovie:movie
                                      toPosition:[moviesInOrder indexOfObjectIdenticalTo:movie]
                                         inQueue:finalQueue
                                        fromFeed:feed
                                        delegate:delegate];
    
        if (resultantQueue == nil) {
            [self saveQueue:finalQueue fromFeed:feed andReportError:delegate];
            return;
        }
        
        finalQueue = resultantQueue;
    }
    
//    for (Movie* movie in deletedMovies.allObjects) {
//        if (![self deleteMovie:movie inQueue:queue fromFeed:(Feed*) feed delegate:delegate]) {
//            return finalQueue;
//        }
        //    }
    [self saveQueue:finalQueue fromFeed:feed andReportSuccess:delegate];
}


@end