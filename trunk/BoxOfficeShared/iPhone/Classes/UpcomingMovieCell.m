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

#import "UpcomingMovieCell.h"

#import "BookmarkCache.h"
#import "Model.h"
#import "UpcomingMoviesViewController.h"

@interface UpcomingMovieCell()
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;
@end


@implementation UpcomingMovieCell

@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedTitleLabel;
@synthesize genreTitleLabel;

@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratedLabel;
@synthesize genreLabel;

- (void) dealloc {
  self.directorTitleLabel = nil;
  self.castTitleLabel = nil;
  self.ratedTitleLabel = nil;
  self.genreTitleLabel = nil;

  self.directorLabel = nil;
  self.castLabel = nil;
  self.ratedLabel = nil;
  self.genreLabel = nil;

  [super dealloc];
}


- (UILabel*) createTitleLabel:(NSString*) title yPosition:(NSInteger) yPosition {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [UIColor darkGrayColor];
  label.text = title;
  label.textAlignment = UITextAlignmentRight;
  [label sizeToFit];
  CGRect frame = label.frame;
  frame.origin.y = yPosition;
  label.frame = frame;

  return label;
}


- (UILabel*) createValueLabel:(NSInteger) yPosition {
  CGFloat height = directorTitleLabel.frame.size.height;
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, height)] autorelease];
  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [UIColor darkGrayColor];
  return label;
}


- (NSArray*) titleLabels {
  return [NSArray arrayWithObjects:
          directorTitleLabel,
          castTitleLabel,
          genreTitleLabel,
          ratedTitleLabel,
          nil];
}


- (NSArray*) valueLabels {
  return [NSArray arrayWithObjects:
          directorLabel,
          castLabel,
          genreLabel,
          ratedLabel,
          nil];
}


- (NSArray*) allLabels {
  return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [super initWithReuseIdentifier:reuseIdentifier
                         tableViewController:tableViewController_])) {
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = 14;

    self.directorTitleLabel = [self createTitleLabel:LocalizedString(@"Directors:", nil) yPosition:22];
    self.directorLabel = [self createValueLabel:22];

    self.castTitleLabel = [self createTitleLabel:LocalizedString(@"Cast:", nil) yPosition:37];
    self.castLabel = [self createValueLabel:38];
    castLabel.numberOfLines = 0;

    self.genreTitleLabel = [self createTitleLabel:LocalizedString(@"Genre:", nil) yPosition:67];
    self.genreLabel = [self createValueLabel:67];

    self.ratedTitleLabel = [self createTitleLabel:LocalizedString(@"Rated:", nil) yPosition:82];
    self.ratedLabel = [self createValueLabel:82];

    titleWidth = 0;
    for (UILabel* label in self.titleLabels) {
      titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
    }

    for (UILabel* label in self.titleLabels) {
      CGRect frame = label.frame;
      frame.size.width = titleWidth;
      frame.origin.x = (NSInteger)(imageView.frame.size.width + 7);
      label.frame = frame;
    }

    [self.contentView addSubview:titleLabel];
  }

  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGRect castFrame = castLabel.frame;
  CGSize size = [castLabel.text sizeWithFont:castLabel.font constrainedToSize:CGSizeMake(castFrame.size.width, 30) lineBreakMode:UILineBreakModeWordWrap];
  castFrame.size = size;
  castLabel.frame = castFrame;
}


- (void) loadMovieWorker:(UITableViewController*) owner {
  directorLabel.text  = [[[Model model] directorsForMovie:movie]  componentsJoinedByString:@", "];
  castLabel.text      = [[[Model model] castForMovie:movie]       componentsJoinedByString:@", "];
  genreLabel.text     = [[[Model model] genresForMovie:movie]     componentsJoinedByString:@", "];

  NSString* rating = [[Model model] ratingForMovie:movie];
  if (rating.length == 0) {		
    rating = LocalizedString(@"Not yet rated", nil);		
  }

  if ([(id) owner sortingByTitle] || [[BookmarkCache cache] isBookmarked:movie]) {
    NSString* releaseDate = [DateUtilities formatShortDate:movie.releaseDate];

    if (rating.length > 0) {
      releaseDate = [NSString stringWithFormat:LocalizedString(@"Release: %@", @"This is a shorter form of 'Release date:'. Used when there's less onscreen space."), releaseDate];
    }

    ratedLabel.text   = [NSString stringWithFormat:@"%@ - %@", rating, releaseDate];
  } else {
    ratedLabel.text = rating;
  }

  if (movie.directors.count <= 1) {
    directorTitleLabel.text = LocalizedString(@"Director:", nil);
  } else {
    directorTitleLabel.text = LocalizedString(@"Directors:", nil);
  }

  for (UILabel* label in self.allLabels) {
    [self.contentView addSubview:label];
  }

  [self setNeedsLayout];
}

@end
