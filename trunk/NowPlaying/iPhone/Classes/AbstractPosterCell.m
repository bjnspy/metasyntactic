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

#import "AbstractPosterCell.h"

#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "Model.h"
#import "Movie.h"


@implementation AbstractPosterCell

@synthesize movie;

- (void) dealloc {
    self.movie = nil;

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithReuseIdentifier:reuseIdentifier model:model_]) {
    }

    return self;
}


- (UIImage*) loadImageWorker {
    return [model smallPosterForMovie:movie];
}


- (void) prioritizeImage {
    [model prioritizeMovie:movie];
}


- (void) onSetSameMovie:(Movie*) movie_
                  owner:(id) owner  {
    // refreshing with the same movie.
    // update our image if necessary.
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadImage) object:nil];
    [self performSelector:@selector(loadImage) withObject:nil afterDelay:0];
}


- (void) onSetDifferentMovie:(Movie*) movie_
                       owner:(id) owner  {
    // switching to a new movie.  update everything.
    self.movie = movie_;

    for (UILabel* label in self.allLabels) {
        [label removeFromSuperview];
    }

    [self clearImage];

    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];
    [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
}


- (void) setMovie:(Movie*) movie_
            owner:(id) owner {
    if ([model isBookmarked:movie_]) {
        titleLabel.text = [NSString stringWithFormat:@"%@ %@", [Application starString], movie_.displayTitle];
    } else {
        titleLabel.text = movie_.displayTitle;
    }

    if (movie == movie_) {
        [self onSetSameMovie:movie_ owner:owner];
    } else {
        [self onSetDifferentMovie:movie_ owner:owner];
    }
}

@end