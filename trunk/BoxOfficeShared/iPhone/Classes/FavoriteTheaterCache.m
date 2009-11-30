//
//  FavoriteTheaterCache.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
