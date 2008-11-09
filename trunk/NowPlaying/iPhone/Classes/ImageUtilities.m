//
//  ImageUtilities.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ImageUtilities.h"

@implementation ImageUtilities

+ (UIImage*) scaleImage:(UIImage*) image toSize:(CGSize) size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


+ (UIImage*) scaleImage:(UIImage*) image toHeight:(CGFloat) height {
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width * (height / imageSize.height);
    CGSize resultSize = CGSizeMake(width, height);
    return [self scaleImage:image toSize:resultSize];
}

@end