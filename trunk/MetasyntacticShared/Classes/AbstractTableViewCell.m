// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      s_groupedTableViewMargin = 44;
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
