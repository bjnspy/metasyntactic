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

#import "FavoriteTheaterCache.h"

#import "FavoriteTheater.h"
#import "Theater.h"

@interface FavoriteTheaterCache()
@property (retain) ThreadsafeValue*/*NSDictionary*/ favoriteTheatersData;
@end

@implementation FavoriteTheaterCache

static FavoriteTheaterCache* cache;

static NSString* FAVORITE_THEATERS = @"favoriteTheaters";

+ (void) initialize {
  if (self == [FavoriteTheaterCache class]) {
    cache = [[FavoriteTheaterCache alloc] init];
  }
}


+ (FavoriteTheaterCache*) cache {
  return cache;
}

@synthesize favoriteTheatersData;

- (void) dealloc {
  self.favoriteTheatersData = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.favoriteTheatersData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadFavoriteTheaters) saveSelector:@selector(saveFavoriteTheaters:)];
  }
  return self;
}


- (NSDictionary*) loadFavoriteTheaters {
  NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITE_THEATERS];
  if (array.count == 0) {
    return [NSDictionary dictionary];
  }

  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  for (NSDictionary* dictionary in array) {
    FavoriteTheater* theater = [FavoriteTheater createWithDictionary:dictionary];
    [result setObject:theater forKey:theater.name];
  }

  return result;
}


- (void) saveFavoriteTheaters:(NSDictionary*) favoriteTheaters {
  [[NSUserDefaults standardUserDefaults] setObject:[FavoriteTheater encodeArray:favoriteTheaters.allValues]
                                            forKey:FAVORITE_THEATERS];
}


- (NSDictionary*) favoriteTheaters {
  return favoriteTheatersData.value;
}


- (NSArray*) favoriteTheatersArray {
  return self.favoriteTheaters.allValues;
}


- (void) addFavoriteTheater:(Theater*) theater {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTheaters];

  FavoriteTheater* favoriteTheater = [FavoriteTheater theaterWithName:theater.name
                                                  originatingLocation:theater.originatingLocation];

  [dictionary setObject:favoriteTheater forKey:theater.name];
  favoriteTheatersData.value = dictionary;
}


- (BOOL) isFavoriteTheater:(Theater*) theater {
  return [self.favoriteTheaters objectForKey:theater.name] != nil;
}


- (void) removeFavoriteTheater:(Theater*) theater {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTheaters];
  [dictionary removeObjectForKey:theater.name];

  favoriteTheatersData.value = dictionary;
}

@end
