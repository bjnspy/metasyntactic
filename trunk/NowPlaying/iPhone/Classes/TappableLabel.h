//
//  TappableLabel.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface TappableLabel : UILabel {
@private
    id<TappableLabelDelegate> delegate;
}

@property (retain) id<TappableLabelDelegate> delegate;

@end