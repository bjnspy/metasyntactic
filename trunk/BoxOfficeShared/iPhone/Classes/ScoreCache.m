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

static ScoreCache* cache;

+ (void) initialize {
  if (self == [ScoreCache class]) {
    cache = [[ScoreCache alloc] init];
  }
}


+ (ScoreCache*) cache {
  return cache;
}

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
  if ((self = [super init])) {
    self.rottenTomatoesScoreProvider = [RottenTomatoesScoreProvider provider];
    self.metacriticScoreProvider = [MetacriticScoreProvider provider];
    self.googleScoreProvider = [GoogleScoreProvider provider];
    self.noneScoreProvider = [NoneScoreProvider provider];
  }

  return self;
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
  if ([Model model].rottenTomatoesScores) {
    return rottenTomatoesScoreProvider;
  } else if ([Model model].metacriticScores) {
    return metacriticScoreProvider;
  } else if ([Model model].googleScores) {
    return googleScoreProvider;
  } else if ([Model model].noScores) {
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
  if (![Model model].scoreCacheEnabled) {
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
