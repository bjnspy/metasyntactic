//
//  TappableScrollView.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface TappableScrollView : UIScrollView {
    id<TappableScrollViewDelegate> tapDelegate;
}

@property (assign) id<TappableScrollViewDelegate> tapDelegate;

@end
