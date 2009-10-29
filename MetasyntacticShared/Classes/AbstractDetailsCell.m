//
//  AbstractDetailsCell.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractDetailsCell.h"


@implementation AbstractDetailsCell

- (id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString*) identifier {
  if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  return self;
}


- (CGFloat) height:(UITableView*) tableView {
  return tableView.rowHeight;
}

@end
