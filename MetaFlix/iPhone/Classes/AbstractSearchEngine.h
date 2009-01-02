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

@interface AbstractSearchEngine : NSObject {
@protected
    // only accessed from the main thread.  needs no lock.
    MetaFlixModel* model;
    id<SearchEngineDelegate> delegate;

    // accessed from both threads.  needs lock
    NSInteger currentRequestId;
    SearchRequest* nextSearchRequest;

    // only accessed from the background thread.  needs no lock
    SearchRequest* currentlyExecutingRequest;

    NSCondition* gate;
}

- (void) submitRequest:(NSString*) string;

- (void) invalidateExistingRequests;

/* @protected */
- (id) initWithModel:(MetaFlixModel*) model
            delegate:(id<SearchEngineDelegate>) delegate;

- (BOOL) abortEarly;

- (void) reportMovies:(NSArray*) movies;

@end