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

#import "NetflixGenreRecommendationsViewController.h"

#import "CommonNavigationController.h"
#import "Model.h"
#import "NetflixCell.h"

@interface NetflixGenreRecommendationsViewController()
@property (retain) NetflixAccount* account;
@property (copy) NSString* genre;
@end


@implementation NetflixGenreRecommendationsViewController

@synthesize account;
@synthesize genre;

- (void) dealloc {
  self.account = nil;
  self.genre = nil;

  [super dealloc];
}


- (id) initWithGenre:(NSString*) genre_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.genre = genre_;
    self.title = genre_;
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (NSArray*) determineMovies {
  self.account = self.model.currentNetflixAccount;
  Queue* queue = [self.model.netflixCache queueForKey:[NetflixCache recommendationKey] account:account];
  
  NSMutableArray* array = [NSMutableArray array];
  
  for (Movie* movie in queue.movies) {
    NSArray* genres = movie.genres;
    if (genres.count > 0 && [genre isEqual:[genres objectAtIndex:0]]) {
      [array addObject:movie];
    }
  }
  
  return array;
}

@end
