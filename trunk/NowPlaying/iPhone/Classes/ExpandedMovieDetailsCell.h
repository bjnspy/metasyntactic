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

#import "AbstractMovieDetailsCell.h"

@interface ExpandedMovieDetailsCell : AbstractMovieDetailsCell {
    UILabel* ratedTitleLabel;
    UILabel* runningTimeTitleLabel;
    UILabel* releaseDateTitleLabel;
    UILabel* genreTitleLabel;
    UILabel* directorTitleLabel;
    UILabel* castTitleLabel;

    UILabel* ratedLabel;
    UILabel* runningTimeLabel;
    UILabel* releaseDateLabel;
    UILabel* genreLabel;
    UILabel* directorLabel;
    NSArray* castLabels;

    CGFloat titleWidth;
}

@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* runningTimeTitleLabel;
@property (retain) UILabel* releaseDateTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;

@property (retain) UILabel* ratedLabel;
@property (retain) UILabel* runningTimeLabel;
@property (retain) UILabel* releaseDateLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* directorLabel;
@property (retain) NSArray* castLabels;

@end