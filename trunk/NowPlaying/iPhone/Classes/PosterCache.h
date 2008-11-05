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

@interface PosterCache : NSObject {
    NSLock* updateGate;
    NowPlayingModel* model;

    LinkedSet* prioritizedMovies;

    NSDictionary* largePosterIndexData;
    NSLock* largePosterGate;
}

@property (retain) NSLock* updateGate;
@property (retain) NowPlayingModel* model;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSDictionary* largePosterIndexData;
@property (retain) NSLock* largePosterGate;

+ (PosterCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) update:(NSArray*) movies;

- (UIImage*) smallPosterForMovie:(Movie*) movie;
- (UIImage*) largePosterForMovie:(Movie*) movie;

- (void) prioritizeMovie:(Movie*) movie;
- (void) downloadLargePosterForMovie:(Movie*) movie;

@end