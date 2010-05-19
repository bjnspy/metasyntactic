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
static NSString* netflixFilmographyDirectory = nil;

static NSString** directories[] = {
  &netflixDirectory,
  &netflixAccountsDirectory,
  &netflixSeriesDirectory,
  &netflixSearchDirectory,
  &netflixDetailsDirectory,
  &netflixRSSDirectory,
  &netflixFilmographyDirectory,
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
    netflixFilmographyDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Filmography"] retain];

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


+ (NSString*) searchFile:(Movie*) movie {
  return [[netflixSearchDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) filmographyFile:(NSString*) filmographyAddress {
  return [[netflixFilmographyDirectory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:filmographyAddress]] stringByAppendingPathExtension:@"plist"];
}

@end
