//
//  UpdatingListingsViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface UpdatingListingsViewController : UIViewController {
@private
    id target;
    SEL selector;
}

- (id) initWithTarget:(id) target
             selector:(SEL) selector;

@end
