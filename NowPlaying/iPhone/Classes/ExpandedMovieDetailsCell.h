// Copyright (C) 2008 Cyrus Najmabadi
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