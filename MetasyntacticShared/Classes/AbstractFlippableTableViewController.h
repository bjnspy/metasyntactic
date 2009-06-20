//
//  AbstractFlippableTableViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractTableViewController.h"

@interface AbstractFlippableTableViewController : AbstractTableViewController {
@protected
  NSInteger pageCount;
  NSInteger currentPageIndex;
}

@end
