//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "ScoreCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "GoogleScoreProvider.h"
#import "MetacriticScoreProvider.h"
#import "Score.h"
#import "NoneScoreProvider.h"
#import "NowPlayingModel.h"
#import "RottenTomatoesScoreProvider.h"

@implementation ScoreCache

@synthesize model;
@synthesize rottenTomatoesScoreProvider;
@synthesize metacriticScoreProvider;
@synthesize googleScoreProvider;
@synthesize noneScoreProvider;

- (void) dealloc {
    self.model = nil;
    self.rottenTomatoesScoreProvider = nil;
    self.metacriticScoreProvider = nil;
    self.googleScoreProvider = nil;
    self.noneScoreProvider = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        
        self.rottenTomatoesScoreProvider = [RottenTomatoesScoreProvider providerWithCache:self];
        self.metacriticScoreProvider = [MetacriticScoreProvider providerWithCache:self];
        self.googleScoreProvider = [GoogleScoreProvider providerWithCache:self];
        self.noneScoreProvider = [NoneScoreProvider providerWithCache:self];
    }
    
    return self;
}


+ (ScoreCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[ScoreCache alloc] initWithModel:model] autorelease];
}


- (id<ScoreProvider>) currentScoreProvider {
    if (model.rottenTomatoesScores) {
        return rottenTomatoesScoreProvider;
    } else if (model.metacriticScores) {
        return metacriticScoreProvider;
    } else if (model.googleScores) {
        return googleScoreProvider;
    } else if (model.noScores) {
        return noneScoreProvider;
    } else {
        return nil;
    }
}


- (Score*) scoreForMovie:(Movie*) movie inMovies:(NSArray*) movies {
    return [self.currentScoreProvider scoreForMovie:movie inMovies:movies];
}


- (NSArray*) reviewsForMovie:(Movie*) movie inMovies:(NSArray*) movies {
    return [self.currentScoreProvider reviewsForMovie:movie inMovies:movies];
}
 
 
- (void) update {
    [self.currentScoreProvider update];
}

@end