// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Movie.h"
#import "BoxOfficeModel.h"

@interface MovieTitleCell : UITableViewCell {
    BoxOfficeModel* model;
    UITableViewStyle style;
    UILabel* scoreLabel;
    UILabel* titleLabel;
    UILabel* ratingLabel;
}

@property (retain) BoxOfficeModel* model;
@property (retain) UILabel* scoreLabel;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* ratingLabel;

- (id)      initWithFrame:(CGRect) frame
          reuseIdentifier:(NSString*) reuseIdentifier
                    model:(BoxOfficeModel*) model
                    style:(UITableViewStyle) style;

- (void) setMovie:(Movie*) movie;


@end
