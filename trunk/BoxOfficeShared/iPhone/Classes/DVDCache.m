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

#import "DVDCache.h"

#import "Application.h"
#import "BookmarkCache.h"
#import "Model.h"

@implementation DVDCache

static DVDCache* cache;

+ (void) initialize {
  if (self == [DVDCache class]) {
    cache = [[DVDCache alloc] init];
  }
}


+ (DVDCache*) cache {
  return cache;
}


- (void) update {
  if (![Model model].dvdMoviesShowDVDs) {
    return;
  }

  [super update];
}


- (NSArray*) loadBookmarksArray {
  return [[BookmarkCache cache] bookmarkedDVD];
}


- (NSString*) serverAddress {
  return [NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings%@?q=dvd",
          [Application apiHost], [Application apiVersion]];
}


- (NSString*) directory {
  return [Application dvdDirectory];
}


- (NSString*) notificationString {
  return @"dvd";
}

@end
