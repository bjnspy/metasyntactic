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

#import "SearchEngineDelegate.h"

@interface AbstractSearchEngine : NSObject {
@private
  // only accessed from the main thread.  needs no lock.
  id<SearchEngineDelegate> delegate;

  // only accessed from background thread.  needs no lock.
  NSTimeInterval lastSearchTime;

  // accessed from both threads.  needs lock
  NSCondition* gate;
  NSInteger currentRequestId;
  AbstractSearchRequest* nextSearchRequest;
}

- (void) submitRequest:(NSString*) string;

- (void) invalidateExistingRequests;

/* @protected */
- (id) initWithDelegate:(id<SearchEngineDelegate>) delegate;

- (BOOL) abortEarly:(AbstractSearchRequest*) currentlyExecutingRequest;

- (void) reportResult:(AbstractSearchResult*) result;

@end
