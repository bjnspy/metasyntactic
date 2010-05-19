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

#import "IMDbCache.h"

#import "Application.h"

@implementation IMDbCache

static IMDbCache* cache;

+ (void) initialize {
  if (self == [IMDbCache class]) {
    cache = [[IMDbCache alloc] init];
  }
}


+ (IMDbCache*) cache {
  return cache;
}


- (NSString*) cacheDirectory {
  return [Application imdbDirectory];
}


- (NSString*) serverUrl:(NSString*) name {
  return [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings%@?q=%@",
          [Application apiHost], [Application apiVersion],
          [StringUtilities stringByAddingPercentEscapes:name]];
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
  if (movie.imdbAddress.length > 0) {
    // don't even bother if the movie has an imdb address in it
    return;
  }
  [super updateMovieDetails:movie force:force];
}

@end
