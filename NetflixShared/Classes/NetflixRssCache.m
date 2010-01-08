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

#import "NetflixRssCache.h"

#import "Movie.h"
#import "NetflixCache.h"
#import "NetflixNetworking.h"
#import "NetflixPaths.h"
#import "NetflixSharedApplication.h"
#import "NetflixSiteStatus.h"
#import "NetflixUtilities.h"

@implementation NetflixRssCache

static NetflixRssCache* cache;

static NSArray* mostPopularTitles = nil;
static NSDictionary* mostPopularTitlesToAddresses = nil;
static NSDictionary* mostPopularAddressesToTitles = nil;


+ (void) initialize {
  if (self == [NetflixRssCache class]) {
    cache = [[NetflixRssCache alloc] init];

    mostPopularTitles =
    [[NSArray arrayWithObjects:
      LocalizedString(@"Top DVDs", @"Movie category"),
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
  }
}


+ (NetflixRssCache*) cache {
  return cache;
}


+ (NSArray*) mostPopularTitles {
  return mostPopularTitles;
}


- (void) update:(NetflixAccount*) account {
  [[OperationQueue operationQueue] performSelector:@selector(downloadRSS:)
                                          onTarget:self
                                        withObject:account
                                              gate:nil // no lock.
                                          priority:Priority];
}


- (BOOL) canContinue:(NetflixAccount*) account {
  return [NetflixUtilities canContinue:account];
}


- (BOOL) allFeedDirectoriesCreated {
  for (NSString* address in [mostPopularTitlesToAddresses allValues]) {
    if (![FileUtilities fileExists:[NetflixPaths rssFeedDirectory:address]]) {
      return NO;
    }
  }
  
  return YES;
}


- (void) downloadRSS:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSLog(@"NetflixCache:downloadRSS");

  NSArray* titles = mostPopularTitles;
  
  // Until we've downloaded all the feeds at least once, start with the most 
  // important feeds.
  if ([self allFeedDirectoriesCreated]) {
    titles = [mostPopularTitles shuffledArray];
  }
  
  for (NSString* key in titles) {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:key];
    [FileUtilities createDirectory:[NetflixPaths rssFeedDirectory:address]];

    [[OperationQueue operationQueue] performSelector:@selector(downloadRSSFeed:account:)
                                            onTarget:self
                                          withObject:address
                                          withObject:account
                                                gate:nil
                                            priority:Priority];
  }
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
  NSString* file = [NetflixPaths rssFile:address];
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

  NSString* file = [NetflixPaths rssFile:address];
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


- (Movie*) downloadMovieWithAddress:(NSString*) address
                            account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSURLRequest* request = [NetflixNetworking createGetURLRequest:address account:account];

  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request];

  [[NetflixSiteStatus status] checkApiResult:element];

  return [NetflixUtilities processMovieItem:element saved:NULL];
}


- (Movie*) downloadRSSMovieWithIdentifier:(NSString*) identifier
                                  account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/movies/%@?expand=synopsis,cast,directors,formats", identifier];
  return [self downloadMovieWithAddress:address account:account];
}


- (Movie*) downloadRSSMovieWithSeriesIdentifier:(NSString*) identifier
                                        account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return nil; }

  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/catalog/titles/series/%@?expand=synopsis,cast,directors,formats", identifier];
  return [self downloadMovieWithAddress:address account:account];
}


- (void) downloadRSSMovie:(NSString*) identifier
                  address:(NSString*) address
                  account:(NetflixAccount*) account {
  if (![self canContinue:account]) { return; }

  NSString* file = [NetflixPaths rssMovieFile:identifier address:address];

  Movie* movie;
  if ([FileUtilities fileExists:file]) {
    movie = [Movie createWithDictionary:[FileUtilities readObject:file]];
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


- (NSInteger) movieCountForRSSTitle:(NSString*) title {
  NSString* address = [mostPopularTitlesToAddresses objectForKey:title];

  NSString* directory = [NetflixPaths rssFeedDirectory:address];
  NSArray* paths = [FileUtilities directoryContentsNames:directory];

  return paths.count;
}


- (NSArray*) moviesForRSSTitle:(NSString*) title {
  NSMutableArray* array = [NSMutableArray array];

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  {
    NSString* address = [mostPopularTitlesToAddresses objectForKey:title];

    NSString* directory = [NetflixPaths rssFeedDirectory:address];
    NSArray* paths = [FileUtilities directoryContentsPaths:directory];

    for (NSString* path in paths) {
      NSDictionary* dictionary = [FileUtilities readObject:path];

      Movie* movie = [Movie createWithDictionary:dictionary];
      if (movie != nil) {
        [array addObject:movie];
      }
    }
  }
  [pool release];

  return array;
}

@end
