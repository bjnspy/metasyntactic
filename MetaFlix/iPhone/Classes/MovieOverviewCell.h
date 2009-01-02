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

#import "TappableImageViewDelegate.h"

@interface MovieOverviewCell : UITableViewCell {
@private
    MetaFlixModel* model;
    Movie* movie;

    NSString* synopsis;
    NSInteger synopsisSplit;
    NSInteger synopsisMax;

    UILabel* synopsisChunk1Label;
    UILabel* synopsisChunk2Label;

    UIImage* posterImage;
}

+ (MovieOverviewCell*) cellWithMovie:(Movie*) movie
                               model:(MetaFlixModel*) model
                               frame:(CGRect) frame
                         posterImage:(UIImage*) posterImage
                     posterImageView:(TappableImageView*) posterImageView
                        activityView:(ActivityIndicatorViewWithBackground*) activityView;
+ (CGFloat) heightForMovie:(Movie*) movie model:(MetaFlixModel*) model;

@end