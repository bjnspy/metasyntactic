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

#import "SquareMovieTitleCell.h"

@implementation SquareMovieTitleCell

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
    CGRect frame = CGRectMake(6, 6, 30, 30);
    scoreLabel.font = [FontCache boldSystem19];
    scoreLabel.textColor = [ColorCache darkDarkGray];
    scoreLabel.frame = frame;
  }

  return self;
}

@end
