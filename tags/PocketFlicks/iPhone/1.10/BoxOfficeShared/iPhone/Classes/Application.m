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

#import "Application.h"

@implementation Application

// Application storage directories
static NSString* dataDirectory = nil;
static NSString* imdbDirectory = nil;
static NSString* amazonDirectory = nil;
static NSString* wikipediaDirectory = nil;
static NSString* userLocationsDirectory = nil;
static NSString* scoresDirectory = nil;
static NSString* reviewsDirectory = nil;
static NSString* trailersDirectory = nil;
static NSString* localizableStringsDirectory = nil;

static NSString* postersDirectory = nil;
static NSString* moviesPostersDirectory = nil;
static NSString* largeMoviesPostersDirectory = nil;
static NSString* largeMoviesPostersIndexDirectory = nil;
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

static NSString** directories[] = {
&dataDirectory,
&imdbDirectory,
&amazonDirectory,
&wikipediaDirectory,
&userLocationsDirectory,
&dvdDirectory,
&dvdDetailsDirectory,
&blurayDirectory,
&blurayDetailsDirectory,
&helpDirectory,
&internationalDirectory,
&localizableStringsDirectory,
&scoresDirectory,
&reviewsDirectory,
&trailersDirectory,
&postersDirectory,
&moviesPostersDirectory,
&largeMoviesPostersDirectory,
&largeMoviesPostersIndexDirectory,
&peoplePostersDirectory,
&largePeoplePostersDirectory,
&upcomingDirectory,
&upcomingCastDirectory,
&upcomingSynopsesDirectory,
&upcomingTrailersDirectory,
};


+ (void) createDirectories {
  [[self gate] lock];
  {
    for (int i = 0; i < ArrayLength(directories); i++) {
      NSString* directory = *directories[i];

      [FileUtilities createDirectory:directory];
    }
  }
  [[self gate] unlock];
}


+ (void) initializeDirectories {
  {
    NSString* cacheDirectory = [self cacheDirectory];
    dataDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Data"] retain];
    imdbDirectory = [[cacheDirectory stringByAppendingPathComponent:@"IMDb"] retain];
    amazonDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Amazon"] retain];
    wikipediaDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Wikipedia"] retain];
    userLocationsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"UserLocations"] retain];
    scoresDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Scores"] retain];
    reviewsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Reviews"] retain];
    trailersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Trailers"] retain];
    localizableStringsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"LocalizableStrings"] retain];

    postersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Posters"] retain];
    moviesPostersDirectory = [[postersDirectory stringByAppendingPathComponent:@"Movies"] retain];
    largeMoviesPostersDirectory = [[moviesPostersDirectory stringByAppendingPathComponent:@"Large"] retain];
    largeMoviesPostersIndexDirectory = [[largeMoviesPostersDirectory stringByAppendingPathComponent:@"Index"] retain];
    peoplePostersDirectory = [[postersDirectory stringByAppendingPathComponent:@"People"] retain];
    largePeoplePostersDirectory = [[peoplePostersDirectory stringByAppendingPathComponent:@"Large"] retain];

    dvdDirectory = [[cacheDirectory stringByAppendingPathComponent:@"DVD"] retain];
    dvdDetailsDirectory = [[dvdDirectory stringByAppendingPathComponent:@"Details"] retain];

    blurayDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Bluray"] retain];
    blurayDetailsDirectory = [[blurayDirectory stringByAppendingPathComponent:@"Details"] retain];

    upcomingDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Upcoming"] retain];
    upcomingCastDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Cast"] retain];
    upcomingSynopsesDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Synopses"] retain];
    upcomingTrailersDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Trailers"] retain];

    internationalDirectory = [[cacheDirectory stringByAppendingPathComponent:@"International"] retain];

    helpDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Help"] retain];

    [self createDirectories];
  }
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


+ (NSString*) userLocationsDirectory {
  return userLocationsDirectory;
}


+ (NSString*) moviesPostersDirectory {
  return moviesPostersDirectory;
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
