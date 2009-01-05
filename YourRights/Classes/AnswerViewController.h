//
//  AnswerViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AnswerViewController : UITableViewController {
@private
    NSString* sectionTitle;
    NSString* question;
    NSString* answer;
    NSArray* links;
}

- (id) initWithSectionTitle:(NSString*) sectionTitle question:(NSString*) question answer:(NSString*) answer;

@end

