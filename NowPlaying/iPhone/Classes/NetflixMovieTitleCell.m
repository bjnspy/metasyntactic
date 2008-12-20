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

#import "NetflixMovieTitleCell.h"

#import "Application.h"
#import "ColorCache.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "NowPlayingModel.h"

@interface NetflixMovieTitleCell()
@property (retain) UILabel* starLabel;
@end


@implementation NetflixMovieTitleCell

@synthesize starLabel;

- (void) dealloc {
    self.starLabel = nil;
    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_
               style:(UITableViewStyle) style_ {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier
                              model:model_
                              style:style_]) {
        self.starLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        starLabel.font = [UIFont systemFontOfSize:17];
        starLabel.textColor = [ColorCache netflixRed];
        starLabel.text = [@"" stringByPaddingToLength:5 withString:[Application starString] startingAtIndex:0];
        starLabel.backgroundColor = [UIColor clearColor];
        [starLabel sizeToFit];

        [self.contentView addSubview:starLabel];
    }

    return self;
}


- (void) setScore:(Movie*) movie {
}


- (BOOL) noScores {
    return YES;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect starFrame = starLabel.frame;
    starFrame.origin.x = 10;
    starFrame.origin.y = 21;
    starLabel.frame = starFrame;

    CGRect ratingFrame = ratingLabel.frame;
    ratingFrame.origin.x = starFrame.origin.x + starFrame.size.width + 10;
    ratingFrame.origin.y = 26;
    ratingFrame.size.width = self.contentView.frame.size.width - ratingFrame.origin.x;
    ratingFrame.size.height = 14;

    ratingLabel.frame = ratingFrame;
}


- (void) setMovie:(Movie*) movie owner:(id) owner {
    [super setMovie:movie owner:owner];

    NSMutableString* result = [NSMutableString string];
    NSString* rating = [model.netflixCache ratingForMovie:movie];
    if (rating.length == 0) {
        starLabel.text = @"";
        return;
    }

    CGFloat score = [rating floatValue];

    for (int i = 0; i < 5; i++) {
        CGFloat value = score - i;
        if (value <= 0) {
            [result appendString:[Application emptyStarString]];
        } else if (value >= 1) {
            [result appendString:[Application starString]];
        } else {
            [result appendString:[Application halfStarString]];
        }
    }

    starLabel.text = result;
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        starLabel.textColor = [UIColor whiteColor];
    } else {
        starLabel.textColor = [UIColor redColor];
    }
}

@end