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

#import "NetflixPaths.h"

#import "Feed.h"
#import "Movie.h"
#import "NetflixAccount.h"

@implementation NetflixPaths

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
  for (NSInteger i = 0; i < ArrayLength(directories); i++) {
    NSString* directory = *directories[i];

    [FileUtilities createDirectory:directory];
  }
}


+ (void) initialize {
  if (self == [NetflixPaths class]) {
    netflixDirectory = [[[AbstractApplication cacheDirectory] stringByAppendingPathComponent:@"Netflix"] retain];
    netflixAccountsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Accounts"] retain];
    netflixSeriesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Series"] retain];
    netflixDetailsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Details"] retain];
    netflixSearchDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Search"] retain];
    netflixRSSDirectory = [[netflixDirectory stringByAppendingPathComponent:@"RSS"] retain];

    [self createDirectories];
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


+ (NSString*) queueFile:(Feed*) feed account:(NetflixAccount*) account {
  return [[[self accountDirectory:account] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:feed.key]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) queueEtagFile:(Feed*) feed account:(NetflixAccount*) account {
  NSString* name = [NSString stringWithFormat:@"%@-etag", feed.key];
  return [[[self accountDirectory:account] stringByAppendingPathComponent:
           [FileUtilities sanitizeFileName:name]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) userFile:(NetflixAccount*) account {
  return [[self accountDirectory:account] stringByAppendingPathComponent:@"User.plist"];
}


+ (NSString*) seriesFile:(NSString*) seriesKey {
  return
  [[netflixSeriesDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:seriesKey]]
   stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) userRatingsFile:(Movie*) movie account:(NetflixAccount*) account {
  return [[[self userRatingsDirectory:account] stringByAppendingPathComponent:
           [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier]]
          stringByAppendingPathExtension:@"plist"];

}


+ (NSString*) predictedRatingsFile:(Movie*) movie account:(NetflixAccount*) account {
  return [[[self predictedRatingsDirectory:account] stringByAppendingPathComponent:
           [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) detailsFile:(Movie*) movie {
  return [[netflixDetailsDirectory stringByAppendingPathComponent:
           [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) rssFeedDirectory:(NSString*) address {
  return [netflixRSSDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]];
}


+ (NSString*) rssFile:(NSString*) address {
  return [[netflixRSSDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]] stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) rssMovieFile:(NSString*) identifier address:(NSString*) address {
  return [[[self rssFeedDirectory:address]
           stringByAppendingPathComponent:[FileUtilities sanitizeFileName:identifier]]
          stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) netflixSearchFile:(Movie*) movie {
  return [[netflixSearchDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}

@end
