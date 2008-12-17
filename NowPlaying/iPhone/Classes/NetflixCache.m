//
//  NetflixCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "Feed.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "IdentitySet.h"
#import "Queue.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface NetflixCache()
@property (retain) NSArray* feedsData;
@property (retain) NSMutableDictionary* queues;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSDictionary* identifierToDetailsData;
@end


@implementation NetflixCache

static NSString* title_key = @"title";
static NSString* synopsis_key = @"synopsis";
static NSString* directors_key = @"directors";
static NSString* cast_key = @"cast";

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
@synthesize prioritizedMovies;
@synthesize identifierToDetailsData;

- (void) dealloc {
    self.feedsData = nil;
    self.queues = nil;
    self.prioritizedMovies = nil;
    self.identifierToDetailsData = nil;
    
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.queues = [NSMutableDictionary dictionary];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
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
            [Application netflixQueuesDirectory],
            [Application netflixPostersDirectory],
            [Application netflixSynopsesDirectory],
            [Application netflixCastDirectory], nil];
}


- (NSString*) identifierToDetailsFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Index.plist"];
}


- (NSMutableDictionary*) loadIdentifierToDetails {
    NSDictionary* dictionary = [FileUtilities readObject:[self identifierToDetailsFile]];
    if (dictionary.count == 0) {
        return [NSMutableDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:dictionary];
}


- (NSDictionary*) identifierToDetails {
    if (identifierToDetailsData == nil) {
        self.identifierToDetailsData = [self loadIdentifierToDetails];
    }
    
    return identifierToDetailsData;
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


- (NSArray*) downloadFeeds {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];

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
               saved:(NSMutableArray*) saved 
 identifierToDetails:(NSMutableDictionary*) identifierToDetails {
    if (![@"queue_item" isEqual:element.name] &&
        ![@"rental_history_item" isEqual:element.name] &&
        ![@"at_home_item" isEqual:element.name] &&
        ![@"recommendation" isEqual:element.name]) {
        return;
    }
    
    NSMutableDictionary* detailLinks = [NSMutableDictionary dictionary];
    
    NSString* identifier = nil;
    NSString* title = nil;
    NSString* link = nil;
    NSString* poster = nil;
    NSString* rating = nil;
    NSString* year = nil;
    NSMutableArray* genres = [NSMutableArray array];
    BOOL save = NO;
    
    for (XmlElement* child in element.children) {
        if ([@"id" isEqual:child.name]) {
            identifier = child.text;
        } else if ([@"link" isEqual:child.name]) {
            NSString* rel = [child attributeValue:@"rel"];
            if ([@"alternate" isEqual:rel]) {
                link = [child attributeValue:@"href"];
            } else if ([@"http://schemas.netflix.com/catalog/title" isEqual:rel]) {
                [detailLinks setObject:[child attributeValue:@"href"] forKey:title_key];
            } else if ([@"http://schemas.netflix.com/catalog/people.cast" isEqual:rel]) {
                [detailLinks setObject:[child attributeValue:@"href"] forKey:cast_key];
            } else if ([@"http://schemas.netflix.com/catalog/people.directors" isEqual:rel]) {
                [detailLinks setObject:[child attributeValue:@"href"] forKey:directors_key];
            } else if ([@"http://schemas.netflix.com/catalog/titles/synopsis" isEqual:rel]) {
                [detailLinks setObject:[child attributeValue:@"href"] forKey:synopsis_key];
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
                [genres addObject:[child attributeValue:@"label"]];
            } else if ([@"http://api.netflix.com/categories/queue_availability" isEqual:scheme]) {
                save = [[child attributeValue:@"label"] isEqual:@"saved"];
            }
        } else if ([@"release_year" isEqual:child.name]) {
            year = child.text;
        }
    }
    
    NSDate* date = nil;
    if (year.length > 0) {
        date = [DateUtilities dateWithNaturalLanguageString:year];
    }
    Movie* movie = [Movie movieWithIdentifier:identifier
                                        title:title
                                       rating:rating
                                       length:0
                                  releaseDate:date
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
    
    [identifierToDetails setObject:detailLinks forKey:identifier];
}


- (void) saveQueue:(Queue*) queue fromFeed:(Feed*) feed {
    [FileUtilities writeObject:queue.dictionary toFile:[self queueFile:feed]];
}


- (void) downloadQueue:(Feed*) feed 
   identifierToDetails:(NSMutableDictionary*) identifierToDetails {
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
            [self processItem:child
                       movies:movies
                        saved:saved
          identifierToDetails:identifierToDetails];
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
    
    if (identifierToDetails.count > 0) {
        [self performSelectorOnMainThread:@selector(reportIdentifierToDetails:)
                               withObject:identifierToDetails
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
    NSMutableDictionary* identifierToDetails = [NSMutableDictionary dictionary];
    for (Feed* feed in feeds) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadQueue:feed
            identifierToDetails:identifierToDetails];
        }
        [pool release];
    }
    
    if (identifierToDetails.count > 0) {
        [FileUtilities writeObject:identifierToDetails toFile:self.identifierToDetailsFile];
    }
}


- (void) reportIdentifierToDetails:(NSDictionary*) map {
    self.identifierToDetailsData = map;
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
    
    [self performSelectorOnMainThread:@selector(updateDetails) withObject:nil waitUntilDone:NO];
}


- (void) updateDetails {
    NSMutableArray* queues_list = [NSMutableArray array];
    for (Feed* feed in self.feeds) {
        Queue* queue = [self queueForFeed:feed];
        if (queue != nil) {
            [queues_list addObject:queue];
        }
    }
    
    NSArray* arguments = [NSArray arrayWithObjects:self.identifierToDetails, queues_list, nil];
    
    [ThreadingUtilities performSelector:@selector(updateDetailsBackgroundEntryPoint:)
                               onTarget:self 
               inBackgroundWithArgument:arguments
                                   gate:nil // no lock for updating details
                                visible:NO];
    
}


- (NSString*) posterFile:(Movie*) movie {
    return
    [[[Application netflixPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFile:(Movie*) movie {
    NSString* fileName = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    fileName = [fileName stringByAppendingString:@"-small.png"];
    return [[Application netflixPostersDirectory] stringByAppendingPathComponent:fileName];
}


- (void) updatePoster:(Movie*) movie
  identifierToDetails:(NSDictionary*) identifierToDetails {
    if (movie.poster.length == 0) {
        return;
    }
    
    NSString* path = [self posterFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster important:NO];
    if (data.length > 0) {
        [FileUtilities writeData:data toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) synopsisFile:(Movie*) movie {
    return
    [[[Application netflixSynopsesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) cleanupSynopsis:(NSString*) synopsis {
    NSInteger index = 0;
    
    NSRange range;
    while ((range = [synopsis rangeOfString:@"<a href"
                                    options:0
                                      range:NSMakeRange(index, synopsis.length - index)]).length > 0) {
        NSRange closeAngleRange = [synopsis rangeOfString:@">"
                                                  options:0
                                                    range:NSMakeRange(range.location, synopsis.length - range.location)];
        index = range.location + 1;
        if (closeAngleRange.length > 0) {
            synopsis = [NSString stringWithFormat:@"%@%@", [synopsis substringToIndex:range.location], [synopsis substringFromIndex:closeAngleRange.location + 1]];
        }
    }
    
    return [Utilities stripHtmlCodes:synopsis];
}


- (void) updateSynopsis:(Movie*) movie
    identifierToDetails:(NSDictionary*) identifierToDetails {
    NSString* address = [[identifierToDetails objectForKey:movie.identifier] objectForKey:synopsis_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self synopsisFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    NSString* synopsis = element.text;
    
    synopsis = [self cleanupSynopsis:synopsis];
    
    if (synopsis.length > 0) {
        [FileUtilities writeObject:synopsis toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) castFile:(Movie*) movie {
    return
    [[[Application netflixCastDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSArray*) extractPeople:(XmlElement*) element {
    NSMutableArray* cast = [NSMutableArray array];

    for (XmlElement* child in element.children) {
        if (cast.count >= 6) {
            // cap the number of actors we care about
            break;
        }
        
        if (![child.name isEqual:@"person"]) {
            continue;
        }
        
        NSString* name = [[child element:@"name"] text];
        if (name.length > 0) {
            [cast addObject:name];
        }
    }
    
    return cast;
}


- (void)       updateCast:(Movie*) movie
      identifierToDetails:(NSDictionary*) identifierToDetails {
    NSString* address = [[identifierToDetails objectForKey:movie.identifier] objectForKey:cast_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self castFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    
    NSArray* cast = [self extractPeople:element];
    
    if (cast.count > 0) {
        [FileUtilities writeObject:cast toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) directorsFile:(Movie*) movie {
    return [[[Application netflixDirectorsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateDirectors:(Movie*) movie
     identifierToDetails:(NSDictionary*) identifierToDetails {
    NSString* address = [[identifierToDetails objectForKey:movie.identifier] objectForKey:directors_key];
    if (address.length == 0) {
        return;
    }
    
    NSString* path = [self directorsFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
   
    NSArray* directors = [self extractPeople:element];
    
    if (directors.count > 0) {
        [FileUtilities writeObject:directors toFile:path];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSString*) imdbFile:(Movie*) movie {
    return [[[Application netflixIMDbDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void)       updateIMDb:(Movie*) movie
      identifierToDetails:(NSDictionary*) identifierToDetails {
    NSString* path = [self imdbFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:path];
    
    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:path];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }
        
        // we have a sentinel.  only update if it's been long enough
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (imdbAddress == nil) {
        return;
    }
    
    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:imdbAddress toFile:path];
    if (imdbAddress.length > 0) {
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (void) updateDetails:(Movie*) movie
   identifierToDetails:(NSDictionary*) identifierToDetails {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {    
        [self updatePoster:movie identifierToDetails:identifierToDetails];
        [self updateSynopsis:movie identifierToDetails:identifierToDetails];
        [self updateCast:movie identifierToDetails:identifierToDetails];
        [self updateDirectors:movie identifierToDetails:identifierToDetails];
        [self updateIMDb:movie identifierToDetails:identifierToDetails];
    }
    [pool release];
}


- (void) prioritizeMovie:(Movie*) movie {
    if ([self.identifierToDetails objectForKey:movie.identifier] == nil) {
        return;
    }

    [prioritizedMovies addObject:movie];
}


- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie = [prioritizedMovies removeLastObjectAdded];
    
    if (movie != nil) {
        return movie;
    }
    
    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }
    
    return nil;
}


- (void) updateDetailsBackgroundEntryPoint:(NSArray*) arguments {
    NSDictionary* identifierToDetails = [arguments objectAtIndex:0];
    NSArray* queues_list = [arguments objectAtIndex:1];

    NSMutableArray* movies = [NSMutableArray array];
    
    for (Queue* queue in queues_list) {
        [movies addObjectsFromArray:queue.movies];
        [movies addObjectsFromArray:queue.saved];
    }
    
    Movie* movie;
    while ((movie = [self getNextMovie:movies]) != nil) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self updateDetails:movie identifierToDetails:identifierToDetails];
        }
        [pool release];
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

    OAMutableURLRequest* request = [self createURLRequest:address];
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
    
    Queue* finalQueue = [Queue queueWithFeedKey:queue.feedKey
                                           etag:etag
                                         movies:movies
                                          saved:queue.saved];
    
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
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    
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


- (UIImage*) posterForMovie:(Movie*) movie {
    NSData* data = [FileUtilities readData:[self posterFile:movie]];
    return [UIImage imageWithData:data];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    NSString* smallPosterPath = [self smallPosterFile:movie];
    NSData* smallPosterData;
    
    if ([FileUtilities size:smallPosterPath] == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self posterFile:movie]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];
        
        [FileUtilities writeData:smallPosterData
                          toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }
    
    return [UIImage imageWithData:smallPosterData];
}


- (NSArray*) castForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self castFile:movie]];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self directorsFile:movie]];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self imdbFile:movie]];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self synopsisFile:movie]];
}


+ (NSString*) recommendationKey {
    return @"http://schemas.netflix.com/feed.recommendations";
}


- (Feed*) feedForKey:(NSString*) key {
    for (Feed* feed in self.feeds) {
        if ([key isEqual:feed.key]) {
            return feed;
        }
    }

    return nil;
}


@end