//
//  WarningView.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 9/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface WarningView : UIView {
    UIImageView* imageView;
    UILabel* label;
}

@property (retain) UIImageView* imageView;
@property (retain) UILabel* label;

+ (WarningView*) view:(NSString*) text;

- (CGFloat) height;

@end
