//
//  FAQViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractFullScreenTableViewController.h"

@interface FAQViewController : AbstractFullScreenTableViewController
#ifdef IPHONE_OS_VERSION_3
<MFMailComposeViewControllerDelegate>
#endif
{
@private
    NSArray* questions;
    NSArray* answers;
    ActionsView* actionsView;
}

@end