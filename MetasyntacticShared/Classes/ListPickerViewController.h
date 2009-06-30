//
//  ListPickerViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractFullScreenTableViewController.h"

@interface ListPickerViewController : AbstractFullScreenTableViewController {
@private
  NSArray* items;
  id<ListPickerDelegate> delegate;
}

@property (assign) id<ListPickerDelegate> delegate;

+ (ListPickerViewController*) controllerWithTitle:(NSString*) title items:(NSArray*) items;

@end
