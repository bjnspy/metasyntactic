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

#import "Application.h"

@implementation Application

// Application storage directories
static NSString* dataDirectory = nil;
static NSString* imdbDirectory = nil;
static NSString* amazonDirectory = nil;
static NSString* wikipediaDirectory = nil;
static NSString* metacriticDirectory = nil;
static NSString* rottenTomatoesDirectory = nil;
static NSString* userLocationsDirectory = nil;
static NSString* scoresDirectory = nil;
static NSString* reviewsDirectory = nil;
static NSString* localizableStringsDirectory = nil;

static NSString* trailersDirectory = nil;
static NSString* trailersMoviesDirectory = nil;

static NSString* postersDirectory = nil;
static NSString* moviesPostersDirectory = nil;
static NSString* sentinelsMoviesPostersDirectory = nil;
static NSString* largeMoviesPostersDirectory = nil;
static NSString* largeMoviesPostersIndexDirectory = nil;

static NSString* sentinelsPeoplePostersDirectory = nil;
static NSString* peoplePostersDirectory = nil;
static NSString* largePeoplePostersDirectory = nil;

static NSString* dvdDirectory = nil;
static NSString* dvdDetailsDirectory = nil;

static NSString* blurayDirectory = nil;
static NSString* blurayDetailsDirectory = nil;

static NSString* upcomingDirectory = nil;
static NSString* upcomingCastDirectory = nil;
static NSString* upcomingSynopsesDirectory = nil;
static NSString* upcomingTrailersDirectory = nil;

static NSString* internationalDirectory = nil;
static NSString* helpDirectory = nil;

+ (void) initializeDirectories {
  NSString* cacheDirectory = [self cacheDirectory];

  [self addDirectory:dataDirectory = [cacheDirectory stringByAppendingPathComponent:@"Data"]];
  [self addDirectory:imdbDirectory = [cacheDirectory stringByAppendingPathComponent:@"IMDb"]];
  [self addDirectory:amazonDirectory = [cacheDirectory stringByAppendingPathComponent:@"Amazon"]];
  [self addDirectory:wikipediaDirectory = [cacheDirectory stringByAppendingPathComponent:@"Wikipedia"]];
  [self addDirectory:metacriticDirectory = [cacheDirectory stringByAppendingPathComponent:@"Metacritic"]];
  [self addDirectory:rottenTomatoesDirectory = [cacheDirectory stringByAppendingPathComponent:@"RottenTomatoes"]];
  [self addDirectory:userLocationsDirectory = [cacheDirectory stringByAppendingPathComponent:@"UserLocations"]];
  [self addDirectory:scoresDirectory = [cacheDirectory stringByAppendingPathComponent:@"Scores"]];
  [self addDirectory:reviewsDirectory = [cacheDirectory stringByAppendingPathComponent:@"Reviews"]];
  [self addDirectory:localizableStringsDirectory = [cacheDirectory stringByAppendingPathComponent:@"LocalizableStrings"]];

  [self addDirectory:trailersDirectory = [cacheDirectory stringByAppendingPathComponent:@"Trailers"]];
  [self addDirectory:trailersMoviesDirectory = [trailersDirectory stringByAppendingPathComponent:@"Movies"]];

  [self addDirectory:postersDirectory = [cacheDirectory stringByAppendingPathComponent:@"Posters"]];
  [self addDirectory:moviesPostersDirectory = [postersDirectory stringByAppendingPathComponent:@"Movies"]];
  [self addDirectory:sentinelsMoviesPostersDirectory = [moviesPostersDirectory stringByAppendingPathComponent:@"Sentinels"]];
  [self addDirectory:largeMoviesPostersDirectory = [moviesPostersDirectory stringByAppendingPathComponent:@"Large"]];
  [self addDirectory:largeMoviesPostersIndexDirectory = [largeMoviesPostersDirectory stringByAppendingPathComponent:@"Index"]];

  [self addDirectory:peoplePostersDirectory = [postersDirectory stringByAppendingPathComponent:@"People"]];
  [self addDirectory:sentinelsPeoplePostersDirectory = [peoplePostersDirectory stringByAppendingPathComponent:@"Sentinels"]];
  [self addDirectory:largePeoplePostersDirectory = [peoplePostersDirectory stringByAppendingPathComponent:@"Large"]];

  [self addDirectory:dvdDirectory = [cacheDirectory stringByAppendingPathComponent:@"DVD"]];
  [self addDirectory:dvdDetailsDirectory = [dvdDirectory stringByAppendingPathComponent:@"Details"]];

  [self addDirectory:blurayDirectory = [cacheDirectory stringByAppendingPathComponent:@"Bluray"]];
  [self addDirectory:blurayDetailsDirectory = [blurayDirectory stringByAppendingPathComponent:@"Details"]];

  [self addDirectory:upcomingDirectory = [cacheDirectory stringByAppendingPathComponent:@"Upcoming"]];
  [self addDirectory:upcomingCastDirectory = [upcomingDirectory stringByAppendingPathComponent:@"Cast"]];
  [self addDirectory:upcomingSynopsesDirectory = [upcomingDirectory stringByAppendingPathComponent:@"Synopses"]];
  [self addDirectory:upcomingTrailersDirectory = [upcomingDirectory stringByAppendingPathComponent:@"Trailers"]];

  [self addDirectory:internationalDirectory = [cacheDirectory stringByAppendingPathComponent:@"International"]];

  [self addDirectory:helpDirectory = [cacheDirectory stringByAppendingPathComponent:@"Help"]];

  [self createDirectories];
}


+ (void) initialize {
  if (self == [Application class]) {
    [self initializeDirectories];
  }
}


+ (NSArray*) directoriesToKeep {
  return [NSArray arrayWithObjects:
          userLocationsDirectory, nil];
}


+ (NSString*) dataDirectory {
  return dataDirectory;
}


+ (NSString*) imdbDirectory {
  return imdbDirectory;
}


+ (NSString*) amazonDirectory {
  return amazonDirectory;
}


+ (NSString*) wikipediaDirectory {
  return wikipediaDirectory;
}


+ (NSString*) metacriticDirectory {
  return metacriticDirectory;
}


+ (NSString*) rottenTomatoesDirectory {
  return rottenTomatoesDirectory;
}


+ (NSString*) userLocationsDirectory {
  return userLocationsDirectory;
}


+ (NSString*) moviesPostersDirectory {
  return moviesPostersDirectory;
}


+ (NSString*) sentinelsMoviesPostersDirectory {
  return sentinelsMoviesPostersDirectory;
}


+ (NSString*) largeMoviesPostersDirectory {
  return largeMoviesPostersDirectory;
}


+ (NSString*) largeMoviesPostersIndexDirectory {
  return largeMoviesPostersIndexDirectory;
}


+ (NSString*) peoplePostersDirectory {
  return peoplePostersDirectory;
}


+ (NSString*) sentinelsPeoplePostersDirectory {
  return sentinelsPeoplePostersDirectory;
}


+ (NSString*) largePeoplePostersDirectory {
  return largePeoplePostersDirectory;
}


+ (NSString*) scoresDirectory {
  return scoresDirectory;
}


+ (NSString*) reviewsDirectory {
  return reviewsDirectory;
}


+ (NSString*) localizableStringsDirectory {
  return localizableStringsDirectory;
}


+ (NSString*) trailersDirectory {
  return trailersDirectory;
}


+ (NSString*) trailersMoviesDirectory {
  return trailersMoviesDirectory;
}


+ (NSString*) dvdDirectory {
  return dvdDirectory;
}


+ (NSString*) dvdDetailsDirectory {
  return dvdDetailsDirectory;
}


+ (NSString*) blurayDirectory {
  return blurayDirectory;
}


+ (NSString*) blurayDetailsDirectory {
  return blurayDetailsDirectory;
}


+ (NSString*) upcomingDirectory {
  return upcomingDirectory;
}


+ (NSString*) upcomingCastDirectory {
  return upcomingCastDirectory;
}


+ (NSString*) upcomingSynopsesDirectory {
  return upcomingSynopsesDirectory;
}


+ (NSString*) upcomingTrailersDirectory {
  return upcomingTrailersDirectory;
}


+ (NSString*) internationalDirectory {
  return internationalDirectory;
}


+ (NSString*) helpDirectory {
  return helpDirectory;
}


+ (NSString*) apiHost {
#if TARGET_IPHONE_SIMULATOR
  /*
   return @"metaboxoffice6";
   /*/
  return @"metaboxoffice2";
  //*/
#else
  return @"metaboxoffice2";
#endif
}


+ (NSString*) apiVersion {
  return @"3";
}

@end
