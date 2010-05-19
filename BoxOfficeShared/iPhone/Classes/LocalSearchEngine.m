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

#import "LocalSearchEngine.h"

#import "Model.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"

@implementation LocalSearchEngine

+ (LocalSearchEngine*) engineWithDelegate:(id<SearchEngineDelegate>) delegate {
  return [[[LocalSearchEngine alloc] initWithDelegate:delegate] autorelease];
}


- (BOOL) arrayMatches:(NSArray*) array
              request:(SearchRequest*) currentlyExecutingRequest {
  for (NSString* text in array) {
    if ([self abortEarly:currentlyExecutingRequest]) {
      return NO;
    }

    NSString* lowercaseText = [[StringUtilities asciiString:text] lowercaseString];

    NSRange range = [lowercaseText rangeOfString:currentlyExecutingRequest.lowercaseValue];
    if (range.length > 0) {
      if (range.location > 0) {
        // make sure it's matching the start of a word
        unichar c = [lowercaseText characterAtIndex:range.location - 1];
        if (isalnum(c)) {
          continue;
        }
      }

      return YES;
    }
  }

  return NO;
}


- (BOOL) movieMatches:(Movie*) movie
              request:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* array = [NSMutableArray array];
  [array addObject:movie.canonicalTitle];
  [array addObjectsFromArray:movie.directors];
  [array addObjectsFromArray:[[Model model] castForMovie:movie]];
  [array addObjectsFromArray:movie.genres];
  return [self arrayMatches:array request:currentlyExecutingRequest];
}


- (BOOL) theaterMatches:(Theater*) theater
                request:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* array = [NSMutableArray array];
  [array addObject:theater.name];
  [array addObject:theater.location.address];
  return [self arrayMatches:array request:currentlyExecutingRequest];
}


- (NSArray*) findMovies:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* result = [NSMutableArray array];
  for (Movie* movie in currentlyExecutingRequest.movies) {
    if ([self movieMatches:movie request:currentlyExecutingRequest]) {
      [result addObject:movie];
    }
  }
  [result sortUsingFunction:compareMoviesByTitle context:nil];
  return result;
}


- (NSArray*) findTheaters:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* result = [NSMutableArray array];
  for (Theater* theater in currentlyExecutingRequest.theaters) {
    if ([self theaterMatches:theater request:currentlyExecutingRequest]) {
      [result addObject:theater];
    }
  }
  [result sortUsingFunction:compareTheatersByName context:nil];
  return result;
}


- (NSArray*) findUpcomingMovies:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* result = [NSMutableArray array];
  for (Movie* movie in currentlyExecutingRequest.upcomingMovies) {
    if ([self movieMatches:movie request:currentlyExecutingRequest]) {
      [result addObject:movie];
    }
  }
  [result sortUsingFunction:compareMoviesByTitle context:nil];
  return result;
}


- (NSArray*) findDVDs:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* result = [NSMutableArray array];
  for (Movie* movie in currentlyExecutingRequest.dvds) {
    if ([self movieMatches:movie request:currentlyExecutingRequest]) {
      [result addObject:movie];
    }
  }
  [result sortUsingFunction:compareMoviesByTitle context:nil];
  return result;
}


- (NSArray*) findBluray:(SearchRequest*) currentlyExecutingRequest {
  NSMutableArray* result = [NSMutableArray array];
  for (Movie* movie in currentlyExecutingRequest.bluray) {
    if ([self movieMatches:movie request:currentlyExecutingRequest]) {
      [result addObject:movie];
    }
  }
  [result sortUsingFunction:compareMoviesByTitle context:nil];
  return result;
}


- (void) searchWorker:(SearchRequest*) currentlyExecutingRequest {
  NSArray* movies = [self findMovies:currentlyExecutingRequest];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }

  NSArray* theaters = [self findTheaters:currentlyExecutingRequest];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }

  NSArray* upcomingMovies = [self findUpcomingMovies:currentlyExecutingRequest];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }

  NSArray* dvds = [self findDVDs:currentlyExecutingRequest];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }

  NSArray* bluray = [self findBluray:currentlyExecutingRequest];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }
  //...

  SearchResult* result = [SearchResult resultWithId:currentlyExecutingRequest.requestId
                                              value:currentlyExecutingRequest.value
                                             movies:movies
                                           theaters:theaters
                                     upcomingMovies:upcomingMovies
                                               dvds:dvds
                                             bluray:bluray
                                             people:[NSArray array]];
  [self reportResult:result];
}


- (AbstractSearchRequest*) createSearchRequest:(NSInteger) requestId
                                         value:(NSString*) value {
  return [SearchRequest requestWithId:requestId value:value];
}

@end
