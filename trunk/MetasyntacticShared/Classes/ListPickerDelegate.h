//
//  ListPickerDelegate.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol ListPickerDelegate
- (void) onListPickerCancel;
- (void) onListPickerSave:(id) value;
@end
