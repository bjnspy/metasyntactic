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

#import "NetflixSearchEngine.h"

#import "SearchRequest.h"
#import "SearchResult.h"

@implementation NetflixSearchEngine

+ (NetflixSearchEngine*) engineWithDelegate:(id<SearchEngineDelegate>) delegate {
  return [[[NetflixSearchEngine alloc] initWithDelegate:delegate] autorelease];
}


- (void) searchWorker:(SearchRequest*) currentlyExecutingRequest {
  NSString* error;
  NSArray* movies = [[NetflixCache cache] movieSearch:currentlyExecutingRequest.lowercaseValue
                                              account:currentlyExecutingRequest.account
                                                error:&error];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }
  NSArray* people = [[NetflixCache cache] personSearch:currentlyExecutingRequest.lowercaseValue
                                               account:currentlyExecutingRequest.account
                                                 error:&error];
  if ([self abortEarly:currentlyExecutingRequest]) { return; }

  SearchResult* result = [SearchResult resultWithId:currentlyExecutingRequest.requestId
                                              value:currentlyExecutingRequest.value
                                             movies:movies
                                           theaters:[NSArray array]
                                     upcomingMovies:[NSArray array]
                                               dvds:[NSArray array]
                                             bluray:[NSArray array]
                                             people:people];

  [self reportResult:result];
}


- (AbstractSearchRequest*) createSearchRequest:(NSInteger) requestId
                                         value:(NSString*) value {
  return [SearchRequest requestWithId:requestId value:value];
}

@end
