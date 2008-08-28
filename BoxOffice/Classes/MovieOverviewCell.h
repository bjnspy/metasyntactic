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

@interface MovieOverviewCell : UITableViewCell {
    BoxOfficeModel* model;
    Movie* movie;

    UIImage* posterImage;
    NSString* synopsis;
    NSInteger synopsisSplit;
    NSInteger synopsisMax;

    UILabel* synopsisChunk1Label;
    UILabel* synopsisChunk2Label;
}

@property (retain) BoxOfficeModel* model;
@property (retain) Movie* movie;
@property (retain) UIImage* posterImage;
@property (copy) NSString* synopsis;
@property NSInteger synopsisSplit;
@property NSInteger synopsisMax;
@property (retain) UILabel* synopsisChunk1Label;
@property (retain) UILabel* synopsisChunk2Label;

+ (MovieOverviewCell*) cellWithMovie:(Movie*) movie model:(BoxOfficeModel*) model frame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier;
+ (CGFloat) heightForMovie:(Movie*) movie model:(BoxOfficeModel*) model;

@end
