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

#import "PostersViewController.h"

#import "LargePosterCache.h"
#import "Model.h"

@interface PostersViewController()
@property (retain) Movie* movie;
@end


@implementation PostersViewController

@synthesize movie;

- (void) dealloc {
  self.movie = nil;

  [super dealloc];
}


- (id) initWithMovie:(Movie*) movie_
         posterCount:(NSInteger) posterCount_ {
  if ((self = [super initWithImageCount:posterCount_])) {
    self.movie = movie_;
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (LargePosterCache*) largePosterCache {
  return [LargePosterCache cache];
}


- (BOOL) allImagesDownloaded {
  return [self.largePosterCache allPostersDownloadedForMovie:movie];
}


- (BOOL) imageExistsForPage:(NSInteger) page {
  return [self.largePosterCache posterExistsForMovie:movie index:page];
}


- (UIImage*) imageForPage:(NSInteger) page {
  return [self.largePosterCache posterForMovie:movie index:page loadFromDisk:YES];
}


- (BOOL) allowsSaving {
  return YES;
}

@end
