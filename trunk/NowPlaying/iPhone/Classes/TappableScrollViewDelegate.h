//
//  TappableScrollViewDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol TappableScrollViewDelegate
- (void) scrollView:(TappableScrollView*) scrollView
          wasTapped:(NSInteger) tapCount
            atPoint:(CGPoint) point;
@end