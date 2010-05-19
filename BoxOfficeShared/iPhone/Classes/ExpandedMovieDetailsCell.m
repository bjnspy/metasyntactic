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

#import "ExpandedMovieDetailsCell.h"

#import "Model.h"

@implementation ExpandedMovieDetailsCell

+ (void) addRating:(Movie*) movie
             items:(MutableMultiDictionary*) items
        itemsArray:(NSMutableArray*) itemsArray {
  NSString* title = LocalizedString(@"Rated:", nil);
  NSString* value = [[Model model] ratingForMovie:movie];
  if (value.length == 0) {
    value = LocalizedString(@"Unrated", nil);
  }

  [self addTitle:title andValue:value to:items and:itemsArray];
}


+ (void) addRunningTime:(Movie*) movie
                  items:(MutableMultiDictionary*) items
             itemsArray:(NSMutableArray*) itemsArray {
  NSInteger length = [[Model model] lengthForMovie:movie];
  if (length <= 0) {
    return;
  }

  NSString* title = LocalizedString(@"Running time:", nil);
  NSString* value = [Movie runtimeString:length];

  [self addTitle:title andValue:value to:items and:itemsArray];
}


+ (void) addReleaseDate:(Movie*) movie
                  items:(MutableMultiDictionary*) items
             itemsArray:(NSMutableArray*) itemsArray {
  if (movie.releaseDate == nil) {
    return;
  }

  NSString* title = LocalizedString(@"Release date:", nil);

  NSString* value;
  if (movie.isNetflix) {
    value = [DateUtilities formatYear:movie.releaseDate];
  } else {
    value = [DateUtilities formatMediumDate:movie.releaseDate];
  }

  [self addTitle:title andValue:value to:items and:itemsArray];
}


+ (void) addGenres:(Movie*) movie
             items:(MutableMultiDictionary*) items
        itemsArray:(NSMutableArray*) itemsArray {
  NSArray* genres = [[Model model] genresForMovie:movie];
  if (genres.count == 0) {
    return;
  }

  NSString* title = LocalizedString(@"Genre:", nil);
  NSString* value = [genres componentsJoinedByString:@", "];
  if (value.length == 0) {
    return;
  }

  [self addTitle:title andValue:value to:items and:itemsArray];
}


+ (void) addStudio:(Movie*) movie
             items:(MutableMultiDictionary*) items
        itemsArray:(NSMutableArray*) itemsArray {
  if (movie.studio.length == 0) {
    return;
  }

  NSString* title = LocalizedString(@"Studio:", nil);
  NSString* value = movie.studio;

  [self addTitle:title andValue:value to:items and:itemsArray];
}


+ (void) addDirectors:(Movie*) movie
                items:(MutableMultiDictionary*) items
           itemsArray:(NSMutableArray*) itemsArray {
  NSArray* directors = [[Model model] directorsForMovie:movie];
  if (directors.count == 0) {
    return;
  }

  NSString* title;
  if (directors.count == 1) {
    title = LocalizedString(@"Director:", nil);
  } else {
    title = LocalizedString(@"Directors:", nil);
  }

  [self addTitle:title andValues:directors to:items and:itemsArray];
}


+ (void) addCast:(Movie*) movie
           items:(MutableMultiDictionary*) items
      itemsArray:(NSMutableArray*) itemsArray {
  NSArray* cast = [[Model model] castForMovie:movie];
  if (cast.count == 0) {
    return;
  }

  NSString* title = LocalizedString(@"Cast:", nil);
  [self addTitle:title andValues:cast to:items and:itemsArray];
}


+ (void) initializeData:(Movie*) movie
                  items:(MutableMultiDictionary*) items
             itemsArray:(NSMutableArray*) itemsArray {
  [self addRating:movie items:items itemsArray:itemsArray];
  [self addRunningTime:movie items:items itemsArray:itemsArray];
  [self addReleaseDate:movie items:items itemsArray:itemsArray];
  [self addGenres:movie items:items itemsArray:itemsArray];
  [self addStudio:movie items:items itemsArray:itemsArray];
  [self addDirectors:movie items:items itemsArray:itemsArray];
  [self addCast:movie items:items itemsArray:itemsArray];
}


- (id)    initWithMovie:(Movie*) movie
    tableViewController:(UITableViewController*) tableViewController {
  MutableMultiDictionary* items = [MutableMultiDictionary dictionary];
  NSMutableArray* itemsArray = [NSMutableArray array];

  [ExpandedMovieDetailsCell initializeData:movie items:items itemsArray:itemsArray];

  if ((self = [super initWithItems:items
                        itemsArray:itemsArray
               tableViewController:tableViewController])) {
  }

  return self;
}

@end
