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

#import "AbstractTableViewCell.h"


@implementation AbstractTableViewCell

@synthesize tableViewController;

- (void) dealloc {
  self.tableViewController = nil;
  [super dealloc];
}

static NSInteger s_groupedTableViewMargin;

+ (void) initialize {
  if (self == [AbstractTableViewCell class]) {
    if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
      s_groupedTableViewMargin = 45;
    } else {
      s_groupedTableViewMargin = 10;
    }
  }
}


+ (NSInteger) groupedTableViewMargin {
  return s_groupedTableViewMargin;
}


- (id) initWithStyle:(UITableViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier
 tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [self initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.tableViewController = tableViewController_;
    groupedTableViewMargin = s_groupedTableViewMargin;
  }

  return self;
}


- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController_ {
  return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier tableViewController:tableViewController_];
}


- (id) initWithStyle:(UITableViewCellStyle)style
 tableViewController:(UITableViewController*) tableViewController_ {
  return [self initWithStyle:style reuseIdentifier:nil tableViewController:tableViewController_];
}


- (id) initWithTableViewController:(UITableViewController*) tableViewController_ {
  return [self initWithStyle:UITableViewCellStyleDefault tableViewController:tableViewController_];
}


- (UITableView*) tableView {
  return tableViewController.tableView;
}

@end
