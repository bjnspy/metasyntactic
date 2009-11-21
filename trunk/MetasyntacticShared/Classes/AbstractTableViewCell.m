//
//  AbstractTableViewCell.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
