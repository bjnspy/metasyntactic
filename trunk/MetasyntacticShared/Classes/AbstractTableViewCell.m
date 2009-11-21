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


- (id) initWithStyle:(UITableViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier
 tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.tableViewController = tableViewController_;
  }
  return self;
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
