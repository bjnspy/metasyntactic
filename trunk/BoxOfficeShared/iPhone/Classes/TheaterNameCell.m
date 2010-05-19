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

#import "TheaterNameCell.h"

#import "FavoriteTheaterCache.h"
#import "Model.h"
#import "Theater.h"

@implementation TheaterNameCell

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleSubtitle
                   reuseIdentifier:reuseIdentifier])) {
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumFontSize = 12;

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  return self;
}


- (void) setTheater:(Theater*) theater {
  if ([[FavoriteTheaterCache cache] isFavoriteTheater:theater]) {
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", [StringUtilities starString], theater.name];
  } else {
    self.textLabel.text = theater.name;
  }

  self.detailTextLabel.text = [[Model model] simpleAddressForTheater:theater];
}

@end
