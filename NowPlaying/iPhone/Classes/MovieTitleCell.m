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

#import "MovieTitleCell.h"

#import "GreenMovieTitleCell.h"
#import "Model.h"
#import "Movie.h"
#import "NoScoreMovieTitleCell.h"
#import "PerfectGreenMovieTitleCell.h"
#import "RedMovieTitleCell.h"
#import "RottenMovieTitleCell.h"
#import "Score.h"
#import "StringUtilities.h"
#import "TomatoMovieTitleCell.h"
#import "UITableViewCell+Utilities.h"
#import "UnknownMovieTitleCell.h"
#import "YellowMovieTitleCell.h"


@interface MovieTitleCell()
@property (retain) UILabel* scoreLabel;
#ifndef IPHONE_OS_VERSION_3
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;
#endif
@end


@implementation MovieTitleCell

@synthesize scoreLabel;
#ifndef IPHONE_OS_VERSION_3
@synthesize textLabel;
@synthesize detailTextLabel;
#endif

- (void) dealloc {
    self.scoreLabel = nil;
#ifndef IPHONE_OS_VERSION_3
    self.textLabel = nil;
    self.detailTextLabel = nil;
#endif

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier]) {
#ifndef IPHONE_OS_VERSION_3
        self.textLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        textLabel.font = [UIFont boldSystemFontOfSize:18];
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.minimumFontSize = 14;
        textLabel.textColor = [UIColor blackColor];

        self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        detailTextLabel.font = [UIFont systemFontOfSize:12];
        detailTextLabel.textColor = [UIColor grayColor];

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:detailTextLabel];
#endif

        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumFontSize = 12;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        self.scoreLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        [self.contentView addSubview:scoreLabel];
    }

    return self;
}


+ (NSString*) reuseIdentifier {
    return @"MovieTitleCell";
}


+ (MovieTitleCell*) movieTitleCellForClass:(Class) class inTableView:(UITableView*) tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:[class reuseIdentifier]];
    if (cell == nil) {
        cell = [[[class alloc] init] autorelease];
    }

    return cell;
}


+ (MovieTitleCell*) movieTitleCellForScore:(Score*) score
                               inTableView:(UITableView*) tableView {
    if ([Model model].noScores) {
        return [self movieTitleCellForClass:[NoScoreMovieTitleCell class] inTableView:tableView];
    }

    NSInteger scoreValue = score.scoreValue;
    if (score == nil || scoreValue == -1) {
        return [self movieTitleCellForClass:[UnknownMovieTitleCell class] inTableView:tableView];
    }

    if ([Model model].rottenTomatoesScores) {
        if (scoreValue >= 60) {
            return [self movieTitleCellForClass:[TomatoMovieTitleCell class] inTableView:tableView];
        } else {
            return [self movieTitleCellForClass:[RottenMovieTitleCell class] inTableView:tableView];
        }
    } else {
        if (scoreValue <= 40) {
            return [self movieTitleCellForClass:[RedMovieTitleCell class] inTableView:tableView];
        } else if (scoreValue <= 60) {
            return [self movieTitleCellForClass:[YellowMovieTitleCell class] inTableView:tableView];
        } else if (scoreValue < 100) {
            return [self movieTitleCellForClass:[GreenMovieTitleCell class] inTableView:tableView];
        } else {
            return [self movieTitleCellForClass:[PerfectGreenMovieTitleCell class] inTableView:tableView];
        }
    }
}


- (void) layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:scoreLabel];

#ifndef IPHONE_OS_VERSION_3
    CGRect frame;
    if ([Model model].noScores) {
        frame = CGRectMake(10, 25, 0, 14);
    } else {
        frame = CGRectMake(50, 25, 0, 14);
    }

    frame.size.width = self.contentView.frame.size.width - frame.origin.x;

    detailTextLabel.frame = frame;

    frame.origin.y = 5;
    frame.size.height = 20;
    textLabel.frame = frame;
#endif
}


- (void) setScore:(Score*) score {
    scoreLabel.text = score.score;
}


- (void) setMovie:(Movie*) movie {
    self.detailTextLabel.text = movie.ratingAndRuntimeString;

    if ([[Model model] isBookmarked:movie]) {
        self.textLabel.text = [NSString stringWithFormat:@"%@ %@", [StringUtilities starString], movie.displayTitle];
    } else {
        self.textLabel.text = movie.displayTitle;
    }
}


+ (MovieTitleCell*) movieTitleCellForMovie:(Movie*) movie inTableView:(UITableView*) tableView {
    Score* score = [[Model model] scoreForMovie:movie];

    MovieTitleCell* cell = [self movieTitleCellForScore:score inTableView:tableView];
    [cell setScore:score];
    [cell setMovie:movie];
    return cell;
}


#ifndef IPHONE_OS_VERSION_3
- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        textLabel.textColor = [UIColor whiteColor];
        detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        textLabel.textColor = [UIColor blackColor];
        detailTextLabel.textColor = [UIColor grayColor];
    }
}
#endif

@end
