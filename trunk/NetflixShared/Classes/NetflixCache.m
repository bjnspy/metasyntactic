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

#import "Feed.h"
#import "Movie.h"
#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixConstants.h"
#import "NetflixPaths.h"
#import "NetflixNetworking.h"
#import "NetflixRssCache.h"
#import "NetflixSharedApplication.h"
#import "NetflixSiteStatus.h"
#import "NetflixUser.h"
#import "NetflixUtilities.h"
#import "Queue.h"
#import "Status.h"

@interface NetflixCache()
@property (retain) AutoreleasingMutableDictionary* accountToFeeds;
@property (retain) AutoreleasingMutableDictionary* accountToFeedKeyToQueues;

- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force account:(NetflixAccount*) account;
- (void) downloadQueues:(NetflixAccount*) account force:(BOOL) force;
@end


@implementation NetflixCache

@synthesize accountToFeeds;
@synthesize accountToFeedKeyToQueues;

- (void) dealloc {
  self.accountToFeeds = nil;
  self.accountToFeedKeyToQueues = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.accountToFeeds = [AutoreleasingMutableDictionary dictionary];
    self.accountToFeedKeyToQueues = [AutoreleasingMutableDictionary dictionary];
  }

  return self;
}


+ (NSString*) noInformationFound {
  if ([[OperationQueue operationQueue] hasPriorityOperations]) {
    return LocalizedString(@"Downloading data", nil);
  } else if (![NetworkUtilities isNetworkAvailable]) {
    return LocalizedString(@"Network unavailable", nil);
  } else {
    return LocalizedString(@"No information found", nil);
  }
}


+ (NSArray*) loadAccountToFeeds:(NetflixAccount*) account {
  NSArray* array = [FileUtilities readObject:[NetflixPaths feedsFile:account]];
  return [Feed decodeArray:array];
}


+ (void) saveFeeds:(NSArray*) feeds account:(NetflixAccount*) account {
  if (feeds.count == 0) {
    return;
  }

  [FileUtilities writeObject:[Feed encodeArray:feeds]
                      toFile:[NetflixPaths feedsFile:account]];
}


- (NSArray*) feedsForAccountNoLock:(NetflixAccount*) account {
  NSArray* feeds = [self.accountToFeeds objectForKey:account.userId];
  if (feeds != nil) {
    return feeds;
  }

  NSArray* array = [NetflixCache loadAccountToFeeds:account];
  if (array != nil) {
    [self.accountToFeeds setObject:array forKey:account.userId];
  }
  return array;
}


- (NSArray*) feedsForAccount:(NetflixAccount*) account {
  NSArray* result;
  [dataGate lock];
  {
    result = [self feedsForAccountNoLock:account];
  }
  [dataGate unlock];
  return result;
}


+ (Queue*) loadQueue:(Feed*) feed account:(NetflixAccount*) account {
  NSLog(@"Loading queue: %@", feed.name);
  NSDictionary* dictionary = [FileUtilities readObject:[NetflixPaths queueFile:feed account:account]];
  if (dictionary.count == 0) {
    return nil;
  }

  return [Queue queueWithDictionary:dictionary];
}


- (void) addQueue:(Queue*) queue account:(NetflixAccount*) account {
  [dataGate lock];
  {
    NSMutableDictionary* feedKeyToQueues = [self.accountToFeedKeyToQueues objectForKey:account.userId];
    if (feedKeyToQueues == nil) {
      feedKeyToQueues = [NSMutableDictionary dictionary];
      [self.accountToFeedKeyToQueues setObject:feedKeyToQueues forKey:account.userId];
    }
    [feedKeyToQueues setObject:queue forKey:queue.feed.key];
  }
  [dataGate unlock];
}


- (Queue*) queueForFeedNoLock:(Feed*) feed account:(NetflixAccount*) account {
  if (feed == nil) {
    return nil;
  }

  Queue* queue = [[self.accountToFeedKeyToQueues objectForKey:account.userId] objectForKey:feed.key];
  if (queue == nil) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      queue = [NetflixCache loadQueue:feed account:account];
      if (queue != nil) {
        [self addQueue:queue account:account];
      }
    }
    [pool release];
  }

  return queue;
}


- (Queue*) queueForFeed:(Feed*) feed account:(NetflixAccount*) account {
  Queue* queue = nil;
  [dataGate lock];
  {
    queue = [self queueForFeedNoLock:feed account:account];
  }
  [dataGate unlock];
  return queue;
}


- (void) update:(BOOL) force {
  NetflixAccount* account = [NetflixSharedApplication currentNetflixAccount];
  if ([NetflixSharedApplication netflixEnabled] &&
      account.userId.length > 0) {
    [FileUtilities createDirectory:[NetflixPaths accountDirectory:account]];
    [FileUtilities createDirectory:[NetflixPaths userRatingsDirectory:account]];
    [FileUtilities createDirectory:[NetflixPaths predictedRatingsDirectory:account]];

    [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint:force:)
                                            onTarget:self
                                          withObject:account
                                          withObject:[NSNumber numberWithBool:force]
                                                gate:runGate
                                            priority:Priority];
  }
}


- (BOOL) canContinue:(NetflixAccount*) account {
  return [NetflixUtilities canContinue:account];
}


- (void) checkApiResult:(NetflixAccount*) account element:(XmlElement*) element {
  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];

  if (statusCode == 412) {
    // Ok, we're out of date with the netflix servers.  Force a redownload of the users' queues.
    NSLog(@"Etag mismatch error. Force a redownload of the user's queues.");
    [self downloadQueues:account force:YES];
    return;
  }

  [[NetflixSiteStatus status] checkApiResult:element];
}


- (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account
                   response:(NSHTTPURLResponse**) response {
  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request response:response];

  [self checkApiResult:account element:element];

  return element;
}


- (XmlElement*) downloadXml:(NSURLRequest*) request account:(NetflixAccount*) account {
  return [self downloadXml:request account:account response:NULL];
}


- (NSArray*) downloadFeedsWorker:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", account.userId];
  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSSet* allowableFeeds = [NSSet setWithObjects:
                           [NetflixConstants discQueueKey],
                           [NetflixConstants instantQueueKey],
                           [NetflixConstants atHomeKey],
                           [NetflixConstants recommendationKey],
                           [NetflixConstants rentalHistoryKey],
                           [NetflixConstants rentalHistoryWatchedKey],
                           [NetflixConstants rentalHistoryReturnedKey], nil];

  NSMutableArray* feeds = [NSMutableArray array];
  for (XmlElement* child in element.children) {
    if ([child.name isEqual:@"link"]) {
      NSString* key = [child attributeValue:@"rel"];

      if ([allowableFeeds containsObject:key]) {
        Feed* feed = [Feed feedWithUrl:[child attributeValue:@"href"]
                                   key:key
                                  name:[child attributeValue:@"title"]];

        if ([key isEqual:[NetflixConstants atHomeKey]]) {
          [feeds insertObject:feed atIndex:0];
        } else {
          [feeds addObject:feed];
        }
      }
    }
  }

  return feeds;
}


- (void) downloadFeeds:(NetflixAccount*) account {
  NSArray* feeds = [self downloadFeedsWorker:account];
  
  if (feeds.count > 0) {
    [NetflixCache saveFeeds:feeds account:account];
    
    [dataGate lock];
    {
      [self.accountToFeeds setObject:feeds forKey:account.userId];
    }
    [dataGate unlock];
    
    [MetasyntacticSharedApplication majorRefresh];
  }
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
  Movie* movie = [NetflixUtilities processMovieItem:element saved:&save];

  if (movie == nil) {
    return;
  }

  if (save) {
    [saved addObject:movie];
  } else {
    [movies addObject:movie];
  }
}


- (void) saveQueue:(Queue*) queue account:(NetflixAccount*) account {
  NSLog(@"Saving queue '%@' with etag '%@'", queue.feed.name, queue.etag);
  [FileUtilities writeObject:queue.dictionary toFile:[NetflixPaths queueFile:queue.feed account:account]];
  [FileUtilities writeObject:queue.etag toFile:[NetflixPaths queueEtagFile:queue.feed account:account]];
  [self addQueue:queue account:account];
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


- (NSString*) downloadEtag:(Feed*) feed account:(NetflixAccount*) account {
  NSRange range = [feed.url rangeOfString:@"&output=atom"];
  NSString* url = feed.url;
  if (range.length > 0) {
    url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
  }

  NSString* address = [NSString stringWithFormat:@"%@&max_results=1", url];

  NSHTTPURLResponse* response;
  XmlElement* element = [self downloadXml:[NSURLRequest requestWithURL:[NSURL URLWithString:address]]
                                  account:account
                                 response:&response];

  return [self extractEtagFromElement:element andResponse:response];
}


- (BOOL) etagChanged:(Feed*) feed account:(NetflixAccount*) account {
  NSString* localEtag = [FileUtilities readObject:[NetflixPaths queueEtagFile:feed account:account]];
  if (localEtag.length == 0) {
    return YES;
  }

  NSString* serverEtag = [self downloadEtag:feed account:account];

  return ![serverEtag isEqual:localEtag];
}


+ (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved
                     maxCount:(NSInteger) maxCount {
  for (XmlElement* child in element.children) {
    if (maxCount >= 0) {
      if ((movies.count + saved.count) > maxCount) {
        return;
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
  [self processMovieItemList:element movies:movies
                       saved:saved
                    maxCount:-1];
}


- (NSString*) extractErrorMessage:(XmlElement*) element {
  NSInteger statusCode = [[[element element:@"status_code"] text] integerValue];
  if (statusCode == 412) {
    // override this error message since the netflix message is very confusing.
    return [NSString stringWithFormat:LocalizedString(@"%@ must first update your local movie queue before it can process your change. Please try your change again shortly.", nil), [AbstractApplication name]];
  }

  NSString* message = [[element element:@"message"] text];
  if (message.length > 0) {
    return message;
  } else if (element == nil) {
    NSLog(@"Could not parse Netflix result.", nil);
    return LocalizedString(@"Could not connect to Netflix.", nil);
  } else {
    NSLog(@"Netflix response had no 'message' element.\n%@", element);
    return LocalizedString(@"An unknown error occurred.", nil);
  }
}


- (NSArray*) movieSearch:(NSString*) query
              maxResults:(NSInteger) maxResults
                 account:(NetflixAccount*) account
                   error:(NSString**) error {
  if (error != NULL) {
    *error = nil;
  }
  
  NSURLRequest* request =
  [NetflixNetworking createGetURLRequest:@"http://api.netflix.com/catalog/titles"
                              parameters:[NSArray arrayWithObjects:
                                          [OARequestParameter parameterWithName:@"expand" value:@"formats"],
                                          [OARequestParameter parameterWithName:@"term" value:query],
                                          [OARequestParameter parameterWithName:@"max_results" value:[NSString stringWithFormat:@"%d", maxResults]],
                                          nil]
                                 account:account];

  XmlElement* element = [self downloadXml:request account:account];

  if (element == nil) {
    if (error != NULL) {
      *error = [self extractErrorMessage:element];
    }
    return nil;
  }

  NSMutableArray* movies = [NSMutableArray array];
  NSMutableArray* saved = [NSMutableArray array];
  [NetflixCache processMovieItemList:element movies:movies saved:saved];

  [movies addObjectsFromArray:saved];

  return movies;
}


- (NSArray*) movieSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error {
  return [self movieSearch:query maxResults:30 account:account error:error];
}


- (void) downloadQueueWorker:(Feed*) feed
                     account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSRange range = [feed.url rangeOfString:@"&output=atom"];
  NSString* address = feed.url;
  if (range.length > 0) {
    address = [NSString stringWithFormat:@"%@%@", [address substringToIndex:range.location], [address substringFromIndex:range.location + range.length]];
  }

  address = [NSString stringWithFormat:@"%@&max_results=500", address];
  if ([feed.key isEqual:[NetflixConstants recommendationKey]]) {
    address = [NSString stringWithFormat:@"%@&expand=formats", address];
  }

  NSHTTPURLResponse* response;
  XmlElement* element = [self downloadXml:[NSURLRequest requestWithURL:[NSURL URLWithString:address]]
                                  account:account
                                 response:&response];

  NSString* etag = [self extractEtagFromElement:element andResponse:response];

  NSMutableArray* movies = [NSMutableArray array];
  NSMutableArray* saved = [NSMutableArray array];
  [NetflixCache processMovieItemList:element movies:movies saved:saved];

  // Hack.  We get duplicated titles in this feed.  So filter them out.
  if ([feed.key isEqual:[NetflixConstants rentalHistoryKey]]) {
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
    [self saveQueue:queue account:account];
  }
}


- (Feed*) feedForKey:(NSString*) key account:(NetflixAccount*) account {
  for (Feed* feed in [self feedsForAccount:account]) {
    if ([key isEqual:feed.key]) {
      return feed;
    }
  }

  return nil;
}


- (Queue*) queueForKey:(NSString*) key account:(NetflixAccount*) account {
  return [self queueForFeed:[self feedForKey:key account:account] account:account];
}


- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount account:(NetflixAccount*) account {
  NSString* title = nil;
  if ([key isEqual:[NetflixConstants discQueueKey]]) {
    title = LocalizedString(@"Disc Queue", @"The Netflix queue containing the user's DVDs");
  } else if ([key isEqual:[NetflixConstants instantQueueKey]]) {
    title = LocalizedString(@"Instant Queue", @"The Netflix queue containing the user's streaming movies");
  } else if ([key isEqual:[NetflixConstants atHomeKey]]) {
    title = LocalizedString(@"At Home", @"The list of Netflix movies currently at the user's house");
  } else if ([key isEqual:[NetflixConstants rentalHistoryWatchedKey]]) {
    title = LocalizedString(@"Recently Watched", @"The list of Netflix movies the user recently watched");
  } else if ([key isEqual:[NetflixConstants rentalHistoryReturnedKey]]) {
    title = LocalizedString(@"Recently Returned", @"The list of Netflix movies the user recently returned");
  } else if ([key isEqual:[NetflixConstants rentalHistoryKey]]) {
    title = LocalizedString(@"Entire History", @"The entire list of Netflix movies the user has seen");
  } else if ([key isEqual:[NetflixConstants recommendationKey]]) {
    title = LocalizedString(@"Recommendations", @"Movie recommendations from Netflix");
  }

  Queue* queue;
  if (!includeCount || ((queue = [self queueForKey:key account:account]) == nil)) {
    return title;
  }

  NSString* number = [NSString stringWithFormat:@"%d", queue.movies.count + queue.saved.count];
  return [NSString stringWithFormat:LocalizedString(@"%@ (%@)", @"Netflix queue title and title count.  i.e: 'Instant Queue (45)'"),
          title, number];
}


- (NSString*) titleForKey:(NSString*) key account:(NetflixAccount*) account {
  return [self titleForKey:key includeCount:YES account:account];
}


- (void) downloadQueue:(Feed*) feed
               account:(NetflixAccount*) account
                 force:(NSNumber*) forceValue {
  if (![self canContinue:account]) { return; }

  NSLog(@"NetflixCache:downloadQueue - %@", feed.name);
  BOOL force = forceValue.boolValue;

  // first download and check the feed's current etag against the current one.
  if (force || [self etagChanged:feed account:account]) {
    if (force) {
      NSLog(@"Forcing update of '%@'.", feed.name);
    } else {
      NSLog(@"Etag changed for '%@'.  Downloading.", feed.name);
    }
    NSString* title = [self titleForKey:feed.key includeCount:NO account:account];
    NSString* notification = [NSString stringWithFormat:@"Netflix '%@'", title];
    [NotificationCenter addNotification:notification];
    {
      [self downloadQueueWorker:feed account:account];
    }
    [NotificationCenter removeNotification:notification];
  } else {
    NSLog(@"Etag unchanged for '%@'.  Skipping download.", feed.name);
  }

  Queue* queue = [self queueForFeed:feed account:account];

  [NetflixSharedApplication reportNetflixMovies:queue.movies];
  [NetflixSharedApplication reportNetflixMovies:queue.saved];
}


- (Movie*) downloadMovieWithSeriesKey:(NSString*) seriesKey
                              account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:seriesKey account:account];

  XmlElement* element = [self downloadXml:request account:account];

  return [NetflixUtilities processMovieItem:element saved:NULL];
}


- (void) updateSeriesDetails:(Movie*) movie account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* seriesKey = [movie.additionalFields objectForKey:[NetflixConstants seriesKey]];
  if (seriesKey.length == 0) {
    return;
  }

  NSString* file = [NetflixPaths seriesFile:seriesKey];
  Movie* series;
  if ([FileUtilities fileExists:file]) {
    series = [Movie createWithDictionary:[FileUtilities readObject:file]];
  } else {
    series = [self downloadMovieWithSeriesKey:seriesKey account:account];
    if (series != nil) {
      [FileUtilities writeObject:series.dictionary toFile:file];
    }
  }

  if (series == nil) {
    return;
  }

  [self updateMovieDetails:series force:NO account:account];
}


- (BOOL) isMemberOfSeries:(Movie*) movie {
  return [movie.additionalFields objectForKey:[NetflixConstants seriesKey]] != nil;
}


- (Movie*) seriesForDisc:(Movie*) movie {
  NSDictionary* dictionary =
    [FileUtilities readObject:
     [NetflixPaths seriesFile:[movie.additionalFields objectForKey:[NetflixConstants seriesKey]]]];
  if (dictionary == nil) {
    return nil;
  }

  return [Movie createWithDictionary:dictionary];
}


- (Movie*) promoteDiscToSeries:(Movie*) disc {
  Movie* series = [self seriesForDisc:disc];
  if (series == nil) {
    return disc;
  }
  return series;
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


- (void) updateRatings:(Movie*) movie force:(BOOL) force account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* userRatingsFile = [NetflixPaths userRatingsFile:movie account:account];
  NSString* predictedRatingsFile = [NetflixPaths predictedRatingsFile:movie account:account];

  if (!force) {
    if ([self tooSoon:predictedRatingsFile] &&
        [self tooSoon:userRatingsFile]) {
      return;
    }
  }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", account.userId];


  NSURLRequest* request =
  [NetflixNetworking createGetURLRequest:address
                           parameter:[OARequestParameter parameterWithName:@"title_refs" value:movie.identifier]
                             account:account];

  XmlElement* element = [self downloadXml:request account:account];

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
  [MetasyntacticSharedApplication minorRefresh];
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


- (void) updateSpecificDiscDetails:(Movie*) movie
                            expand:(NSString*) expand
                           account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* address = [movie.additionalFields objectForKey:[NetflixConstants titleKey]];
  if (address.length == 0) {
    address = movie.identifier;
    if (address.length == 0) {
      return;
    }
  }

  NSString* path = [NetflixPaths detailsFile:movie];
  if ([FileUtilities fileExists:path]) {
    return;
  }

  address = [NSString stringWithFormat:@"%@?expand=%@", address, expand];

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [self downloadXml:request account:account];

  NSDictionary* dictionary = [NetflixUtilities extractMovieDetails:element];
  if (dictionary.count > 0) {
    [FileUtilities writeObject:dictionary toFile:path];
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (void) updateAllDiscDetails:(Movie*) movie
                        force:(BOOL) force
                      account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  // we don't download this stuff on a per disc basis.  only for a series.
  [self updateSpecificDiscDetails:movie expand:@"synopsis,cast,directors,formats" account:account];
  [self updateRatings:movie force:force account:account];
}


- (void) lookupCorrespondingNetflixMovie:(Movie*) movie account:(NetflixAccount*) account {
  NSAssert(![NSThread isMainThread], @"");

  if (account.userId.length == 0) {
    return;
  }

  if ([movie isNetflix]) {
    return;
  }

  NSString* file = [NetflixPaths netflixSearchFile:movie];
  Movie* netflixMovie = nil;
  if ([FileUtilities fileExists:file]) {
    netflixMovie = [self correspondingNetflixMovie:movie];
  } else {
    NSArray* movies = [self movieSearch:movie.canonicalTitle maxResults:1 account:account error:NULL];
    if (movies.count > 0) {
      netflixMovie = movies.firstObject;
      if (netflixMovie != nil) {
        [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
        [MetasyntacticSharedApplication minorRefresh];
      }
    }
  }

  if (netflixMovie != nil) {
    [NetflixSharedApplication reportNetflixMovie:netflixMovie];
  }
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  if ([movie isNetflix]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      if ([self isMemberOfSeries:movie]) {
        // first, if this disc is a member of a series, update the
        // details of that series.
        [self updateSeriesDetails:movie account:account];

        // for a disc that's a member of a series, we only need a couple
        // of bits of data.
        [self updateSpecificDiscDetails:movie expand:@"synopsis,formats" account:account];
      } else {
        // Otherwise, update all the details.
        [self updateAllDiscDetails:movie force:force account:account];
      }

    }
    [pool release];
  } else {
    [self lookupCorrespondingNetflixMovie:movie account:account];
  }
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
  [self updateMovieDetails:movie
                     force:force
                   account:[NetflixSharedApplication currentNetflixAccount]];
}


+ (BOOL) feeds:(NSArray*) feeds containsKey:(NSString*) key {
  for (Feed* feed in feeds) {
    if ([feed.key isEqual:key]) {
      return YES;
    }
  }

  return NO;
}


- (void) downloadQueues:(NetflixAccount*) account force:(BOOL) force {
  NSArray* feeds = [self feedsForAccount:account];

  for (Feed* feed in feeds) {
    [[OperationQueue operationQueue] performSelector:@selector(downloadQueue:account:force:)
                                            onTarget:self
                                          withObject:feed
                                          withObject:account
                                          withObject:[NSNumber numberWithBool:force]
                                                gate:runGate
                                            priority:Priority];
  }
}


- (void) updateBackgroundEntryPointWorker:(NetflixAccount*) account
                                    force:(BOOL) force {
  if (![self canContinue:account]) { return; }

  [[NetflixAccountCache cache] downloadUserInformation:account];
  [self downloadFeeds:account];
  [self downloadQueues:account force:force];

  [[NetflixRssCache cache] update:account];
}


- (void) updateBackgroundEntryPoint:(NetflixAccount*) account force:(NSNumber*) forceValue {
  if (![self canContinue:account]) { return; }
  [self clearUpdatedMovies];

  NSString* notification = LocalizedString(@"Netflix", nil);
  [NotificationCenter addNotification:notification];
  {
    [self updateBackgroundEntryPointWorker:account force:forceValue.boolValue];
  }
  [NotificationCenter removeNotification:notification];
}

- (NSDictionary*) detailsForMovie:(Movie*) movie {
  return [FileUtilities readObject:[NetflixPaths detailsFile:movie]];
}


- (NSArray*) castForMovie:(Movie*) movie {
  movie = [self correspondingNetflixMovie:movie];
  movie = [self promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants castKey]];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  movie = [self correspondingNetflixMovie:movie];
  movie = [self promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants directorsKey]];
}


- (NSString*) netflixRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  movie = [self correspondingNetflixMovie:movie];
  movie = [self promoteDiscToSeries:movie];

  NSString* rating = [FileUtilities readObject:[NetflixPaths predictedRatingsFile:movie account:account]];
  if (rating.length > 0) {
    return rating;
  }

  return [movie.additionalFields objectForKey:[NetflixConstants averageRatingKey]];
}


- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  movie = [self correspondingNetflixMovie:movie];
  movie = [self promoteDiscToSeries:movie];

  return [FileUtilities readObject:[NetflixPaths userRatingsFile:movie account:account]];
}


- (NSArray*) formatsForMovie:(Movie*) movie {
  NSArray* result = [movie.additionalFields objectForKey:[NetflixConstants formatsKey]];
  if (result.count > 0) {
    return result;
  }

  NSDictionary* details = [self detailsForMovie:movie];
  result = [details objectForKey:[NetflixConstants formatsKey]];
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
  movie = [self correspondingNetflixMovie:movie];
  NSString* address = [movie.additionalFields objectForKey:[NetflixConstants linkKey]];
  if (address.length == 0) {
    return @"";
  }

  return address;
}


- (NSString*) availabilityForMovie:(Movie*) movie {
  NSString* availability = [movie.additionalFields objectForKey:[NetflixConstants availabilityKey]];

  return [StringUtilities nonNilString:availability];
}


- (NSArray*) similarMoviesForMovie:(Movie*) movie {
  return [NSArray array];

  if (!movie.isNetflix) {
    return [NSArray array];
  }

  movie = [self promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [Movie decodeArray:[details objectForKey:[NetflixConstants similarsKey]]];
}


- (NSString*) synopsisForMovieDetails:(Movie*) movie {
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants synopsisKey]];
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
      return LocalizedString(@"Downloading information.", nil);
    } else {
      return LocalizedString(@"No synopsis available.", nil);
    }
  }

  return synopsis;
}


- (Status*) statusForMovie:(Movie*) movie inQueue:(Queue*) queue account:(NetflixAccount*) account {
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
    description = LocalizedString(@"At Home", nil);
  } else {
    NSString* queueTitle = [self titleForKey:queue.feed.key includeCount:NO account:account];
    if (saved) {
      description = [NSString stringWithFormat:LocalizedString(@"Saved in %@", @"Saved in Instant Queue"), queueTitle];
    } else {
      description = [NSString stringWithFormat:LocalizedString(@"#%d in %@", @"#15 in Instant Queue"), (position + 1), queueTitle];
    }
  }

  return [Status statusWithQueue:queue
                           movie:foundMovie
                     description:description
                           saved:saved
                        position:position];
}


- (NSArray*) statusesForMovie:(Movie*) movie account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return [NSArray array]; }

  NSMutableArray* array = nil;
  NSArray* searchQueues = [NSArray arrayWithObjects:
                           [self queueForKey:[NetflixConstants discQueueKey] account:account],
                           [self queueForKey:[NetflixConstants instantQueueKey] account:account],
                           [self queueForKey:[NetflixConstants atHomeKey] account:account],
                           nil];

  for (Queue* queue in searchQueues) {
    Status* status = [self statusForMovie:movie inQueue:queue account:account];
    if (status != nil) {
      if (array == nil) {
        array = [NSMutableArray array];
      }

      [array addObject:status];
    }
  }

  return array;
}


- (BOOL) isEnqueued:(Movie*) movie account:(NetflixAccount*) account {
  return [[self statusesForMovie:movie account:account] count] > 0;
}


- (Movie*) correspondingNetflixMovie:(Movie*) movie {
  if (movie == nil) {
    return nil;
  }

  if (movie.isNetflix) {
    return movie;
  }

  NSString* file = [NetflixPaths netflixSearchFile:movie];
  NSDictionary* dictionary = [FileUtilities readObject:file];
  if (dictionary.count == 0) {
    return nil;
  }

  return [Movie createWithDictionary:dictionary];
}


- (BOOL) isInstantWatch:(Movie*) movie {
  return [[self formatsForMovie:movie] containsObject:[NetflixConstants instantFormat]];
}


- (BOOL) isDvd:(Movie*) movie {
  return [[self formatsForMovie:movie] containsObject:[NetflixConstants dvdFormat]];
}


- (BOOL) isBluray:(Movie*) movie {
  return [[self formatsForMovie:movie] containsObject:[NetflixConstants blurayFormat]];
}


- (BOOL) user:(NetflixUser*) user canRentMovie:(Movie*) movie {
  return [self isDvd:movie]
    || ([self isInstantWatch:movie] && user.canInstantWatch)
    || ([self isBluray:movie] && user.canBlurayWatch);
}

@end
