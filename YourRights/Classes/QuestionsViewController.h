//
//  QuestionsViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface QuestionsViewController : UITableViewController {
@private
    NSString* sectionTitle;
    NSArray* questions;
}

- (id) initWithSectionTitle:(NSString*) sectionTitle;

@end
