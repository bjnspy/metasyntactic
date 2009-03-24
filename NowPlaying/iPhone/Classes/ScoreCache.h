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

#import "AbstractCache.h"

@interface ScoreCache : AbstractCache {
@private
    id<ScoreProvider> rottenTomatoesScoreProvider_;
    id<ScoreProvider> metacriticScoreProvider_;
    id<ScoreProvider> googleScoreProvider_;
    id<ScoreProvider> noneScoreProvider_;

    BOOL updated_;
}

+ (ScoreCache*) cache;

- (void) update;
- (Score*) scoreForMovie:(Movie*) movie inMovies:(NSArray*) movies;
- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie inMovies:(NSArray*) movies;
- (Score*) metacriticScoreForMovie:(Movie*) movie inMovies:(NSArray*) movies;
- (NSArray*) reviewsForMovie:(Movie*) movie inMovies:(NSArray*) movies;

- (void) prioritizeMovie:(Movie*) movie inMovies:(NSArray*) movies;

@end