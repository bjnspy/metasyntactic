//
//  ImageUtilities.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.

@interface ImageUtilities : NSObject {
}

+ (UIImage*) scaleImage:(UIImage*) image toSize:(CGSize) size;
+ (UIImage*) scaleImage:(UIImage*) image toHeight:(CGFloat) height;

+ (NSData*) scaleImageData:(NSData*) image toHeight:(CGFloat) height;

@end
