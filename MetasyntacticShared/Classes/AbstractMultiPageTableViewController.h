//
//  AbstractMultiPageTableViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractTableViewController.h"

@interface AbstractMultiPageTableViewController : AbstractTableViewController {
@protected
  NSInteger pageCount;
  NSInteger currentPageIndex;
  
  NSMutableDictionary* pageToTableView;
}

@end
