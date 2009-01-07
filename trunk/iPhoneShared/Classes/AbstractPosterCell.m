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
#import "Movie.h"
#import "Model.h"


@interface AbstractPosterCell()
@property ImageState state;
@property (retain) Model* model;
@property (retain) UIImageView* imageLoadingView;
@property (retain) UIImageView* imageView;
@property (retain) UIActivityIndicatorView* activityView;
@property (retain) UILabel* titleLabel;
@end


@implementation AbstractPosterCell

@synthesize state;
@synthesize model;
@synthesize movie;
@synthesize imageLoadingView;
@synthesize imageView;
@synthesize activityView;
@synthesize titleLabel;

- (void) dealloc {
    self.model = nil;
    self.movie = nil;
    self.imageLoadingView = nil;
    self.imageView = nil;
    self.activityView = nil;
    self.titleLabel = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 20)] autorelease];

        state = Loading;
        self.imageLoadingView = [[[UIImageView alloc] initWithImage:[ImageCache imageLoading]] autorelease];
        imageLoadingView.contentMode = UIViewContentModeScaleAspectFit;

        self.imageView = [[[UIImageView alloc] init] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.alpha = 0;

        CGRect imageFrame = imageLoadingView.frame;
        imageFrame.size.width = (int)(imageFrame.size.width * SMALL_POSTER_HEIGHT / imageFrame.size.height);
        imageFrame.size.height = (int)SMALL_POSTER_HEIGHT;
        imageView.frame = imageLoadingView.frame = imageFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;

        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        activityView.hidesWhenStopped = YES;
        CGRect frame = activityView.frame;
        frame.origin.x = 25;
        frame.origin.y = 40;
        activityView.frame = frame;

        [self.contentView addSubview:imageLoadingView];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:activityView];
    }

    return self;
}


- (void) loadImage {
    if (state == Loaded) {
        // we're done.  nothing else to do.
        return;
    }

    UIImage* image = [model smallPosterForMovie:movie];
    if (image == nil) {
        [model prioritizeMovie:movie];
        if ([GlobalActivityIndicator hasBackgroundTasks]) {
            // don't need to do anything.
            // keep up the spinner
            state = Loading;
        } else {
            state = NotFound;
        }
    } else {
        state = Loaded;
    }

    switch (state) {
        case Loading: {
            [activityView startAnimating];
            imageView.image = nil;
            imageView.alpha = 0;
            return;
        }
        case Loaded: {
            [activityView stopAnimating];
            imageView.image = image;
            break;
        }
        case NotFound: {
            [activityView stopAnimating];
            imageView.image = [ImageCache imageNotAvailable];
            break;
        }
    }

    [UIView beginAnimations:nil context:NULL];
    {
        imageLoadingView.alpha = 0;
        imageView.alpha = 1;
    }
    [UIView commitAnimations];
}


- (void) clearImage {
    [activityView startAnimating];

    state = Loading;
    imageView.image = nil;
    imageView.alpha = 0;
    imageLoadingView.alpha = 1;
}


- (NSArray*) allLabels {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSArray*) valueLabels {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        titleLabel.textColor = [UIColor whiteColor];

        for (UILabel* label in self.allLabels) {
            label.textColor = [UIColor whiteColor];
        }
    } else {
        titleLabel.textColor = [UIColor blackColor];

        for (UILabel* label in self.allLabels) {
            label.textColor = [UIColor darkGrayColor];
        }
    }
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


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = imageView.frame;

    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = (int)(imageFrame.size.width + 7);
    titleFrame.size.width = self.contentView.frame.size.width - titleFrame.origin.x;
    titleLabel.frame = titleFrame;

    for (UILabel* label in self.valueLabels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7 + titleWidth + 5);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}

@end