//
//  AbstractTableViewCell.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractTableViewCell : UITableViewCell {
@private
  UITableViewController* tableViewController;
}

@property (assign) UITableViewController* tableViewController;

- (id) initWithStyle:(UITableViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier 
 tableViewController:(UITableViewController*) tableViewController;


- (id) initWithStyle:(UITableViewCellStyle)style
 tableViewController:(UITableViewController*) tableViewController;

- (id) initWithTableViewController:(UITableViewController*) tableViewController;

- (UITableView*) tableView;

@end
