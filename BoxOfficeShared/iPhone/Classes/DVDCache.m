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


- (BookmarkCache*) bookmarkCache {
  return [BookmarkCache cache];
}


- (void) update {
  if (![Model model].dvdMoviesShowDVDs) {
    return;
  }

  [super update];
}


- (NSArray*) loadBookmarksArray {
  return [self.bookmarkCache bookmarkedDVD];
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
