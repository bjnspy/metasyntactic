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

#import "NetflixCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "Feed.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageUtilities.h"
#import "IMDbCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetflixAddMovieDelegate.h"
#import "NetflixMoveMovieDelegate.h"
#import "NetflixModifyQueueDelegate.h"
#import "NetworkUtilities.h"
#import "AppDelegate.h"
#import "Model.h"
#import "IdentitySet.h"
#import "Person.h"
#import "PersonPosterCache.h"
#import "Queue.h"
#import "Status.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@interface NetflixCache()
@property (retain) NSArray* feedsData;
@property (retain) NSMutableDictionary* queues;
@property (retain) LinkedSet* normalMovies;
@property (retain) LinkedSet* prioritizedPeople;
@property (retain) LinkedSet* rssMovies;
@property (retain) LinkedSet* searchMovies;
@property (retain) LinkedSet* searchPeople;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSCondition* updateDetailsLock;
@property (retain) NSDate* lastQuotaErrorDate;
@property (retain) NSMutableDictionary* presubmitRatings;

- (void) updateMovieDetails:(Movie*) movie;
@end


@implementation NetflixCache

static NSString* title_key = @"title";
static NSString* series_key = @"series";
static NSString* average_rating_key = @"average_rating";
static NSString* link_key = @"link";
static NSString* filmography_key = @"filmography";
static NSString* availability_key = @"availability";

static NSString* cast_key = @"cast";
static NSString* formats_key = @"formats";
static NSString* synopsis_key = @"synopsis";
static NSString* similars_key = @"similars";
static NSString* directors_key = @"directors";

static NSArray* mostPopularTitles = nil;
static NSDictionary* mostPopularTitlesToAddresses = nil;
static NSDictionary* availabilityMap = nil;

+ (NSArray*) mostPopularTitles {
    return mostPopularTitles;
}


+ (void) initialize {
    if (self == [NetflixCache class]) {
        mostPopularTitles =
        [[NSArray arrayWithObjects:
          NSLocalizedString(@"Top DVDs", nil),
          NSLocalizedString(@"Top 'Instant Watch'", nil),
          NSLocalizedString(@"New DVDs", nil),
          NSLocalizedString(@"New 'Instant Watch'", nil),
          NSLocalizedString(@"Action & Adventure", nil),
          NSLocalizedString(@"Anime & Animation", nil),
          NSLocalizedString(@"Blu-ray", nil),
          NSLocalizedString(@"Children & Family", nil),
          NSLocalizedString(@"Classics", nil),
          NSLocalizedString(@"Comedy", nil),
          NSLocalizedString(@"Documentary", nil),
          NSLocalizedString(@"Drama", nil),
          NSLocalizedString(@"Faith & Spirituality", nil),
          NSLocalizedString(@"Foreign", nil),
          NSLocalizedString(@"Gay & Lesbian", nil),
          NSLocalizedString(@"Horror", nil),
          NSLocalizedString(@"Independent", nil),
          NSLocalizedString(@"Music & Musicals", nil),
          NSLocalizedString(@"Romance", nil),
          NSLocalizedString(@"Sci-Fi & Fantasy", nil),
          NSLocalizedString(@"Special Interest", nil),
          NSLocalizedString(@"Sports & Fitness", nil),
          NSLocalizedString(@"Television", nil),
          NSLocalizedString(@"Thrillers", nil), nil] retain];
        
        mostPopularTitlesToAddresses =
        [[NSDictionary dictionaryWithObjects:
          [NSArray arrayWithObjects:
           @"http://rss.netflix.com/Top100RSS",
           @"http://www.netflix.com/TopWatchInstantlyRSS",
           @"http://rss.netflix.com/NewReleasesRSS",
           @"http://www.netflix.com/NewWatchInstantlyRSS",
           @"http://rss.netflix.com/Top25RSS?gid=296",
           @"http://rss.netflix.com/Top25RSS?gid=623",
           @"http://rss.netflix.com/Top25RSS?gid=2444",
           @"http://rss.netflix.com/Top25RSS?gid=302",
           @"http://rss.netflix.com/Top25RSS?gid=306",
           @"http://rss.netflix.com/Top25RSS?gid=307",
           @"http://rss.netflix.com/Top25RSS?gid=864",
           @"http://rss.netflix.com/Top25RSS?gid=315",
           @"http://rss.netflix.com/Top25RSS?gid=2108",
           @"http://rss.netflix.com/Top25RSS?gid=2514",
           @"http://rss.netflix.com/Top25RSS?gid=330",
           @"http://rss.netflix.com/Top25RSS?gid=338",
           @"http://rss.netflix.com/Top25RSS?gid=343",
           @"http://rss.netflix.com/Top25RSS?gid=2310",
           @"http://rss.netflix.com/Top25RSS?gid=371",
           @"http://rss.netflix.com/Top25RSS?gid=373",
           @"http://rss.netflix.com/Top25RSS?gid=2223",
           @"http://rss.netflix.com/Top25RSS?gid=2190",
           @"http://rss.netflix.com/Top25RSS?gid=2197",
           @"http://rss.netflix.com/Top25RSS?gid=387", nil]
                                     forKeys:mostPopularTitles] retain];
        
        NSAssert(mostPopularTitles.count == mostPopularTitlesToAddresses.count, @"");
        
        availabilityMap =
        [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                              NSLocalizedString(@"Awaiting Release", nil),
                                              NSLocalizedString(@"Available Now", nil),
                                              NSLocalizedString(@"Saved", nil),
                                              NSLocalizedString(@"Short Wait", nil),
                                              NSLocalizedString(@"Short Wait", nil),
                                              NSLocalizedString(@"Long Wait", nil),
                                              NSLocalizedString(@"Very Long Wait", nil),
                                              NSLocalizedString(@"Available Soon", nil),
                                              NSLocalizedString(@"Not Rentable", nil),
                                              NSLocalizedString(@"Unknown Release Date", nil),
                                              NSLocalizedString(@"Unknown Release Date", nil),
                                              NSLocalizedString(@"Unknown Release Date", nil), nil]
                                     forKeys:[NSArray arrayWithObjects:
                                              @"awaiting release",
                                              @"available now",
                                              @"saved",
                                              @"possible short wait",
                                              @"short wait",
                                              @"long wait",
                                              @"very long wait",
                                              @"available soon",
                                              @"not rentable",
                                              @"release date is unknown; availability is not guaranteed.",
                                              @"release date is unknown.",
                                              @"availability date is unknown.", nil]] retain];
    }
}

@synthesize feedsData;
@synthesize queues;
@synthesize normalMovies;
@synthesize prioritizedPeople;
@synthesize rssMovies;
@synthesize searchMovies;
@synthesize searchPeople;
@synthesize prioritizedMovies;
@synthesize updateDetailsLock;
@synthesize lastQuotaErrorDate;
@synthesize presubmitRatings;

- (void) dealloc {
    self.feedsData = nil;
    self.queues = nil;
    self.normalMovies = nil;
    self.prioritizedPeople = nil;
    self.rssMovies = nil;
    self.searchMovies = nil;
    self.searchPeople = nil;
    self.prioritizedMovies = nil;
    self.updateDetailsLock = nil;
    self.lastQuotaErrorDate = nil;
    self.presubmitRatings = nil;
    
    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.queues = [NSMutableDictionary dictionary];
        
        self.normalMovies = [LinkedSet set];
        self.prioritizedPeople = [LinkedSet set];
        self.rssMovies = [LinkedSet set];
        self.searchMovies = [LinkedSet set];
        self.searchPeople = [LinkedSet set];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.updateDetailsLock = [[[NSCondition alloc] init] autorelease];
        self.presubmitRatings = [NSMutableDictionary dictionary];
        
        [ThreadingUtilities backgroundSelector:@selector(updateDetailsBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }
    
    return self;
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


- (NSString*) queueEtagFile:(Queue*) queue {
    NSString* name = [NSString stringWithFormat:@"%@-etag", queue.feed.key];
    return [[[Application netflixQueuesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:name]]
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
    if (feed == nil) {
        return nil;
    }
    
    Queue* queue = [queues objectForKey:feed.key];
    if (queue == nil) {
        queue = [self loadQueue:feed];
        if (queue != nil) {
            [queues setObject:queue forKey:feed.key];
        }
    }
    return queue;
}


- (void) clear {
    [Application resetNetflixDirectories];
    self.feedsData = nil;
    self.queues = nil;
    
    [AppDelegate majorRefresh:YES];
}


- (void) update {
    if (model.netflixUserId.length == 0) {
        [self clear];
    } else {
        [ThreadingUtilities backgroundSelector:@selector(updateBackgroundEntryPoint)
                                      onTarget:self
                                          gate:gate
                                       visible:YES];
    }
}


- (NSArray*) downloadFeeds {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    
    [request prepare];
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:YES];
    
    [self checkApiResult:element];
    
    NSSet* allowableFeeds = [NSSet setWithObjects:
                             [NetflixCache dvdQueueKey],
                             [NetflixCache instantQueueKey],
                             [NetflixCache atHomeKey],
                             [NetflixCache recommendationKey],
                             [NetflixCache rentalHistoryKey],
                             [NetflixCache rentalHistoryWatchedKey],
                             [NetflixCache rentalHistoryReturnedKey], nil];
    
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
    
    if (result.count > 0) {
        [FileUtilities writeObject:result toFile:self.feedsFile];
    }
}


+ (Movie*) processMovieItem:(XmlElement*) element
                      saved:(BOOL*) saved {
    if (element == nil) {
        return nil;
    }
    
    NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
    
    NSString* identifier = nil;
    NSString* title = nil;
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
                [additionalFields setObject:[child attributeValue:@"href"] forKey:link_key];
            } else if ([@"http://schemas.netflix.com/catalog/title" isEqual:rel]) {
                NSString* title = [child attributeValue:@"href"];
                if (identifier.length == 0) {
                    identifier = title;
                }
                
                [additionalFields setObject:[child attributeValue:@"href"] forKey:title_key];
            } else if ([@"http://schemas.netflix.com/catalog/titles.series" isEqual:rel]) {
                [additionalFields setObject:[child attributeValue:@"href"] forKey:series_key];
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
                NSString* label = [child attributeValue:@"label"];
                save = [label isEqual:@"saved"];
                [additionalFields setObject:label forKey:availability_key];
            }
        } else if ([@"release_year" isEqual:child.name]) {
            year = child.text;
        } else if ([average_rating_key isEqual:child.name]) {
            [additionalFields setObject:child.text forKey:average_rating_key];
        }
    }
    
    if (identifier.length == 0) {
        return nil;
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
                                       genres:genres
                             additionalFields:additionalFields];
    
    if (saved != NULL) {
        *saved = save;
    }
    
    return movie;
}


+ (void) processMovieItem:(XmlElement*) element
                   movies:(NSMutableArray*) movies
                    saved:(NSMutableArray*) saved {
    if (![@"queue_item" isEqual:element.name] &&
        ![@"rental_history_item" isEqual:element.name] &&
        ![@"at_home_item" isEqual:element.name] &&
        ![@"recommendation" isEqual:element.name] &&
        ![@"catalog_title" isEqual:element.name]) {
        return;
    }
    
    BOOL save;
    Movie* movie = [self processMovieItem:element saved:&save];
    
    if (movie == nil) {
        return;
    }
    
    if (save) {
        [saved addObject:movie];
    } else {
        [movies addObject:movie];
    }
}


- (void) saveQueue:(Queue*) queue {
    NSLog(@"Saving queue '%@' with etag '%@'", queue.feed.key, queue.etag);
    [FileUtilities writeObject:queue.dictionary toFile:[self queueFile:queue.feed]];
    [FileUtilities writeObject:queue.etag toFile:[self queueEtagFile:queue]];
}


- (NSString*) extractEtagFromElement:(XmlElement*) element andResponse:(NSHTTPURLResponse*) response {
    NSString* etag = [[element element:@"etag"] text];
    if (etag.length > 0) {
        return etag;
    }
    
    etag = [response.allHeaderFields objectForKey:@"Etag"];
    NSRange lastQuoteRange;
    if ([etag hasPrefix:@"\""] &&
        (lastQuoteRange = [etag rangeOfString:@"\"" options:NSBackwardsSearch]).length > 0) {
        return [etag substringWithRange:NSMakeRange(1, lastQuoteRange.location - 1)];
    }
    
    return @"";
}


- (NSString*) downloadEtag:(Feed*) feed {
    NSRange range = [feed.url rangeOfString:@"&output=atom"];
    NSString* url = feed.url;
    if (range.length > 0) {
        url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
    }
    
    NSString* address = [NSString stringWithFormat:@"%@&max_results=1", url];
    
    NSHTTPURLResponse* response;
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES
                                                            response:&response];
    
    return [self extractEtagFromElement:element andResponse:response];
}


- (BOOL) etagChanged:(Feed*) feed {
    Queue* queue = [self queueForFeed:feed];
    NSString* localEtag = queue.etag;
    if (localEtag.length == 0) {
        return YES;
    }
    
    NSString* serverEtag = [self downloadEtag:feed];
    
    return ![serverEtag isEqual:localEtag];
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved
                     maxCount:(NSInteger) maxCount {
    for (XmlElement* child in element.children) {
        if (maxCount >= 0) {
            if ((movies.count + saved.count) > maxCount) {
                break;
            }
        }
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self processMovieItem:child
                            movies:movies
                             saved:saved];
        }
        [pool release];
    }
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved {
    [self processMovieItemList:element movies:movies saved:saved maxCount:-1];
}


- (Person*) processPersonItem:(XmlElement*) personElement {
    NSString* identifier = [[personElement element:@"id"] text];
    NSString* name = [[personElement element:@"name"] text];
    NSString* bio = [[personElement element:@"bio"] text];
    
    if (identifier.length == 0 || name.length == 0) {
        return nil;
    }
    
    NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
    
    for (XmlElement* linkElement in [personElement elements:@"link"]) {
        NSString* rel = [linkElement attributeValue:@"rel"];
        
        if ([@"http://schemas.netflix.com/catlog/person/filmography" isEqual:rel]) {
            [additionalFields setObject:[linkElement attributeValue:@"href"] forKey:filmography_key];
        } else if ([@"alternate" isEqual:rel]) {
            [additionalFields setObject:[linkElement attributeValue:@"href"] forKey:link_key];
        }
    }
    
    return [Person personWithIdentifier:identifier
                                   name:name
                              biography:bio
                       additionalFields:additionalFields];
}


- (NSArray*) processPersonItemList:(XmlElement*) element {
    NSMutableArray* people = [NSMutableArray array];
    
    for (XmlElement* personElement in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Person* person = [self processPersonItem:personElement];
            if (person != nil) {
                [people addObject:person];
            }
        }
        [pool release];
    }
    
    return people;
}


- (void) addSearchPeople:(NSArray*) people {
    [updateDetailsLock lock];
    {
        [searchPeople setArray:people];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) addSearchMovies:(NSArray*) movies {
    [updateDetailsLock lock];
    {
        [searchMovies setArray:movies];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (NSArray*) peopleSearch:(NSString*) query {
    return [NSArray array];
    OAMutableURLRequest* request = [self createURLRequest:@"http://api.netflix.com/catalog/people"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:query],
                           [OARequestParameter parameterWithName:@"max_results" value:@"5"], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];
    
    [self checkApiResult:element];
    
    NSArray* people = [self processPersonItemList:element];
    
    if (people.count > 0) {
        // download the details for these movies in teh background.
        [self addSearchPeople:people];
    }
    
    return people;
}


- (NSArray*) movieSearch:(NSString*) query error:(NSString**) error {
    if (error != NULL) {
        *error = nil;
    }
    
    OAMutableURLRequest* request = [self createURLRequest:@"http://api.netflix.com/catalog/titles"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:query],
                           [OARequestParameter parameterWithName:@"max_results" value:@"25"], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];
    
    [self checkApiResult:element];
    
    if (element == nil) {
        *error = [self extractErrorMessage:element];
        return nil;
    }
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    [movies addObjectsFromArray:saved];
    
    if (movies.count > 0) {
        // download the details for these movies in teh background.
        [self addSearchMovies:movies];
    }
    
    return movies;
}


- (void) downloadQueue:(Feed*) feed {
    // first download and check the feed's current etag against the current one.
    if (![self etagChanged:feed]) {
        NSLog(@"Etag unchanged for %@.  Skipping download.", feed.key);
        return;
    }
    
    NSRange range = [feed.url rangeOfString:@"&output=atom"];
    NSString* address = feed.url;
    if (range.length > 0) {
        address = [NSString stringWithFormat:@"%@%@", [address substringToIndex:range.location], [address substringFromIndex:range.location + range.length]];
    }
    
    address = [NSString stringWithFormat:@"%@&max_results=500", address];
    
    NSHTTPURLResponse* response;
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                           important:YES
                                                            response:&response];
    
    NSString* etag = [self extractEtagFromElement:element andResponse:response];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    // Hack.  We get duplicated titles in this feed.  So filter them out.
    if ([feed.key isEqual:[NetflixCache rentalHistoryKey]]) {
        for (NSInteger i = movies.count - 1; i >= 0; i--) {
            if ([movies indexOfObject:[movies objectAtIndex:i]] != i) {
                [movies removeObjectAtIndex:i];
            }
        }
    }
    
    if (element != nil) {
        Queue* queue = [Queue queueWithFeed:feed
                                       etag:etag
                                     movies:movies
                                      saved:saved];
        [self saveQueue:queue];
        [self performSelectorOnMainThread:@selector(reportQueue:)
                               withObject:queue
                            waitUntilDone:NO];
    }
}


- (void) reportQueue:(Queue*) queue {
    NSAssert([NSThread isMainThread], nil);
    NSLog(@"Reporting queue '%@' with etag '%@'", queue.feed.key, queue.etag);
    
    [queues setObject:queue forKey:queue.feed.key];
    [AppDelegate majorRefresh];
}


- (void) downloadQueues:(NSArray*) feeds {
    for (Feed* feed in feeds) {
        // Take teh lock for each feed we download.  That way if it's taking a
        // long time, the user can still do the the other operations the user
        // asks us to do (move movies, change ratings, etc.).
        [gate lock];
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadQueue:feed];
        }
        [pool release];
        [gate unlock];
    }
    
    [updateDetailsLock lock];
    {
        for (NSInteger i = self.feeds.count - 1; i >= 0; i--) {
            Feed* feed = [self.feeds objectAtIndex:i];
            
            Queue* queue = [self queueForFeed:feed];
            if (queue != nil) {
                [normalMovies addObjectsFromArray:queue.saved];
                [normalMovies addObjectsFromArray:queue.movies];
            }
        }
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
    
    [ThreadingUtilities backgroundSelector:@selector(downloadRSS)
                                  onTarget:self
                                      gate:nil // no lock.
                                   visible:NO];
}


- (void) downloadUserData {
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:YES];
    NSString* firstName = [[element element:@"first_name"] text];
    NSString* lastName = [[element element:@"last_name"] text];
    BOOL canInstantWatch = [[[element element:@"can_instant_watch"] text] isEqual:@"true"];
    
    NSMutableArray* preferredFormats = [NSMutableArray array];
    for (XmlElement* child in [[element element:@"preferred_formats"] children]) {
        if ([@"category" isEqual:child.name]) {
            if ([@"http://api.netflix.com/categories/title_formats" isEqual:[child attributeValue:@"scheme"]]) {
                NSString* label = [child attributeValue:@"label"];
                if (label.length > 0) {
                    [preferredFormats addObject:label];
                }
            }
        }
    }
    
    if (firstName.length > 0 || lastName.length > 0) {
        [model setNetflixFirstName:firstName
                          lastName:lastName
                   canInstantWatch:canInstantWatch
                  preferredFormats:preferredFormats];
        [AppDelegate majorRefresh];
    }
}


- (NSString*) moviePosterFile:(Movie*) movie {
    return
    [[[Application netflixPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallMoviePosterFile:(Movie*) movie {
    return
    [[[Application netflixPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"-small.png"];
}


- (void) updateMoviePoster:(Movie*) movie {
    if (movie.poster.length == 0) {
        return;
    }
    
    NSString* path = [self moviePosterFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster important:NO];
    if (data.length > 0) {
        [FileUtilities writeData:data toFile:path];
        [AppDelegate minorRefresh];
    }
}


- (void) updatePersonPoster:(Person*) person {
    [model.personPosterCache update:person];
}


- (NSArray*) extractPeople:(XmlElement*) element {
    NSMutableArray* cast = [NSMutableArray array];
    
    for (XmlElement* child in element.children) {
        if (cast.count >= 6) {
            // cap the number of actors we care about
            break;
        }
        
        NSString* name = [child attributeValue:@"title"];
        if (name.length > 0) {
            [cast addObject:name];
        }
    }
    
    return cast;
}


- (NSString*) seriesFile:(NSString*) seriesKey {
    return
    [[[Application netflixSeriesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:seriesKey]]
     stringByAppendingPathExtension:@"plist"];
}


- (Movie*) downloadMovieWithSeriesKey:(NSString*) seriesKey {
    OAMutableURLRequest* request = [self createURLRequest:seriesKey];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:NO];
    
    [self checkApiResult:element];
    
    return [NetflixCache processMovieItem:element saved:NULL];
}


- (Movie*) downloadRSSMovieWithSeriesIdentifier:(NSString*) identifier {
    //NSString* seriesKey = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/series/%@?expand=synopsis,cast,directors,formats,similars", identifier];
    NSString* seriesKey = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/series/%@?expand=synopsis,cast,directors,formats", identifier];
    return [self downloadMovieWithSeriesKey:seriesKey];
}


- (void) updateSeriesDetails:(Movie*) movie {
    NSString* seriesKey = [movie.additionalFields objectForKey:series_key];
    if (seriesKey.length == 0) {
        return;
    }
    
    NSString* file = [self seriesFile:seriesKey];
    Movie* series;
    if ([FileUtilities fileExists:file]) {
        series = [Movie movieWithDictionary:[FileUtilities readObject:file]];
    } else {
        series = [self downloadMovieWithSeriesKey:seriesKey];
        if (series != nil) {
            [FileUtilities writeObject:series.dictionary toFile:file];
        }
    }
    
    if (series == nil) {
        return;
    }
    
    [self updateMovieDetails:series];
}


- (BOOL) isMemberOfSeries:(Movie*) movie {
    return [movie.additionalFields objectForKey:series_key] != nil;
}


- (Movie*) seriesForDisc:(Movie*) movie {
    NSDictionary* dictionary = [FileUtilities readObject:[self seriesFile:[movie.additionalFields objectForKey:series_key]]];
    if (dictionary == nil) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dictionary];
}


- (Movie*) promoteDiscToSeries:(Movie*) disc {
    Movie* series = [self seriesForDisc:disc];
    if (series == nil) {
        return disc;
    }
    return series;
}


- (NSString*) userRatingsFile:(Movie*) movie {
    return [[[Application netflixUserRatingsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingPathExtension:@"plist"];
    
}


- (NSString*) predictedRatingsFile:(Movie*) movie {
    return [[[Application netflixPredictedRatingsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingPathExtension:@"plist"];
}


- (BOOL) tooSoon:(NSString*) file {
    if ([FileUtilities fileExists:file]) {
        NSDate* date = [FileUtilities modificationDate:file];
        if (date != nil) {
            if (ABS(date.timeIntervalSinceNow) < ONE_WEEK) {
                return YES;
            }
        }
    }
    
    return NO;
}


- (void) updateRatings:(Movie*) movie {
    NSString* userRatingsFile = [self userRatingsFile:movie];
    NSString* predictedRatingsFile = [self predictedRatingsFile:movie];
    
    if ([self tooSoon:predictedRatingsFile] &&
        [self tooSoon:userRatingsFile]) {
        return;
    }
    
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", model.netflixUserId];
    OAMutableURLRequest* request = [self createURLRequest:address];
    OARequestParameter* parameter = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
    [request setParameters:[NSArray arrayWithObject:parameter]];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                                              important:NO];
    
    [self checkApiResult:element];
    
    XmlElement* ratingsItemElment = [element element:@"ratings_item"];
    if (ratingsItemElment == nil) {
        return;
    }
    
    if (![@"ratings_item" isEqual:ratingsItemElment.name]) {
        return;
    }
    
    NSString* userRating = [[ratingsItemElment element:@"user_rating"] text];
    NSString* predictedRating = [[ratingsItemElment element:@"predicted_rating"] text];
    
    if (userRating.length == 0) {
        userRating = @"";
    }
    
    if (predictedRating.length == 0) {
        predictedRating = @"";
    }
    
    [FileUtilities writeObject:userRating toFile:userRatingsFile];
    [FileUtilities writeObject:predictedRating toFile:predictedRatingsFile];
    [AppDelegate minorRefresh];
}


- (NSArray*) extractFormats:(XmlElement*) element {
    NSMutableArray* formats = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            if ([@"availability" isEqual:child.name]) {
                for (XmlElement* grandChild in child.children) {
                    if ([@"category" isEqual:grandChild.name] &&
                        [@"http://api.netflix.com/categories/title_formats" isEqual:[grandChild attributeValue:@"scheme"]]) {
                        [formats addObject:[grandChild attributeValue:@"term"]];
                    }
                }
            }
        }
        [pool release];
    }
    
    return formats;
}


- (NSArray*) extractSimilars:(XmlElement*) element {
    NSMutableArray* result = [NSMutableArray array];
    for (XmlElement* child in element.children) {
        if (result.count >= 5) {
            break;
        }
        
        if ([@"link" isEqual:child.name]) {
            if ([@"http://schemas.netflix.com/catalog/title" isEqual:[child attributeValue:@"rel"]]) {
                NSString* address = [child attributeValue:@"href"];
                if (address.length > 0) {
                    [result addObject:address];
                }
            }
        }
    }
    return result;
}


- (NSString*) cleanupSynopsis:(NSString*) synopsis {
    return [StringUtilities convertHtmlEncodings:[StringUtilities stripHtmlLinks:synopsis]];
}


- (NSDictionary*) extractMovieDetails:(XmlElement*) element {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (XmlElement* child in element.children) {
        if ([@"link" isEqual:child.name]) {
            NSString* rel = [child attributeValue:@"rel"];
            if ([@"http://schemas.netflix.com/catalog/titles/synopsis" isEqual:rel]) {
                NSString* synopsis = [self cleanupSynopsis:[[child element:@"synopsis"] text]];
                if (synopsis.length > 0) {
                    [dictionary setObject:synopsis forKey:synopsis_key];
                }
            } else if ([@"http://schemas.netflix.com/catalog/titles/format_availability" isEqual:rel]) {
                NSArray* formats = [self extractFormats:[child element:@"delivery_formats"]];
                if (formats.count > 0) {
                    [dictionary setObject:formats forKey:formats_key];
                }
            } else if ([@"http://schemas.netflix.com/catalog/people.cast" isEqual:rel]) {
                NSArray* cast = [self extractPeople:[child element:@"people"]];
                if (cast.count > 0) {
                    [dictionary setObject:cast forKey:cast_key];
                }
            } else if ([@"http://schemas.netflix.com/catalog/people.directors" isEqual:rel]) {
                NSArray* directors = [self extractPeople:[child element:@"people"]];
                if (directors.count > 0) {
                    [dictionary setObject:directors forKey:directors_key];
                }
            }/* else if ([@"http://schemas.netflix.com/catalog/titles.similars" isEqual:rel]) {
             NSArray* similars = [self extractSimilars:[child element:@"catalog_titles"]];
             if (similars.count > 0) {
             [dictionary setObject:similars forKey:similars_key];
             }
             }*/
        }
    }
    return dictionary;
}


- (NSString*) rssFile:(NSString*) address {
    return [[[Application netflixRSSDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]] stringByAppendingPathExtension:@"plist"];
}


- (void) downloadRSSFeed:(NSString*) address {
    NSString* file = [self rssFile:address];
    if ([FileUtilities fileExists:file]) {
        NSDate* date = [FileUtilities modificationDate:file];
        if (date != nil) {
            if (ABS(date.timeIntervalSinceNow) < ONE_WEEK) {
                return;
            }
        }
    }
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address important:NO];
    XmlElement* channelElement = [element element:@"channel"];
    
    NSMutableArray* items = [NSMutableArray array];
    for (XmlElement* itemElement in [channelElement elements:@"item"]) {
        NSString* identifier = [[itemElement element:@"link"] text];
        NSRange lastSlashRange = [identifier rangeOfString:@"/" options:NSBackwardsSearch];
        
        if (lastSlashRange.length > 0) {
            [items addObject:[identifier substringFromIndex:lastSlashRange.location + 1]];
        }
    }
    
    if (items.count > 0) {
        [FileUtilities writeObject:items toFile:file];
    }
}


- (NSString*) rssFeedDirectory:(NSString*) address {
    return [[Application netflixRSSDirectory]
            stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]];
}


- (NSString*) rssMovieFile:(NSString*) identifier address:(NSString*) address {
    return [[[self rssFeedDirectory:address]
             stringByAppendingPathComponent:[FileUtilities sanitizeFileName:identifier]]
            stringByAppendingPathExtension:@"plist"];
}


- (void) downloadRSSFeeds {
    for (NSString* key in mostPopularTitles) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            NSString* address = [mostPopularTitlesToAddresses objectForKey:key];
            [FileUtilities createDirectory:[self rssFeedDirectory:address]];
            [self downloadRSSFeed:address];
        }
        [pool release];
    }
}


- (NSString*) detailsFile:(Movie*) movie {
    return [[[Application netflixDetailsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (Movie*) downloadRSSMovieWithIdentifier:(NSString*) identifier {
    //NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/movies/%@?expand=synopsis,cast,directors,formats,similars", identifier];
    NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/movies/%@?expand=synopsis,cast,directors,formats", identifier];
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    return [NetflixCache processMovieItem:element saved:NULL];
}


- (NSArray*) moviesForRSSTitle:(NSString*) title {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:title];
    
    NSString* directory = [self rssFeedDirectory:address];
    NSArray* paths = [FileUtilities directoryContentsPaths:directory];
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSString* path in paths) {
        NSDictionary* dictionary = [FileUtilities readObject:path];
        if (dictionary != nil) {
            Movie* movie = [Movie movieWithDictionary:dictionary];
            [array addObject:movie];
        }
    }
    
    return array;
}


- (NSInteger) movieCountForRSSTitle:(NSString*) title {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:title];
    
    NSString* directory = [self rssFeedDirectory:address];
    NSArray* paths = [FileUtilities directoryContentsPaths:directory];
    
    return paths.count;
}


- (void) updateSpecificDiscDetails:(Movie*) movie expand:(NSString*) expand {
    NSString* address = [movie.additionalFields objectForKey:title_key];
    if (address.length == 0) {
        address = movie.identifier;
        if (address.length == 0) {
            return;
        }
    }
    
    NSString* path = [self detailsFile:movie];
    if ([FileUtilities fileExists:path]) {
        return;
    }
    
    address = [NSString stringWithFormat:@"%@?expand=%@", address, expand];
    
    OAMutableURLRequest* request = [self createURLRequest:address];
    [request prepare];
    
    XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request important:NO];
    NSDictionary* dictionary = [self extractMovieDetails:element];
    if (dictionary.count > 0) {
        [FileUtilities writeObject:dictionary toFile:path];
        [AppDelegate minorRefresh];
    }
}


- (void) updateAllDiscDetails:(Movie*) movie {
    // we don't download this stuff on a per disc basis.  only for a series.
    [self updateMoviePoster:movie];
    //[self updateSpecificDiscDetails:movie expand:@"synopsis,cast,directors,formats,similars"];
    [self updateSpecificDiscDetails:movie expand:@"synopsis,cast,directors,formats"];
    [self updateRatings:movie];
    
    [model.imdbCache updateMovie:movie];
    [model.wikipediaCache updateMovie:movie];
    [model.amazonCache updateMovie:movie];
}


- (void) updateMovieDetails:(Movie*) movie {
    if (movie == nil) {
        return;
    }
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        if ([self isMemberOfSeries:movie]) {
            // first, if this disc is a member of a series, update the
            // details of that series.
            [self updateSeriesDetails:movie];
            
            // for a disc that's a member of a series, we only need a couple
            // of bits of data.
            [self updateSpecificDiscDetails:movie expand:@"synopsis,formats"];
        } else {
            // Otherwise, update all the details.
            [self updateAllDiscDetails:movie];
        }
        
    }
    [pool release];
}


- (void) updatePersonDetails:(Person*) person {
    if (person == nil) {
        return;
    }
    
    [self updatePersonPoster:person];
}


- (void) downloadRSSMovie:(NSString*) identifier
                  address:(NSString*) address {
    NSString* file = [self rssMovieFile:identifier address:address];
    
    Movie* movie;
    if ([FileUtilities fileExists:file]) {
        movie = [Movie movieWithDictionary:[FileUtilities readObject:file]];
    } else {
        movie = [self downloadRSSMovieWithIdentifier:identifier];
        if (movie.canonicalTitle.length == 0) {
            // might have been a series.
            movie = [self downloadRSSMovieWithSeriesIdentifier:identifier];
        }
        
        if (movie.canonicalTitle.length > 0) {
            [FileUtilities writeObject:movie.dictionary toFile:file];
        }
    }
    
    if (movie.canonicalTitle.length > 0) {
        [updateDetailsLock lock];
        {
            [rssMovies addObject:movie];
            [updateDetailsLock signal];
        }
        [updateDetailsLock unlock];
    }
}


- (void) downloadRSSMovies:(NSString*) address {
    NSString* file = [self rssFile:address];
    NSArray* identifiers = [FileUtilities readObject:file];
    
    for (NSString* identifier in identifiers) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadRSSMovie:identifier address:address];
        }
        [pool release];
    }
}


- (void) downloadRSSMovies {
    for (NSString* key in mostPopularTitles) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            NSString* address = [mostPopularTitlesToAddresses objectForKey:key];
            [self downloadRSSMovies:address];
        }
        [pool release];
        [AppDelegate majorRefresh];
    }
}


- (void) downloadRSS {
    [self downloadRSSFeeds];
    [self downloadRSSMovies];
}


- (void) updateBackgroundEntryPoint {
    if (model.netflixUserId.length == 0) {
        return;
    }
    
    [self downloadUserData];
    
    NSArray* feeds = [self downloadFeeds];
    
    if (feeds.count > 0) {
        [self saveFeeds:feeds];
        [self performSelectorOnMainThread:@selector(reportFeeds:)
                               withObject:feeds
                            waitUntilDone:NO];
    }
    
    [ThreadingUtilities backgroundSelector:@selector(downloadQueues:)
                                  onTarget:self
                                  argument:feeds
                                      gate:nil // no gate.  we'll take it for each feed we download.
                                   visible:YES];
}


- (void) addSearchResult:(Movie*) movie {
    if (![movie isNetflix]) {
        return;
    }
    
    [updateDetailsLock lock];
    {
        [searchMovies addObject:movie];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) prioritizeMovie:(Movie*) movie {
    if (![movie isNetflix]) {
        return;
    }
    
    [updateDetailsLock lock];
    {
        [prioritizedMovies addObject:movie];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) prioritizePerson:(Person*) person {
    [updateDetailsLock lock];
    {
        [prioritizedPeople addObject:person];
        [updateDetailsLock signal];
    }
    [updateDetailsLock unlock];
}


- (void) updateDetailsBackgroundEntryPoint {
    while (YES) {
        Movie* movie = nil;
        Person* person = nil;
        [updateDetailsLock lock];
        {
            while ((movie  = [prioritizedMovies removeLastObjectAdded]) == nil &&
                   (person = [prioritizedPeople removeLastObjectAdded]) == nil &&
                   (movie  = [searchMovies removeLastObjectAdded]) == nil &&
                   (person = [searchPeople removeLastObjectAdded]) == nil &&
                   (movie  = [normalMovies removeLastObjectAdded]) == nil &&
                   (movie  = [rssMovies removeLastObjectAdded]) == nil) {
                [updateDetailsLock wait];
            }
        }
        [updateDetailsLock unlock];
        
        [self updatePersonDetails:person];
        [self updateMovieDetails:movie];
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
    NSAssert([NSThread isMainThread], nil);
    
    self.feedsData = feeds;
    
    for (NSString* key in self.queues.allKeys) {
        if (![self feedsContainsKey:key]) {
            [self.queues removeObjectForKey:key];
        }
    }
    
    [AppDelegate majorRefresh];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSData* data = [FileUtilities readData:[self moviePosterFile:movie]];
    return [UIImage imageWithData:data];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSString* smallPosterPath = [self smallMoviePosterFile:movie];
    NSData* smallPosterData;
    
    if ([FileUtilities size:smallPosterPath] == 0) {
        NSData* normalPosterData = [FileUtilities readData:[self moviePosterFile:movie]];
        smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                                toHeight:SMALL_POSTER_HEIGHT];
        
        [FileUtilities writeData:smallPosterData
                          toFile:smallPosterPath];
    } else {
        smallPosterData = [FileUtilities readData:smallPosterPath];
    }
    
    return [UIImage imageWithData:smallPosterData];
}


- (NSDictionary*) detailsForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self detailsFile:movie]];
}


- (NSArray*) castForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    NSDictionary* details = [self detailsForMovie:movie];
    return [details objectForKey:cast_key];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    NSDictionary* details = [self detailsForMovie:movie];
    return [details objectForKey:directors_key];
}


- (NSString*) netflixRatingForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSString* rating = [FileUtilities readObject:[self predictedRatingsFile:movie]];
    if (rating.length > 0) {
        return rating;
    }
    
    return [movie.additionalFields objectForKey:average_rating_key];
}


- (NSString*) userRatingForMovie:(Movie*) movie {
    movie = [self promoteDiscToSeries:movie];
    
    NSString* presubmitRating = [presubmitRatings objectForKey:movie];
    if (presubmitRating != nil) {
        return presubmitRating;
    }
    
    return [FileUtilities readObject:[self userRatingsFile:movie]];
}


- (NSArray*) formatsForMovie:(Movie*) movie {
    NSDictionary* details = [self detailsForMovie:movie];
    NSArray* result = [details objectForKey:formats_key];
    if (result.count > 0) {
        return result;
    }
    
    Movie* series = [self promoteDiscToSeries:movie];
    if (series != movie) {
        return [self formatsForMovie:series];
    }
    
    return [NSArray array];
}


- (NSString*) netflixAddressForMovie:(Movie*) movie {
    NSString* address = [movie.additionalFields objectForKey:link_key];
    if (address.length == 0) {
        return @"";
    }
    
    return address;
}


- (NSString*) availabilityForMovie:(Movie*) movie {
    NSString* availability = [movie.additionalFields objectForKey:availability_key];
    NSString* result = [availabilityMap objectForKey:availability];
    
    if (result.length == 0) {
        return @"";
    }
    
    return result;
}


- (NSArray*) similarMoviesForMovie:(Movie*) movie {
    return [NSArray array];
    
    if (!movie.isNetflix) {
        return [NSArray array];
    }
    
    movie = [self promoteDiscToSeries:movie];
    NSDictionary* details = [self detailsForMovie:movie];
    return [Movie decodeArray:[details objectForKey:similars_key]];
}


- (NSString*) synopsisForMovieDetails:(Movie*) movie {
    NSDictionary* details = [self detailsForMovie:movie];
    return [details objectForKey:synopsis_key];
}


- (NSString*) synopsisForMovieWorker:(Movie*) movie {
    NSString* discSynopsis = [self synopsisForMovieDetails:movie];
    NSString* seriesSynopsis = [self synopsisForMovieDetails:[self seriesForDisc:movie]];
    
    if (discSynopsis.length == 0) {
        return seriesSynopsis;
    } else {
        if (seriesSynopsis.length == 0) {
            return discSynopsis;
        }
        
        return [NSString stringWithFormat:@"%@\n\n%@", discSynopsis, seriesSynopsis];
    }
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    if (!movie.isNetflix) {
        return @"";
    }
    
    NSString* synopsis = [self synopsisForMovieWorker:movie];
    if (synopsis.length == 0) {
        if ([NetworkUtilities isNetworkAvailable]) {
            return NSLocalizedString(@"Downloading information.", nil);
        } else {
            return NSLocalizedString(@"No synopsis available.", nil);
        }
    }
    
    return synopsis;
}


- (Feed*) feedForKey:(NSString*) key {
    for (Feed* feed in self.feeds) {
        if ([key isEqual:feed.key]) {
            return feed;
        }
    }
    
    return nil;
}


- (Queue*) queueForKey:(NSString*) key {
    return [self queueForFeed:[self feedForKey:key]];
}


- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount {
    NSString* title = nil;
    if ([key isEqual:[NetflixCache dvdQueueKey]]) {
        title = NSLocalizedString(@"Disc Queue", nil);
    } else if ([key isEqual:[NetflixCache instantQueueKey]]) {
        title = NSLocalizedString(@"Instant Queue", nil);
    } else if ([key isEqual:[NetflixCache atHomeKey]]) {
        title = NSLocalizedString(@"At Home", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryWatchedKey]]) {
        title = NSLocalizedString(@"Recently Watched", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryReturnedKey]]) {
        title = NSLocalizedString(@"Recently Returned", nil);
    } else if ([key isEqual:[NetflixCache rentalHistoryKey]]) {
        title = NSLocalizedString(@"Entire History", nil);
    } else if ([key isEqual:[NetflixCache recommendationKey]]) {
        title = NSLocalizedString(@"Recommendations", nil);
    }
    
    Queue* queue = [self queueForKey:key];
    if (queue == nil || !includeCount) {
        return title;
    }
    
    NSString* number = [NSString stringWithFormat:@"%d", queue.movies.count + queue.saved.count];
    return [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", @"Netflix queue title and title count.  i.e: 'Instant Queue (45)'"),
            title, number];
}


- (NSString*) titleForKey:(NSString*) key {
    return [self titleForKey:key includeCount:YES];
}


- (Status*) statusForMovie:(Movie*) movie inQueue:(Queue*) queue {
    BOOL saved = NO;
    NSInteger position = NSNotFound;
    NSString* description = @"";
    Movie* foundMovie = nil;
    
    if ((position = [queue.movies indexOfObject:movie]) != NSNotFound) {
        saved = NO;
        foundMovie = [queue.movies objectAtIndex:position];
    } else if ((position = [queue.saved indexOfObject:movie]) != NSNotFound) {
        saved = YES;
        foundMovie = [queue.saved objectAtIndex:position];
    } else {
        return nil;
    }
    
    if (queue.isAtHomeQueue) {
        description = NSLocalizedString(@"At Home", nil);
    } else {
        NSString* queueTitle = [self titleForKey:queue.feed.key includeCount:NO];
        if (saved) {
            description = [NSString stringWithFormat:NSLocalizedString(@"Saved in %@", @"Saved in Instant Queue"), queueTitle];
        } else {
            description = [NSString stringWithFormat:NSLocalizedString(@"#%d in %@", @"#15 in Instant Queue"), (position + 1), queueTitle];
        }
    }
    
    return [Status statusWithQueue:queue
                             movie:foundMovie
                       description:description
                             saved:saved
                          position:position];
}


- (NSArray*) statusesForMovie:(Movie*) movie {
    NSMutableArray* array = nil;
    NSArray* searchQueues = [NSArray arrayWithObjects:
                             [self queueForKey:[NetflixCache dvdQueueKey]],
                             [self queueForKey:[NetflixCache instantQueueKey]],
                             [self queueForKey:[NetflixCache atHomeKey]],
                             nil];
    
    for (Queue* queue in searchQueues) {
        Status* status = [self statusForMovie:movie inQueue:queue];
        if (status != nil) {
            if (array == nil) {
                array = [NSMutableArray array];
            }
            
            [array addObject:status];
        }
    }
    
    return array;
}


- (BOOL) isEnqueued:(Movie*) movie {
    return [[self statusesForMovie:movie] count] > 0;
}


- (BOOL) hasAccount {
    return model.netflixUserId.length > 0;
}


- (Movie*) lookupMovieWorker:(Movie*) movie {
    OAMutableURLRequest* request = [self createURLRequest:@"http://api.netflix.com/catalog/titles"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:movie.canonicalTitle],
                           [OARequestParameter parameterWithName:@"max_results" value:@"1"], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];
    
    [self checkApiResult:element];
    
    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    [NetflixCache processMovieItemList:element movies:movies saved:saved];
    
    [movies addObjectsFromArray:saved];
    
    if (movies.count > 0) {
        Movie* netflixMovie = [movies objectAtIndex:0];
        if ([DifferenceEngine areSimilar:movie.canonicalTitle other:netflixMovie.canonicalTitle]) {
            return netflixMovie;
        }
    }
    
    return nil;
}


- (NSString*) netflixFile:(Movie*) movie {
    return [[[Application netflixSearchDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) lookupNetflixMovieForLocalMovieBackgroundEntryPoint:(Movie*) movie {
    if (![self hasAccount]) {
        return;
    }
    
    NSAssert(![NSThread isMainThread], @"");
    
    [gate lock];
    {
        NSString* file = [self netflixFile:movie];
        if (![FileUtilities fileExists:file]) {
            Movie* netflixMovie = [self lookupMovieWorker:movie];
            if (netflixMovie != nil) {
                [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
                [self addSearchResult:netflixMovie];
                [AppDelegate minorRefresh];
            }
        }
    }
    [gate unlock];
}


- (void) lookupNetflixMoviesForLocalMovies:(NSArray*) movies {
    if (![self hasAccount]) {
        return;
    }
    
    [ThreadingUtilities backgroundSelector:@selector(lookupMoviesBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:movies
                                      gate:nil // no gate.  we'll take the gate for each movie
                                   visible:NO];
}


- (void) lookupMoviesBackgroundEntryPoint:(NSArray*) movies {
    for (Movie* movie in movies) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self lookupNetflixMovieForLocalMovieBackgroundEntryPoint:movie];
        }
        [pool release];
    }
}


- (Movie*) netflixMovieForMovie:(Movie*) movie {
    if (movie.isNetflix) {
        return movie;
    }
    
    NSString* file = [self netflixFile:movie];
    NSDictionary* dictionary = [FileUtilities readObject:file];
    if (dictionary.count == 0) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dictionary];
}


- (void) checkApiResult:(XmlElement*) element {
    NSString* message = [[element element:@"message"] text];
    if ([@"Over queries per day limit" isEqual:message]) {
        self.lastQuotaErrorDate = [NSDate date];
        [AppDelegate minorRefresh];
    }
}


- (NSString*) extractErrorMessage:(XmlElement*) element {
    NSString* message = [[element element:@"message"] text];
    if (message.length > 0) {
        return message;
    } else if (element == nil) {
        NSLog(@"Could not parse Netflix result.", nil);
        return NSLocalizedString(@"Could not connect to Netflix.", nil);
    } else {
        NSLog(@"Netflix response had no 'message' element", nil);
        return NSLocalizedString(@"An unknown error occurred.", nil);
    }
}

@end