// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NetflixCache.h"

#import "Feed.h"
#import "Movie.h"
#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixConstants.h"
#import "NetflixFeedCache.h"
#import "NetflixNetworking.h"
#import "NetflixPaths.h"
#import "NetflixRssCache.h"
#import "NetflixSharedApplication.h"
#import "NetflixSiteStatus.h"
#import "NetflixUpdater.h"
#import "NetflixUser.h"
#import "NetflixUserCache.h"
#import "NetflixUtilities.h"
#import "Person.h"
#import "Queue.h"
#import "Status.h"

@interface NetflixCache()
- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force account:(NetflixAccount*) account;
@end


@implementation NetflixCache

@synthesize lastError;

- (void) dealloc {
  self.lastError = nil;
  [super dealloc];
}

static NetflixCache* cache;

+ (void) initialize {
  if (self == [NetflixCache class]) {
    cache = [[NetflixCache alloc] init];
  }
}


+ (NetflixCache*) cache {
  return cache;
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


- (void) update:(NetflixAccount*) account force:(BOOL) force {
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


+ (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account
                   response:(NSHTTPURLResponse**) response {

  BOOL outOfDate;
  XmlElement* element =
    [NetflixNetworking downloadXml:request
                           account:account
                          response:response
                         outOfDate:&outOfDate];

  if (outOfDate) {
    // Ok, we're out of date with the netflix servers.  Force a redownload of the users' queues.
    NSLog(@"Etag mismatch error. Force a redownload of the user's queues.");
    [[NetflixCache cache] updateQueues:account force:YES];
  }

  return element;
}


+ (XmlElement*) downloadXml:(NSURLRequest*) request account:(NetflixAccount*) account {
  return [self downloadXml:request account:account response:NULL];
}


- (NSArray*) downloadFeedsWorker:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/users/%@/feeds", account.userId];
  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [NetflixCache downloadXml:request account:account];

  NSArray* allowableKeys = [NSArray arrayWithObjects:
                            [NetflixConstants atHomeKey],
                            [NetflixConstants discQueueKey],
                            [NetflixConstants instantQueueKey],
                            [NetflixConstants recommendationKey],
                            [NetflixConstants rentalHistoryKey],
                            [NetflixConstants rentalHistoryWatchedKey],
                            [NetflixConstants rentalHistoryReturnedKey],
                            [NetflixConstants rentalHistoryShippedKey], nil];

  NSMutableArray* allFeeds = [NSMutableArray array];

  for (XmlElement* child in element.children) {
    if ([child.name isEqual:@"link"]) {
      NSString* key = [child attributeValue:@"rel"];

      if ([allowableKeys containsObject:key]) {
        Feed* feed = [Feed feedWithUrl:[child attributeValue:@"href"]
                                   key:key
                                  name:[child attributeValue:@"title"]];

        [allFeeds addObject:feed];
      }
    }
  }

  NSMutableArray* feeds = [NSMutableArray array];
  for (NSString* allowableKey in allowableKeys) {
    for (Feed* feed in allFeeds) {
      if ([allowableKey isEqual:feed.key]) {
        [feeds addObject:feed];
      }
    }
  }

  return feeds;
}


- (void) downloadFeeds:(NetflixAccount*) account {
  NSArray* feeds = [self downloadFeedsWorker:account];

  if (feeds.count > 0) {
    [[NetflixFeedCache cache] saveFeeds:feeds account:account];
    [MetasyntacticSharedApplication majorRefresh];
  }
}


+ (NSString*) extractEtagFromElement:(XmlElement*) element andResponse:(NSHTTPURLResponse*) response {
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


+ (NSString*) downloadEtag:(Feed*) feed account:(NetflixAccount*) account {
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

  NSString* serverEtag = [NetflixCache downloadEtag:feed account:account];

  return ![serverEtag isEqual:localEtag];
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

  XmlElement* element = [NetflixCache downloadXml:request account:account];

  if (element == nil) {
    if (error != NULL) {
      *error = [NetflixUtilities extractErrorMessage:element];
    }
    return nil;
  }

  NSMutableArray* movies = [NSMutableArray array];
  NSMutableArray* saved = [NSMutableArray array];
  [NetflixUtilities processMovieItemList:element movies:movies saved:saved];

  [movies addObjectsFromArray:saved];

  return movies;
}


- (NSArray*) movieSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error {
  return [self movieSearch:query maxResults:30 account:account error:error];
}


- (NSArray*) personSearch:(NSString*) query
               maxResults:(NSInteger) maxResults
                  account:(NetflixAccount*) account
                    error:(NSString**) error {
  if (error != NULL) {
    *error = nil;
  }

  if ([@"kate winslet" isEqual:query]) {
    NSLog(@"");
  }

  NSURLRequest* request =
  [NetflixNetworking createGetURLRequest:@"http://api.netflix.com/catalog/people"
                              parameters:[NSArray arrayWithObjects:
                                          [OARequestParameter parameterWithName:@"expand" value:@"filmography"],
                                          [OARequestParameter parameterWithName:@"term" value:query],
                                          [OARequestParameter parameterWithName:@"max_results" value:[NSString stringWithFormat:@"%d", maxResults]],
                                          nil]
                                 account:account];

  XmlElement* element = [NetflixCache downloadXml:request account:account];

  if (element == nil) {
    if (error != NULL) {
      *error = [NetflixUtilities extractErrorMessage:element];
    }
    return nil;
  }

  NSMutableArray* people = [NSMutableArray array];

  for (XmlElement* personElement in [element elements:@"person"]) {
    NSString* identifier = [[personElement element:@"id"] text];
    NSString* name = [[personElement element:@"name"] text];
    NSString* biography = [[personElement element:@"bio"] text];
    NSString* website = nil;

    XmlElement* filmElement = [personElement element:@"filmography" recurse:YES];
    NSMutableArray* filmography = [NSMutableArray array];
    for (XmlElement* linkElement in [filmElement elements:@"link"]) {
      NSString* href = [linkElement attributeValue:@"href"];
      if (href.length > 0) {
        [filmography addObject:href];
      }
    }

    for (XmlElement* linkElement in [element elements:@"link"]) {
      if ([@"webpage" isEqual:[linkElement attributeValue:@"title"]]) {
        website = [linkElement attributeValue:@"href"];
      }
    }

    NSDictionary* additionalFields = [NSDictionary dictionaryWithObject:filmography
                                                                 forKey:[NetflixConstants filmographyKey]];

    [people addObject:[Person personWithIdentifier:identifier
                                              name:name
                                         biography:biography
                                           website:website
                                  additionalFields:additionalFields]];
  }

  return people;
}


- (NSArray*) personSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error {
  return [self personSearch:query maxResults:5 account:account error:error];
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
  XmlElement* element = [NetflixCache downloadXml:[NSURLRequest requestWithURL:[NSURL URLWithString:address]]
                                  account:account
                                 response:&response];

  NSString* etag = [NetflixCache extractEtagFromElement:element andResponse:response];

  NSMutableArray* movies = [NSMutableArray array];
  NSMutableArray* saved = [NSMutableArray array];
  [NetflixUtilities processMovieItemList:element movies:movies saved:saved];

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
    [[NetflixFeedCache cache] saveQueue:queue account:account];
  }
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
  } else if ([key isEqual:[NetflixConstants rentalHistoryShippedKey]]) {
    title = LocalizedString(@"Recently Shipped", @"The list of Netflix movies that has just been shipped to the user");
  } else if ([key isEqual:[NetflixConstants rentalHistoryKey]]) {
    title = LocalizedString(@"Entire History", @"The entire list of Netflix movies the user has seen");
  } else if ([key isEqual:[NetflixConstants recommendationKey]]) {
    title = LocalizedString(@"Recommendations", @"Movie recommendations from Netflix");
  }

  Queue* queue;
  if (!includeCount || ((queue = [[NetflixFeedCache cache] queueForKey:key account:account]) == nil)) {
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
  Queue* queue = [[NetflixFeedCache cache] queueForFeed:feed account:account];
  BOOL queueIsEmpty = queue.movies.count == 0 && queue.saved.count == 0;
  
  // first download and check the feed's current etag against the current one.
  if (force || queueIsEmpty || [self etagChanged:feed account:account]) {
    if (force) {
      NSLog(@"Forcing update of '%@'.", feed.name);
    } else if (queueIsEmpty) {
      NSLog(@"Redownloading empty queue '%@'.", feed.name);
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

  queue = [[NetflixFeedCache cache] queueForFeed:feed account:account];

  [NetflixSharedApplication reportNetflixMovies:queue.movies];
  [NetflixSharedApplication reportNetflixMovies:queue.saved];
}


- (Movie*) downloadMovieWithSeriesKey:(NSString*) seriesKey
                              account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:seriesKey account:account];

  XmlElement* element = [NetflixCache downloadXml:request account:account];

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


+ (Movie*) seriesForDisc:(Movie*) movie {
  NSDictionary* dictionary =
    [FileUtilities readObject:
     [NetflixPaths seriesFile:[movie.additionalFields objectForKey:[NetflixConstants seriesKey]]]];
  return [Movie createWithDictionary:dictionary];
}


+ (Movie*) promoteDiscToSeries:(Movie*) disc {
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

  XmlElement* element = [NetflixCache downloadXml:request account:account];

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
                             force:(BOOL) force
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
  if (!force && [FileUtilities fileExists:path]) {
    return;
  }

  address = [NSString stringWithFormat:@"%@?expand=%@", address, expand];

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [NetflixCache downloadXml:request account:account];

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
  [self updateSpecificDiscDetails:movie force:force expand:@"synopsis,cast,directors,formats" account:account];
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

  NSString* file = [NetflixPaths searchFile:movie];
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


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force
                    account:(NetflixAccount*) account {
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
        [self updateSpecificDiscDetails:movie force:force expand:@"synopsis,formats" account:account];
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


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force {
  [self updateMovieDetails:movie
                     force:force
                   account:[[NetflixAccountCache cache] currentAccount]];
}


- (Movie*) movieForFilmographyAddress:(NSString*) filmographyAddress {
  NSString* file = [NetflixPaths filmographyFile:filmographyAddress];
  NSDictionary* dictionary = [FileUtilities readObject:file];
  return [Movie createWithDictionary:dictionary];
}


- (void) updatePerson:(Person*) person
   filmographyAddress:(NSString*) filmographyAddress
                force:(BOOL) force
              account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* file = [NetflixPaths filmographyFile:filmographyAddress];
  Movie* netflixMovie = nil;
  if ([FileUtilities fileExists:file]) {
    netflixMovie = [self movieForFilmographyAddress:filmographyAddress];
  } else {
    NSURLRequest* request =
    [NetflixNetworking createGetURLRequest:filmographyAddress
                                parameter:[OARequestParameter parameterWithName:@"expand" value:@"formats"]
                                   account:account];

    XmlElement* element = [NetflixCache downloadXml:request account:account];

    netflixMovie = [NetflixUtilities processMovieItem:element];
    if (netflixMovie != nil) {
      [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
      [MetasyntacticSharedApplication minorRefresh];
    }
  }

  if (netflixMovie != nil) {
    [NetflixSharedApplication reportNetflixMovie:netflixMovie];
  }
}


- (void) updatePersonDetails:(Person*) person
                       force:(BOOL) force
                     account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  for (NSString* filmographyAddress in [self filmographyAddressesForPerson:person]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self updatePerson:person
      filmographyAddress:filmographyAddress
                   force:force
                 account:account];
    }
    [pool release];
  }
}


- (void) updatePersonDetails:(Person*) person
                       force:(BOOL) force {
  if (!force) {
    return;
  }

  [self updatePersonDetails:person
                     force:force
                   account:[[NetflixAccountCache cache] currentAccount]];
}


+ (BOOL) feeds:(NSArray*) feeds containsKey:(NSString*) key {
  for (Feed* feed in feeds) {
    if ([feed.key isEqual:key]) {
      return YES;
    }
  }

  return NO;
}


- (void) updateQueues:(NetflixAccount*) account force:(BOOL) force {
  NSArray* feeds = [[NetflixFeedCache cache] feedsForAccount:account];

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

  [[NetflixUserCache cache] downloadUserInformation:account];
  [self downloadFeeds:account];
  [self updateQueues:account force:force];

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
  movie = [NetflixCache promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants castKey]];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  movie = [self correspondingNetflixMovie:movie];
  movie = [NetflixCache promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants directorsKey]];
}


- (NSString*) netflixRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  movie = [self correspondingNetflixMovie:movie];
  movie = [NetflixCache promoteDiscToSeries:movie];

  NSString* rating = [FileUtilities readObject:[NetflixPaths predictedRatingsFile:movie account:account]];
  if (rating.length > 0) {
    return rating;
  }

  return [movie.additionalFields objectForKey:[NetflixConstants averageRatingKey]];
}


- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account {
  NSString* currentRating = [[NetflixUpdater updater] userRatingForMovie:movie account:account];
  if (currentRating != nil) {
    return currentRating;
  }

  movie = [self correspondingNetflixMovie:movie];
  movie = [NetflixCache promoteDiscToSeries:movie];

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

  Movie* series = [NetflixCache promoteDiscToSeries:movie];
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


- (NSString*) netflixAddressForPerson:(Person*) person {
  return person.website;
}


- (NSArray*) filmographyAddressesForPerson:(Person*) person {
  return [person.additionalFields objectForKey:[NetflixConstants filmographyKey]];
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

  movie = [NetflixCache promoteDiscToSeries:movie];
  NSDictionary* details = [self detailsForMovie:movie];
  return [Movie decodeArray:[details objectForKey:[NetflixConstants similarsKey]]];
}


- (NSString*) synopsisForMovieDetails:(Movie*) movie {
  NSDictionary* details = [self detailsForMovie:movie];
  return [details objectForKey:[NetflixConstants synopsisKey]];
}


- (NSString*) synopsisForMovieWorker:(Movie*) movie {
  NSString* discSynopsis = [self synopsisForMovieDetails:movie];
  NSString* seriesSynopsis = [self synopsisForMovieDetails:[NetflixCache seriesForDisc:movie]];

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
                           [[NetflixFeedCache cache] queueForKey:[NetflixConstants discQueueKey] account:account],
                           [[NetflixFeedCache cache] queueForKey:[NetflixConstants instantQueueKey] account:account],
                           [[NetflixFeedCache cache] queueForKey:[NetflixConstants atHomeKey] account:account],
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

  NSString* file = [NetflixPaths searchFile:movie];
  NSDictionary* dictionary = [FileUtilities readObject:file];
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
