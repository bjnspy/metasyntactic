//
//  TappableActivityIndicatorView.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TappableActivityIndicatorView : UIActivityIndicatorView {
@private
    id<TappableActivityIndicatorViewDelegate> delegate;
}

@property (assign) id<TappableActivityIndicatorViewDelegate> delegate;

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@end
