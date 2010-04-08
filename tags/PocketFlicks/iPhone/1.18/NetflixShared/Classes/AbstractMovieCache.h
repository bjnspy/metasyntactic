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

@interface AbstractMovieCache : AbstractCache {
@protected
  // Accessed from different threads.  needs gate.
  NSMutableSet* updatedMovies;
  NSMutableSet* updatedPeople;
}

- (void) processMovie:(Movie*) movie force:(BOOL) force;
- (void) processPerson:(Person*) person force:(BOOL) force;

- (void) clearUpdatedMovies;
- (void) clearUpdatedPeople;

@end
