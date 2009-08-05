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
#import "NetflixSharedApplication.h"
#import "NetflixUser.h"
#import "Queue.h"
#import "Status.h"

@interface NetflixCache()
@property (retain) NSMutableDictionary* accountToFeeds;
@property (retain) NSMutableDictionary* accountToFeedKeyToQueues;
@property (retain) NSDate* lastQuotaErrorDate;

- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force account:(NetflixAccount*) account;
@end


@implementation NetflixCache

static NSString* title_key = @"title";
static NSString* series_key = @"series";
static NSString* average_rating_key = @"average_rating";
static NSString* link_key = @"link";
static NSString* availability_key = @"availability";

static NSString* cast_key = @"cast";
static NSString* formats_key = @"formats";
static NSString* synopsis_key = @"synopsis";
static NSString* similars_key = @"similars";
static NSString* directors_key = @"directors";

static NSArray* mostPopularTitles = nil;
static NSDictionary* mostPopularTitlesToAddresses = nil;
static NSDictionary* mostPopularAddressesToTitles = nil;
static NSDictionary* availabilityMap = nil;

static NSString* netflixDirectory = nil;
static NSString* netflixAccountsDirectory = nil;
static NSString* netflixSeriesDirectory = nil;
static NSString* netflixSearchDirectory = nil;
static NSString* netflixDetailsDirectory = nil;
static NSString* netflixRSSDirectory = nil;

static NSString** directories[] = {
&netflixDirectory,
&netflixAccountsDirectory,
&netflixSeriesDirectory,
&netflixSearchDirectory,
&netflixDetailsDirectory,
&netflixRSSDirectory,
};


+ (void) createDirectories {
  for (int i = 0; i < ArrayLength(directories); i++) {
    NSString* directory = *directories[i];

    [FileUtilities createDirectory:directory];
  }
}


+ (void) initialize {
  if (self == [NetflixCache class]) {
    netflixDirectory = [[[AbstractApplication cacheDirectory] stringByAppendingPathComponent:@"Netflix"] retain];
    netflixAccountsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Accounts"] retain];
    netflixSeriesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Series"] retain];
    netflixDetailsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Details"] retain];
    netflixSearchDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Search"] retain];
    netflixRSSDirectory = [[netflixDirectory stringByAppendingPathComponent:@"RSS"] retain];
    [self createDirectories];

    mostPopularTitles =
    [[NSArray arrayWithObjects:
      LocalizedString(@"Top DVDs", @"Movie category"),
      LocalizedString(@"Top 'Instant Watch'", @"Movie category"),
      LocalizedString(@"New DVDs", @"Movie category"),
      LocalizedString(@"New 'Instant Watch'", @"Movie category"),
      LocalizedString(@"Action & Adventure", @"Movie category"),
      LocalizedString(@"Anime & Animation", @"Movie category"),
      LocalizedString(@"Blu-ray", nil),
      LocalizedString(@"Children & Family", @"Movie category"),
      LocalizedString(@"Classics", @"Movie category"),
      LocalizedString(@"Comedy", @"Movie category"),
      LocalizedString(@"Documentary", @"Movie category"),
      LocalizedString(@"Drama", @"Movie category"),
      LocalizedString(@"Faith & Spirituality", @"Movie category"),
      LocalizedString(@"Foreign", @"Movie category"),
      LocalizedString(@"Gay & Lesbian", @"Movie category"),
      LocalizedString(@"Horror", @"Movie category"),
      LocalizedString(@"Independent", @"Movie category"),
      LocalizedString(@"Music & Musicals", @"Movie category"),
      LocalizedString(@"Romance", @"Movie category"),
      LocalizedString(@"Sci-Fi & Fantasy", @"Movie category"),
      LocalizedString(@"Special Interest", @"Movie category"),
      LocalizedString(@"Sports & Fitness", @"Movie category"),
      LocalizedString(@"Television", @"Movie category"),
      LocalizedString(@"Thrillers", @"Movie category"),
      nil] retain];

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
       @"http://rss.netflix.com/Top25RSS?gid=387",
       nil]
                                 forKeys:mostPopularTitles] retain];

    NSAssert(mostPopularTitles.count == mostPopularTitlesToAddresses.count, @"");

    {
      NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
      for (NSString* title in mostPopularTitlesToAddresses) {
        [dictionary setObject:title forKey:[mostPopularTitlesToAddresses objectForKey:title]];
      }
      mostPopularAddressesToTitles = dictionary;
    }

    availabilityMap =
    [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                          LocalizedString(@"Awaiting Release", @"Movie can't be shipped because it hasn't been released yet"),
                                          LocalizedString(@"Available Now", @"Movie is available to be shipped now"),
                                          LocalizedString(@"Saved", @"Movie is the user's 'Saved to watch later' queue"),
                                          LocalizedString(@"Short Wait", @"There will be a short wait before the movie is released"),
                                          LocalizedString(@"Short Wait", nil),
                                          LocalizedString(@"Long Wait", @"There will be a long wait before the movie is released"),
                                          LocalizedString(@"Very Long Wait", @"There will be a very long wait before the movie is released"),
                                          LocalizedString(@"Available Soon", @"Movie will be released soon"),
                                          LocalizedString(@"Not Rentable", @"Movie is not currently rentable"),
                                          LocalizedString(@"Unknown Release Date", @"The release date for a movie is unknown."),
                                          LocalizedString(@"Unknown Release Date", nil),
                                          LocalizedString(@"Unknown Release Date", nil),
                                          nil]
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
                                          @"availability date is unknown.",
                                          nil]] retain];
  }
}


+ (NSArray*) mostPopularTitles {
  return mostPopularTitles;
}

@synthesize accountToFeeds;
@synthesize accountToFeedKeyToQueues;
@synthesize lastQuotaErrorDate;

- (void) dealloc {
  self.accountToFeeds = nil;
  self.accountToFeedKeyToQueues = nil;
  self.lastQuotaErrorDate = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.accountToFeeds = [NSMutableDictionary dictionary];
    self.accountToFeedKeyToQueues = [NSMutableDictionary dictionary];
  }

  return self;
}


- (NSString*) noInformationFound {
  if ([[OperationQueue operationQueue] hasPriorityOperations]) {
    return LocalizedString(@"Downloading data", nil);
  } else if (![NetworkUtilities isNetworkAvailable]) {
    return LocalizedString(@"Network unavailable", nil);
  } else {
    return LocalizedString(@"No information found", nil);
  }
}


+ (NSString*) accountDirectory:(NetflixAccount*) account {
  return [netflixAccountsDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:account.userId]];
}


+ (NSString*) userRatingsDirectory:(NetflixAccount*) account {
  return [[self accountDirectory:account] stringByAppendingPathComponent:@"UserRatings"];
}


+ (NSString*) predictedRatingsDirectory:(NetflixAccount*) account {
  return [[self accountDirectory:account] stringByAppendingPathComponent:@"PredictedRatings"];
}


+ (NSString*) feedsFile:(NetflixAccount*) account {
  return [[self accountDirectory:account] stringByAppendingPathComponent:@"Feeds.plist"];
}


+ (NSArray*) loadAccountToFeeds:(NetflixAccount*) account {
  NSArray* array = [FileUtilities readObject:[self feedsFile:account]];
  return [Feed decodeArray:array];
}


+ (void) saveFeeds:(NSArray*) feeds account:(NetflixAccount*) account {
  if (feeds.count == 0) {
    return;
  }

  [FileUtilities writeObject:[Feed encodeArray:feeds]
                      toFile:[self feedsFile:account]];
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
    [[result retain] autorelease];
  }
  [dataGate unlock];
  return result;
}


+ (NSString*) queueFile:(Feed*) feed account:(NetflixAccount*) account {
  return [[[self accountDirectory:account] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:feed.key]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) queueEtagFile:(Feed*) feed account:(NetflixAccount*) account {
  NSString* name = [NSString stringWithFormat:@"%@-etag", feed.key];
  return [[[self accountDirectory:account] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:name]]
          stringByAppendingPathExtension:@"plist"];
}


+ (Queue*) loadQueue:(Feed*) feed account:(NetflixAccount*) account {
  NSLog(@"Loading queue: %@", feed.name);
  NSDictionary* dictionary = [FileUtilities readObject:[self queueFile:feed account:account]];
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
    [[queue retain] autorelease];
  }
  [dataGate unlock];
  return queue;
}


- (void) update {
  NetflixAccount* account = [NetflixSharedApplication currentNetflixAccount];
  if ([NetflixSharedApplication netflixEnabled] &&
      account.userId.length > 0) {
    [FileUtilities createDirectory:[NetflixCache accountDirectory:account]];
    [FileUtilities createDirectory:[NetflixCache userRatingsDirectory:account]];
    [FileUtilities createDirectory:[NetflixCache predictedRatingsDirectory:account]];
    
    [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint:)
                                            onTarget:self
                                          withObject:account
                                                gate:runGate
                                            priority:Priority];
  }
}


- (BOOL) canContinue:(NetflixAccount*) account {
  return [NetflixSharedApplication netflixEnabled] &&
  [account isEqual:[NetflixSharedApplication currentNetflixAccount]];
}


- (void) checkApiResult:(XmlElement*) element {
  NSString* message = [[element element:@"message"] text];
  if ([@"Over queries per day limit" isEqual:message]) {
    self.lastQuotaErrorDate = [NSDate date];
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (NSArray*) downloadFeeds:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", account.userId];
  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:address account:account];

  [request prepare];
  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

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

        if ([key isEqual:[NetflixCache atHomeKey]]) {
          [feeds insertObject:feed atIndex:0];
        } else {
          [feeds addObject:feed];
        }
      }
    }
  }

  return feeds;
}


+ (NSArray*) extractFormats:(XmlElement*) element {
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
      } else if ([@"http://schemas.netflix.com/catalog/titles/format_availability" isEqual:rel]) {
        NSArray* formats = [self extractFormats:[child element:@"delivery_formats"]];
        if (formats.count > 0) {
          [additionalFields setObject:formats forKey:formats_key];
        }
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


- (void) saveQueue:(Queue*) queue account:(NetflixAccount*) account {
  NSLog(@"Saving queue '%@' with etag '%@'", queue.feed.name, queue.etag);
  [FileUtilities writeObject:queue.dictionary toFile:[NetflixCache queueFile:queue.feed account:account]];
  [FileUtilities writeObject:queue.etag toFile:[NetflixCache queueEtagFile:queue.feed account:account]];
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


- (NSString*) downloadEtag:(Feed*) feed {
  NSRange range = [feed.url rangeOfString:@"&output=atom"];
  NSString* url = feed.url;
  if (range.length > 0) {
    url = [NSString stringWithFormat:@"%@%@", [url substringToIndex:range.location], [url substringFromIndex:range.location + range.length]];
  }

  NSString* address = [NSString stringWithFormat:@"%@&max_results=1", url];

  NSHTTPURLResponse* response;
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
                                                          response:&response];

  return [self extractEtagFromElement:element andResponse:response];
}


- (BOOL) etagChanged:(Feed*) feed account:(NetflixAccount*) account {
  NSString* localEtag = [FileUtilities readObject:[NetflixCache queueEtagFile:feed account:account]];
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
  [self processMovieItemList:element movies:movies
                       saved:saved
                    maxCount:-1];
}


- (NSString*) extractErrorMessage:(XmlElement*) element {
  NSString* message = [[element element:@"message"] text];
  if (message.length > 0) {
    return message;
  } else if (element == nil) {
    NSLog(@"Could not parse Netflix result.", nil);
    return LocalizedString(@"Could not connect to Netflix.", nil);
  } else {
    NSLog(@"Netflix response had no 'message' element", nil);
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

  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:@"http://api.netflix.com/catalog/titles" account:account];

  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"expand" value:@"formats"],
                         [OARequestParameter parameterWithName:@"term" value:query],
                         [OARequestParameter parameterWithName:@"max_results" value:[NSString stringWithFormat:@"%d", maxResults]],
                         nil];

  [NSMutableURLRequestAdditions setParameters:parameters
                                   forRequest:request];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [self checkApiResult:element];

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


- (void) downloadQueueWorker:(Feed*) feed account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSRange range = [feed.url rangeOfString:@"&output=atom"];
  NSString* address = feed.url;
  if (range.length > 0) {
    address = [NSString stringWithFormat:@"%@%@", [address substringToIndex:range.location], [address substringFromIndex:range.location + range.length]];
  }

  address = [NSString stringWithFormat:@"%@&max_results=500", address];

  NSHTTPURLResponse* response;
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address
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
  if ([key isEqual:[NetflixCache dvdQueueKey]]) {
    title = LocalizedString(@"Disc Queue", @"The Netflix queue containing the user's DVDs");
  } else if ([key isEqual:[NetflixCache instantQueueKey]]) {
    title = LocalizedString(@"Instant Queue", @"The Netflix queue containing the user's streaming movies");
  } else if ([key isEqual:[NetflixCache atHomeKey]]) {
    title = LocalizedString(@"At Home", @"The list of Netflix movies currently at the user's house");
  } else if ([key isEqual:[NetflixCache rentalHistoryWatchedKey]]) {
    title = LocalizedString(@"Recently Watched", @"The list of Netflix movies the user recently watched");
  } else if ([key isEqual:[NetflixCache rentalHistoryReturnedKey]]) {
    title = LocalizedString(@"Recently Returned", @"The list of Netflix movies the user recently returned");
  } else if ([key isEqual:[NetflixCache rentalHistoryKey]]) {
    title = LocalizedString(@"Entire History", @"The entire list of Netflix movies the user has seen");
  } else if ([key isEqual:[NetflixCache recommendationKey]]) {
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


- (void) downloadQueue:(Feed*) feed account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSLog(@"NetflixCache:downloadQueue - %@", feed.name);

  // first download and check the feed's current etag against the current one.
  if (![self etagChanged:feed account:account]) {
    NSLog(@"Etag unchanged for '%@'.  Skipping download.", feed.name);
  } else {
    NSLog(@"Etag changed for '%@'.  Downloading.", feed.name);
    NSString* title = [self titleForKey:feed.key includeCount:NO account:account];
    NSString* notification = [NSString stringWithFormat:@"Netflix '%@'", title];
    [NotificationCenter addNotification:notification];
    {
      [self downloadQueueWorker:feed account:account];
    }
    [NotificationCenter removeNotification:notification];
  }

  Queue* queue = [self queueForFeed:feed account:account];

  [NetflixSharedApplication reportNetflixMovies:queue.movies];
  [NetflixSharedApplication reportNetflixMovies:queue.saved];
}


+ (NSString*) userFile:(NetflixAccount*) account {
  return [[self accountDirectory:account] stringByAppendingPathComponent:@"User.plist"];
}


- (NetflixUser*) userForAccount:(NetflixAccount*) account {
  if (account == nil) {
    return nil;
  }

  NSDictionary* dictionary = [FileUtilities readObject:[NetflixCache userFile:account]];
  if (dictionary.count == 0) {
    return nil;
  }
  return [NetflixUser newWithDictionary:dictionary];
}


+ (NetflixUser*) downloadUserInformation:(NetflixAccount*) account {
  NSLog(@"NetflixCache:downloadUserData");

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@", account.userId];
  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:address account:account];

  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];
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

  if (firstName.length == 0 && lastName.length == 0) {
    return nil;
  }
  
  NetflixUser* user = [NetflixUser userWithFirstName:firstName lastName:lastName canInstantWatch:canInstantWatch preferredFormats:preferredFormats];
  [FileUtilities writeObject:user.dictionary toFile:[self userFile:account]];
  return user;
}


+ (NSArray*) extractPeople:(XmlElement*) element {
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
  [[netflixSeriesDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:seriesKey]]
   stringByAppendingPathExtension:@"plist"];
}


- (Movie*) downloadMovieWithSeriesKey:(NSString*) seriesKey account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:seriesKey account:account];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [self checkApiResult:element];

  return [NetflixCache processMovieItem:element saved:NULL];
}


- (Movie*) downloadRSSMovieWithSeriesIdentifier:(NSString*) identifier account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  //NSString* seriesKey = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/series/%@?expand=synopsis,cast,directors,formats,similars", identifier];
  NSString* seriesKey = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/series/%@?expand=synopsis,cast,directors,formats", identifier];
  return [self downloadMovieWithSeriesKey:seriesKey account:account];
}


- (void) updateSeriesDetails:(Movie*) movie account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* seriesKey = [movie.additionalFields objectForKey:series_key];
  if (seriesKey.length == 0) {
    return;
  }

  NSString* file = [self seriesFile:seriesKey];
  Movie* series;
  if ([FileUtilities fileExists:file]) {
    series = [Movie newWithDictionary:[FileUtilities readObject:file]];
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
  return [movie.additionalFields objectForKey:series_key] != nil;
}


- (Movie*) seriesForDisc:(Movie*) movie {
  NSDictionary* dictionary = [FileUtilities readObject:[self seriesFile:[movie.additionalFields objectForKey:series_key]]];
  if (dictionary == nil) {
    return nil;
  }

  return [Movie newWithDictionary:dictionary];
}


- (Movie*) promoteDiscToSeries:(Movie*) disc {
  Movie* series = [self seriesForDisc:disc];
  if (series == nil) {
    return disc;
  }
  return series;
}


+ (NSString*) userRatingsFile:(Movie*) movie account:(NetflixAccount*) account {
  return [[[self userRatingsDirectory:account] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
          stringByAppendingPathExtension:@"plist"];

}


+ (NSString*) predictedRatingsFile:(Movie*) movie account:(NetflixAccount*) account {
  return [[[self predictedRatingsDirectory:account] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
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


- (void) updateRatings:(Movie*) movie account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* userRatingsFile = [NetflixCache userRatingsFile:movie account:account];
  NSString* predictedRatingsFile = [NetflixCache predictedRatingsFile:movie account:account];

  if ([self tooSoon:predictedRatingsFile] &&
      [self tooSoon:userRatingsFile]) {
    return;
  }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/ratings/title", account.userId];
  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:address account:account];
  OARequestParameter* parameter = [OARequestParameter parameterWithName:@"title_refs" value:movie.identifier];
  [NSMutableURLRequestAdditions setParameters:[NSArray arrayWithObject:parameter] forRequest:request];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

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


+ (NSString*) cleanupSynopsis:(NSString*) synopsis {
  return [StringUtilities convertHtmlEncodings:[StringUtilities stripHtmlLinks:synopsis]];
}


+ (NSDictionary*) extractMovieDetails:(XmlElement*) element {
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
  return [[netflixRSSDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]] stringByAppendingPathExtension:@"plist"];
}


- (void) addCategoryNotification:(NSString*) notification {
  if ([NetflixSharedApplication netflixNotificationsEnabled]) {
    [NotificationCenter addNotification:notification];
  }
}


- (void) removeCategoryNotification:(NSString*) notification {
  [NotificationCenter removeNotification:notification];
}


- (void) downloadRSSFeedWorker:(NSString*) address {
  NSString* file = [self rssFile:address];
  if ([FileUtilities fileExists:file]) {
    NSDate* date = [FileUtilities modificationDate:file];
    if (date != nil) {
      if (ABS(date.timeIntervalSinceNow) < ONE_WEEK) {
        return;
      }
    }
  }

  NSString* notification = [NSString stringWithFormat:@"Netflix '%@'", [mostPopularAddressesToTitles objectForKey:address]];
  [self addCategoryNotification:notification];
  {
    NSLog(@"Downlading RSS Feed: %@", address);
    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address];
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
  [self removeCategoryNotification:notification];
}


- (void) downloadRSSFeedMovies:(NSString*) address
                       account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* file = [self rssFile:address];
  NSArray* identifiers = [FileUtilities readObject:file];

  if (identifiers.count == 0) {
    return;
  }

  NSString* notification = [NSString stringWithFormat:@"Netflix '%@'", [mostPopularAddressesToTitles objectForKey:address]];

  [[OperationQueue operationQueue] performSelector:@selector(addCategoryNotification:)
                                          onTarget:self
                                        withObject:notification
                                              gate:nil
                                          priority:Normal];


  for (NSString* identifier in [identifiers shuffledArray]) {
    [[OperationQueue operationQueue] performSelector:@selector(downloadRSSMovie:address:account:)
                                            onTarget:self
                                          withObject:identifier
                                          withObject:address
                                          withObject:account
                                                gate:nil
                                            priority:Normal];
  }

  [[OperationQueue operationQueue] performSelector:@selector(removeCategoryNotification:)
                                          onTarget:self
                                        withObject:notification
                                              gate:nil
                                          priority:Normal];
}


- (void) downloadRSSFeed:(NSString*) address account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  [self downloadRSSFeedWorker:address];
  [self downloadRSSFeedMovies:address account:account];
}


- (NSString*) rssFeedDirectory:(NSString*) address {
  return [netflixRSSDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]];
}


- (NSString*) rssMovieFile:(NSString*) identifier address:(NSString*) address {
  return [[[self rssFeedDirectory:address]
           stringByAppendingPathComponent:[FileUtilities sanitizeFileName:identifier]]
          stringByAppendingPathExtension:@"plist"];
}


- (NSString*) detailsFile:(Movie*) movie {
  return [[netflixDetailsDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (Movie*) downloadRSSMovieWithIdentifier:(NSString*) identifier
                                  account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  //NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/movies/%@?expand=synopsis,cast,directors,formats,similars", identifier];
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/movies/%@?expand=synopsis,cast,directors,formats", identifier];

  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:address account:account];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];
  return [NetflixCache processMovieItem:element saved:NULL];
}


- (NSArray*) moviesForRSSTitle:(NSString*) title {
  NSMutableArray* array = [NSMutableArray array];

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:title];

    NSString* directory = [self rssFeedDirectory:address];
    NSArray* paths = [FileUtilities directoryContentsPaths:directory];

    for (NSString* path in paths) {
      NSDictionary* dictionary = [FileUtilities readObject:path];
      if (dictionary != nil) {
        Movie* movie = [Movie newWithDictionary:dictionary];
        [array addObject:movie];
      }
    }
  }
  [pool release];

  return array;
}


- (NSInteger) movieCountForRSSTitle:(NSString*) title {
  NSString* address = [mostPopularTitlesToAddresses objectForKey:title];

  NSString* directory = [self rssFeedDirectory:address];
  NSArray* paths = [FileUtilities directoryContentsNames:directory];

  return paths.count;
}


- (void) updateSpecificDiscDetails:(Movie*) movie
                            expand:(NSString*) expand
                           account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

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

  OAMutableURLRequest* request = [AbstractNetflixCache createURLRequest:address account:account];
  [request prepare];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];
  NSDictionary* dictionary = [NetflixCache extractMovieDetails:element];
  if (dictionary.count > 0) {
    [FileUtilities writeObject:dictionary toFile:path];
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (void) updateAllDiscDetails:(Movie*) movie
                      account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  // we don't download this stuff on a per disc basis.  only for a series.
  //[self updateSpecificDiscDetails:movie expand:@"synopsis,cast,directors,formats,similars"];
  [self updateSpecificDiscDetails:movie expand:@"synopsis,cast,directors,formats" account:account];
  [self updateRatings:movie account:account];
}


- (NSString*) netflixFile:(Movie*) movie {
  return [[netflixSearchDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) lookupCorrespondingNetflixMovie:(Movie*) movie account:(NetflixAccount*) account {
  NSAssert(![NSThread isMainThread], @"");

  if (account.userId.length == 0) {
    return;
  }

  if ([movie isNetflix]) {
    return;
  }

  NSString* file = [self netflixFile:movie];
  if (![FileUtilities fileExists:file]) {
    NSArray* movies = [self movieSearch:movie.canonicalTitle maxResults:1 account:account error:NULL];
    if (movies.count > 0) {
      Movie* netflixMovie = [movies objectAtIndex:0];
      if (netflixMovie != nil) {
        [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
        [NetflixSharedApplication reportNetflixMovie:netflixMovie];
        [MetasyntacticSharedApplication minorRefresh];
      }
    }
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
        [self updateAllDiscDetails:movie account:account];
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


- (void) downloadRSSMovie:(NSString*) identifier
                  address:(NSString*) address
                  account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* file = [self rssMovieFile:identifier address:address];

  Movie* movie;
  if ([FileUtilities fileExists:file]) {
    movie = [Movie newWithDictionary:[FileUtilities readObject:file]];
  } else {
    movie = [self downloadRSSMovieWithIdentifier:identifier account:account];
    if (movie.canonicalTitle.length == 0) {
      // might have been a series.
      movie = [self downloadRSSMovieWithSeriesIdentifier:identifier account:account];
    }

    if (movie.canonicalTitle.length > 0) {
      [FileUtilities writeObject:movie.dictionary toFile:file];
    }
  }

  [NetflixSharedApplication reportNetflixMovie:movie];
}


- (void) downloadRSS:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSLog(@"NetflixCache:downloadRSS");

  for (NSString* key in [mostPopularTitles shuffledArray]) {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:key];
    [FileUtilities createDirectory:[self rssFeedDirectory:address]];

    [[OperationQueue operationQueue] performSelector:@selector(downloadRSSFeed:account:)
                                            onTarget:self
                                          withObject:address
                                          withObject:account
                                                gate:nil
                                            priority:Priority];
  }
}


+ (BOOL) feeds:(NSArray*) feeds containsKey:(NSString*) key {
  for (Feed* feed in feeds) {
    if ([feed.key isEqual:key]) {
      return YES;
    }
  }

  return NO;
}


- (void) updateBackgroundEntryPointWorker:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  [NetflixCache downloadUserInformation:account];

  NSArray* feeds = [self downloadFeeds:account];

  if (feeds.count > 0) {
    [NetflixCache saveFeeds:feeds account:account];

    [dataGate lock];
    {
      [self.accountToFeeds setObject:feeds forKey:account.userId];
    }
    [dataGate unlock];

    [MetasyntacticSharedApplication majorRefresh];
  }

  for (Feed* feed in feeds) {
    [[OperationQueue operationQueue] performSelector:@selector(downloadQueue:account:)
                                            onTarget:self
                                          withObject:feed
                                          withObject:account
                                                gate:runGate
                                            priority:Priority];
  }

  [[OperationQueue operationQueue] performSelector:@selector(downloadRSS:)
                                          onTarget:self
                                        withObject:account
                                              gate:nil // no lock.
                                          priority:Priority];
}


- (void) updateBackgroundEntryPoint:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }
  [self clearUpdatedMovies];

  NSString* notification = LocalizedString(@"Netflix", nil);
  [NotificationCenter addNotification:notification];
  {
    [self updateBackgroundEntryPointWorker:account];
  }
  [NotificationCenter removeNotification:notification];
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


- (NSString*) netflixRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  movie = [self promoteDiscToSeries:movie];

  NSString* rating = [FileUtilities readObject:[NetflixCache predictedRatingsFile:movie account:account]];
  if (rating.length > 0) {
    return rating;
  }

  return [movie.additionalFields objectForKey:average_rating_key];
}


- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  movie = [self promoteDiscToSeries:movie];

  return [FileUtilities readObject:[NetflixCache userRatingsFile:movie account:account]];
}


- (NSArray*) formatsForMovie:(Movie*) movie {
  NSArray* result = [movie.additionalFields objectForKey:formats_key];
  if (result.count > 0) {
    return result;
  }

  NSDictionary* details = [self detailsForMovie:movie];
  result = [details objectForKey:formats_key];
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
  NSMutableArray* array = nil;
  NSArray* searchQueues = [NSArray arrayWithObjects:
                           [self queueForKey:[NetflixCache dvdQueueKey] account:account],
                           [self queueForKey:[NetflixCache instantQueueKey] account:account],
                           [self queueForKey:[NetflixCache atHomeKey] account:account],
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
  if (movie.isNetflix) {
    return movie;
  }

  NSString* file = [self netflixFile:movie];
  NSDictionary* dictionary = [FileUtilities readObject:file];
  if (dictionary.count == 0) {
    return nil;
  }

  return [Movie newWithDictionary:dictionary];
}

@end
