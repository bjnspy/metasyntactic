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

#import "GoogleScoreProvider.h"
#import "MetacriticScoreProvider.h"
#import "Model.h"
#import "NoneScoreProvider.h"
#import "RottenTomatoesScoreProvider.h"

@interface ScoreCache()
@property (retain) id<ScoreProvider> rottenTomatoesScoreProvider;
@property (retain) id<ScoreProvider> metacriticScoreProvider;
@property (retain) id<ScoreProvider> googleScoreProvider;
@property (retain) id<ScoreProvider> noneScoreProvider;
@property BOOL updated;
@end

@implementation ScoreCache

@synthesize rottenTomatoesScoreProvider;
@synthesize metacriticScoreProvider;
@synthesize googleScoreProvider;
@synthesize noneScoreProvider;
@synthesize updated;

- (void) dealloc {
    self.rottenTomatoesScoreProvider = nil;
    self.metacriticScoreProvider = nil;
    self.googleScoreProvider = nil;
    self.noneScoreProvider = nil;
    self.updated = NO;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.rottenTomatoesScoreProvider = [RottenTomatoesScoreProvider provider];
        self.metacriticScoreProvider = [MetacriticScoreProvider provider];
        self.googleScoreProvider = [GoogleScoreProvider provider];
        self.noneScoreProvider = [NoneScoreProvider provider];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


+ (ScoreCache*) cache {
    return [[[ScoreCache alloc] init] autorelease];
}


- (NSArray*) scoreProviders {
    return [NSArray arrayWithObjects:
            rottenTomatoesScoreProvider,
            metacriticScoreProvider,
            googleScoreProvider,
            noneScoreProvider,
            nil];
}


- (id<ScoreProvider>) currentScoreProvider {
    if (self.model.rottenTomatoesScores) {
        return rottenTomatoesScoreProvider;
    } else if (self.model.metacriticScores) {
        return metacriticScoreProvider;
    } else if (self.model.googleScores) {
        return googleScoreProvider;
    } else if (self.model.noScores) {
        return noneScoreProvider;
    } else {
        return nil;
    }
}


- (Score*) scoreForMovie:(Movie*) movie {
    return [self.currentScoreProvider scoreForMovie:movie];
}


- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie {
    return [rottenTomatoesScoreProvider scoreForMovie:movie];
}


- (Score*) metacriticScoreForMovie:(Movie*) movie {
    return [metacriticScoreProvider scoreForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider == rottenTomatoesScoreProvider) {
        currentScoreProvider = metacriticScoreProvider;
    }

    return [currentScoreProvider reviewsForMovie:movie];
}


- (void) processMovie:(Movie*) movie force:(BOOL) force{
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider == rottenTomatoesScoreProvider) {
        currentScoreProvider = metacriticScoreProvider;
    }

    [currentScoreProvider processMovie:movie force:force];
}


- (void) update {
    if (!self.model.scoreCacheEnabled) {
        return;
    }

    if (updated) {
        return;
    }
    self.updated = YES;

    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider != noneScoreProvider) {
        [[OperationQueue operationQueue] performSelector:@selector(updateWithNotifications)
                                                onTarget:currentScoreProvider
                                                    gate:nil
                                                priority:Priority];
    }

    for (id<ScoreProvider> provider in self.scoreProviders) {
        if (provider != currentScoreProvider && provider != noneScoreProvider) {
            [[OperationQueue operationQueue] performSelector:@selector(updateWithoutNotifications)
                                                    onTarget:provider
                                                        gate:nil
                                                    priority:Priority];
        }
    }
}

@end
