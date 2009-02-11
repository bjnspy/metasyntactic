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

#import "ScoreCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "GoogleScoreProvider.h"
#import "MetacriticScoreProvider.h"
#import "NoneScoreProvider.h"
#import "Model.h"
#import "RottenTomatoesScoreProvider.h"
#import "Score.h"
#import "ScoreProvider.h"
#import "ThreadingUtilities.h"

@interface ScoreCache()
@property (retain) id<ScoreProvider> rottenTomatoesScoreProvider;
@property (retain) id<ScoreProvider> metacriticScoreProvider;
@property (retain) id<ScoreProvider> googleScoreProvider;
@property (retain) id<ScoreProvider> noneScoreProvider;
@end

@implementation ScoreCache

@synthesize rottenTomatoesScoreProvider;
@synthesize metacriticScoreProvider;
@synthesize googleScoreProvider;
@synthesize noneScoreProvider;

- (void) dealloc {
    self.rottenTomatoesScoreProvider = nil;
    self.metacriticScoreProvider = nil;
    self.googleScoreProvider = nil;
    self.noneScoreProvider = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.rottenTomatoesScoreProvider = [RottenTomatoesScoreProvider providerWithModel:model];
        self.metacriticScoreProvider = [MetacriticScoreProvider providerWithModel:model];
        self.googleScoreProvider = [GoogleScoreProvider providerWithModel:model];
        self.noneScoreProvider = [NoneScoreProvider providerWithModel:model];
    }

    return self;
}


+ (ScoreCache*) cacheWithModel:(Model*) model {
    return [[[ScoreCache alloc] initWithModel:model] autorelease];
}


- (NSArray*) scoreProviders {
    return [NSArray arrayWithObjects:
            rottenTomatoesScoreProvider,
            metacriticScoreProvider,
            googleScoreProvider,
            noneScoreProvider, nil];
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


- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie inMovies:(NSArray*) movies {
    return [rottenTomatoesScoreProvider scoreForMovie:movie inMovies:movies];
}


- (Score*) metacriticScoreForMovie:(Movie*) movie inMovies:(NSArray*) movies {
    return [metacriticScoreProvider scoreForMovie:movie inMovies:movies];
}


- (NSArray*) reviewsForMovie:(Movie*) movie inMovies:(NSArray*) movies {
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider == rottenTomatoesScoreProvider) {
        currentScoreProvider = metacriticScoreProvider;
    }

    return [currentScoreProvider reviewsForMovie:movie inMovies:movies];
}


- (void) update {
    if (model.userAddress.length == 0) {
        return;
    }
    
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;

    [ThreadingUtilities backgroundSelector:@selector(updateBackgroundEntryPoint:)
                                  onTarget:self
                                  argument:currentScoreProvider
                                      gate:gate
                                   visible:NO];
}


- (void) updateBackgroundEntryPoint:(id<ScoreProvider>) currentScoreProvider {
    [currentScoreProvider update];

    for (id<ScoreProvider> provider in self.scoreProviders) {
        if (provider != currentScoreProvider) {
            [provider update];
        }
    }
}


- (void) prioritizeMovie:(Movie*) movie
                inMovies:(NSArray*) movies {
    for (id<ScoreProvider> provider in self.scoreProviders) {
        [provider prioritizeMovie:movie inMovies:movies];
    }
}

@end