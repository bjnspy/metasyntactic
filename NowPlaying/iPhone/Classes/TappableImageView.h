//
//  TappableImageView.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface TappableImageView : UIImageView {
    id<TappableImageViewDelegate> tapDelegate;
}

@property (assign) id<TappableImageViewDelegate> tapDelegate;

- (id) initWithImage:(UIImage*) image;

@end
