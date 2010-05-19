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

#import "MovieTitleCell.h"

#import "BookmarkCache.h"
#import "GreenMovieTitleCell.h"
#import "Model.h"
#import "NoScoreMovieTitleCell.h"
#import "PerfectGreenMovieTitleCell.h"
#import "RedMovieTitleCell.h"
#import "RottenMovieTitleCell.h"
#import "Score.h"
#import "TomatoMovieTitleCell.h"
#import "UnknownMovieTitleCell.h"
#import "YellowMovieTitleCell.h"


@interface MovieTitleCell()
@property (retain) UILabel* scoreLabel;
@end


@implementation MovieTitleCell

@synthesize scoreLabel;

- (void) dealloc {
  self.scoreLabel = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleSubtitle
                   reuseIdentifier:reuseIdentifier])) {
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
}


- (void) setScore:(Score*) score {
  scoreLabel.text = score.score;
}


- (void) setMovie:(Movie*) movie {
  self.detailTextLabel.text = [[Model model] ratingAndRuntimeForMovie:movie];

  if ([[BookmarkCache cache] isBookmarked:movie]) {
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

@end
