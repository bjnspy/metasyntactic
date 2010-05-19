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

#import "BlurayCache.h"

#import "Application.h"
#import "BookmarkCache.h"
#import "Model.h"

@implementation BlurayCache

static BlurayCache* cache;

+ (void) initialize {
  if (self == [BlurayCache class]) {
    cache = [[BlurayCache alloc] init];
  }
}


+ (BlurayCache*) cache {
  return cache;
}


- (void) update {
  if (![Model model].dvdMoviesShowBluray) {
    return;
  }

  [super update];
}


- (NSArray*) loadBookmarksArray {
  return [[BookmarkCache cache] bookmarkedBluray];
}


- (NSString*) serverAddress {
  return [NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings%@?q=bluray",
          [Application apiHost], [Application apiVersion]];
}


- (NSString*) directory {
  return [Application blurayDirectory];
}


- (NSString*) notificationString {
  return @"bluray";
}

@end
