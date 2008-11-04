//
//  TappableImageViewDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol TappableImageViewDelegate
- (void) imageView:(TappableImageView*) imageView
         wasTapped:(NSInteger) tapCount;
@end