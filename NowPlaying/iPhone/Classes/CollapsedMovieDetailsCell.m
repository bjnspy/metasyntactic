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

#import "CollapsedMovieDetailsCell.h"

#import "LocaleUtilities.h"
#import "Movie.h"

@interface CollapsedMovieDetailsCell()
@property (retain) UILabel* ratingAndRuntimeLabel_;
@end


@implementation CollapsedMovieDetailsCell

@synthesize ratingAndRuntimeLabel_;

property_wrapper(UILabel*, ratingAndRuntimeLabel, RatingAndRuntimeLabel);

- (void) dealloc {
    self.ratingAndRuntimeLabel = nil;

    [super dealloc];
}


- (id) initWithMovie:(Movie*) movie_ {
    if (self = [super initWithMovie:movie_]) {
        self.ratingAndRuntimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.ratingAndRuntimeLabel.font = [UIFont boldSystemFontOfSize:14];

        if ([@"de" isEqual:[LocaleUtilities isoLanguage]]) {
            self.ratingAndRuntimeLabel.text = movie.rating;
        } else {
            self.ratingAndRuntimeLabel.text = movie.ratingAndRuntimeString;
        }

        self.ratingAndRuntimeLabel.textAlignment = UITextAlignmentCenter;
        [self.ratingAndRuntimeLabel sizeToFit];

        [self.contentView addSubview:self.ratingAndRuntimeLabel];

        self.image = [UIImage imageNamed:@"RightDisclosureTriangle.png"];
    }

    return self;
}


- (CGFloat) height:(UITableView*) tableView {
    return tableView.rowHeight - 14;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.ratingAndRuntimeLabel.frame;
    frame.origin.y = (int)((self.contentView.frame.size.height - frame.size.height) / 2.0);
    frame.origin.x = (int)((self.contentView.frame.size.width - frame.size.width) / 2.0);
    self.ratingAndRuntimeLabel.frame = frame;
}

@end