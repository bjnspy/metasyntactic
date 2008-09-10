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

@interface UpcomingMovieCell : UITableViewCell {
    NowPlayingModel* model;
    UILabel* titleLabel;
    UILabel* directorTitleLabel;
    UILabel* castTitleLabel;
    UILabel* genreTitleLabel;
    UILabel* ratedTitleLabel;

    UILabel* directorLabel;
    UILabel* castLabel;
    UILabel* genreLabel;
    UILabel* ratedLabel;

    UIImageView* imageView;

    CGFloat titleWidth;
}

@property (retain) NowPlayingModel* model;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;

@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;

@property (retain) UIImageView* imageView;

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier
                    model:(NowPlayingModel*) model;

- (void) setMovie:(Movie*) movie owner:(id) owner;

@end