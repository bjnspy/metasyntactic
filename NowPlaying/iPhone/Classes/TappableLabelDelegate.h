//
//  TappableLabelDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol TappableLabelDelegate
- (void) label:(TappableLabel*) label
     wasTapped:(NSInteger) tapCount;
@end
