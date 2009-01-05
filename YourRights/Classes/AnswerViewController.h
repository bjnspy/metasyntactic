//
//  AnswerViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AnswerViewController : UITableViewController {
@private
    NSString* question;
    NSString* answer;
}

- (id) initWithQuestion:(NSString*) question answer:(NSString*) answer;

@end

