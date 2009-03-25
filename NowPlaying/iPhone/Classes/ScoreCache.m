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

#import "AppDelegate.h"
#import "Application.h"
#import "FileUtilities.h"
#import "GoogleScoreProvider.h"
#import "MetacriticScoreProvider.h"
#import "Model.h"
#import "NoneScoreProvider.h"
#import "OperationQueue.h"
#import "RottenTomatoesScoreProvider.h"
#import "Score.h"
#import "ScoreProvider.h"

@interface ScoreCache()
@property (retain) id<ScoreProvider> rottenTomatoesScoreProvider_;
@property (retain) id<ScoreProvider> metacriticScoreProvider_;
@property (retain) id<ScoreProvider> googleScoreProvider_;
@property (retain) id<ScoreProvider> noneScoreProvider_;
@property BOOL updated_;
@end

@implementation ScoreCache

@synthesize rottenTomatoesScoreProvider_;
@synthesize metacriticScoreProvider_;
@synthesize googleScoreProvider_;
@synthesize noneScoreProvider_;
@synthesize updated_;

property_wrapper(id<ScoreProvider>, rottenTomatoesScoreProvider, RottenTomatoesScoreProvider);
property_wrapper(id<ScoreProvider>, metacriticScoreProvider, MetacriticScoreProvider);
property_wrapper(id<ScoreProvider>, googleScoreProvider, GoogleScoreProvider);
property_wrapper(id<ScoreProvider>, noneScoreProvider, NoneScoreProvider);
property_wrapper(BOOL, updated, Updated);

- (void) dealloc {
    self.rottenTomatoesScoreProvider = nil;
    self.metacriticScoreProvider = nil;
    self.googleScoreProvider = nil;
    self.noneScoreProvider = nil;

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
            self.rottenTomatoesScoreProvider,
            self.metacriticScoreProvider,
            self.googleScoreProvider,
            self.noneScoreProvider, nil];
}


- (id<ScoreProvider>) currentScoreProvider {
    if (self.model.rottenTomatoesScores) {
        return self.rottenTomatoesScoreProvider;
    } else if (self.model.metacriticScores) {
        return self.metacriticScoreProvider;
    } else if (self.model.googleScores) {
        return self.googleScoreProvider;
    } else if (self.model.noScores) {
        return self.noneScoreProvider;
    } else {
        return nil;
    }
}


- (Score*) scoreForMovie:(Movie*) movie {
    return [self.currentScoreProvider scoreForMovie:movie];
}


- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie {
    return [self.rottenTomatoesScoreProvider scoreForMovie:movie];
}


- (Score*) metacriticScoreForMovie:(Movie*) movie {
    return [self.metacriticScoreProvider scoreForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider == self.rottenTomatoesScoreProvider) {
        currentScoreProvider = self.metacriticScoreProvider;
    }

    return [currentScoreProvider reviewsForMovie:movie];
}


- (void) processMovie:(Movie*) movie {
    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider == self.rottenTomatoesScoreProvider) {
        currentScoreProvider = self.metacriticScoreProvider;
    }

    [currentScoreProvider processMovie:movie];
}


- (void) update {
    if (self.model.userAddress.length == 0) {
        return;
    }

    if (self.updated) {
        return;
    }
    self.updated = YES;

    id<ScoreProvider> currentScoreProvider = self.currentScoreProvider;
    if (currentScoreProvider != self.noneScoreProvider) {
        [[OperationQueue operationQueue] performSelector:@selector(updatePrimaryScoreProvider:)
                                         onTarget:self
                                           withObject:currentScoreProvider
                                             gate:nil
                                          priority:Priority];
    }

    for (id<ScoreProvider> provider in self.scoreProviders) {
        if (provider != currentScoreProvider) {
            [[OperationQueue operationQueue] performSelector:@selector(update)
                                                 onTarget:provider
                                                     gate:nil
                                                  priority:Normal];
        }
    }
}


- (void) updatePrimaryScoreProvider:(id<ScoreProvider>) scoreProvider {
    NSString* notification = [NSString stringWithFormat:NSLocalizedString(@"%@ scores", nil), [scoreProvider providerName]];
    [AppDelegate addNotification:notification];
    {
        [scoreProvider update];
    }
    [AppDelegate removeNotification:notification];
}

@end