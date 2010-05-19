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

#import "PersonPosterCache.h"

#import "Application.h"
#import "WikipediaApiPersonPosterDownloader.h"
#import "WikipediaCache.h"
#import "WikipediaScrapePersonPosterDownloader.h"

@interface PersonPosterCache()
@property (retain) WikipediaApiPersonPosterDownloader* apiDownloader;
@property (retain)WikipediaScrapePersonPosterDownloader* scrapeDownloader;
@end


@implementation PersonPosterCache

static PersonPosterCache* cache;

+ (void) initialize {
  if (self == [PersonPosterCache class]) {
    cache = [[PersonPosterCache alloc] init];
  }
}

@synthesize apiDownloader;
@synthesize scrapeDownloader;


- (void) dealloc {
  self.apiDownloader = nil;
  self.scrapeDownloader = nil;

  [super dealloc];
}


+ (PersonPosterCache*) cache {
  return cache;
}


- (id) init {
  if ((self = [super init])) {
    self.apiDownloader = [[[WikipediaApiPersonPosterDownloader alloc] init] autorelease];
    self.scrapeDownloader = [[[WikipediaScrapePersonPosterDownloader alloc] init] autorelease];
  }
  return self;
}


- (void) updatePersonDetails:(Person*) person force:(BOOL) force {
  [self updateObjectDetails:person force:force];
}


- (NSString*) sentinelPath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[Application sentinelsPeoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle];
}


- (NSString*) posterFilePath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Person*) person {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:person.identifier];
  return [[[Application peoplePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingString:@"-small.png"];
}


- (NSData*) pickBestImage:(NSArray*) imageAddresses {
  NSData* fallback = nil;

  // First, try to find a portrait.
  for (NSString* imageAddress in imageAddresses) {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:imageAddress];
    UIImage* image = [UIImage imageWithData:data];
    if (image.size.height >= 140) {
      if (image.size.height > image.size.width) {
        return data;
      } else if (fallback != nil) {
        fallback = data;
      }
    }
  }

  // Or fallback to anything that's large enough.
  return fallback;
}


- (NSString*) getWikipediaAddress:(Person*) person {
  NSString* result = [[WikipediaCache cache] addressForPerson:person];
  if (result.length > 0) {
    return result;
  }
  [[WikipediaCache cache] updatePersonDetails:person force:YES];
  return [[WikipediaCache cache] addressForPerson:person];
}


- (NSData*) downloadPoster:(Person*) person {
  NSData* data = nil;

  data = [apiDownloader download:person];
  if (data != nil) {
    return data;
  }

  data = [scrapeDownloader download:person];
  if (data != nil) {
    return data;
  }

  // if we had a network connection, then it means we don't know of any
  // posters for this movie.  record that fact and try again another time
  if ([NetworkUtilities isNetworkAvailable]) {
    return [NSData data];
  }

  return nil;
}


- (UIImage*) posterForPerson:(Person*) person
                loadFromDisk:(BOOL) loadFromDisk {
  return [self posterForObject:person loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForPerson:(Person*) person
                     loadFromDisk:(BOOL) loadFromDisk {
  return [self smallPosterForObject:person loadFromDisk:loadFromDisk];
}

@end
