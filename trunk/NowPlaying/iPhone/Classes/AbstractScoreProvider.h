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

#import "ScoreProvider.h"
#import "AbstractCache.h"

@interface AbstractScoreProvider : AbstractCache<ScoreProvider> {
@private
    // Mapping from score title to score.
    NSDictionary* scoresData;
    NSString* hashData;

    NSLock* movieMapLock;
    NSArray* movies;

    // Mapping from google movie title to score provider title
    NSDictionary* movieMapData;

    NSString* providerDirectory;
    NSString* reviewsDirectory;

    LinkedSet* prioritizedMovies;
}

- (id) initWithModel:(NowPlayingModel*) model;

@end