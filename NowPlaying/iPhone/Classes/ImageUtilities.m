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
    NSAssert([NSThread isMainThread], @"");
    if (image == nil) {
        return nil;
    }

    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}


+ (UIImage*) scaleImage:(UIImage*) image toHeight:(CGFloat) height {
    if (image == nil) {
        return nil;
    }
        
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width * (height / imageSize.height);
    CGSize resultSize = CGSizeMake(width, height);
    return [self scaleImage:image toSize:resultSize];
}


+ (NSData*) scaleImageData:(NSData*) data toHeight:(CGFloat) height {
    if (data.length == 0) {
        return nil;
    }
    
    UIImage* source = [UIImage imageWithData:data];
    if (source == nil) {
        return nil;
    }
    
    UIImage* result = [self scaleImage:source toHeight:height];
    if (result == nil) {
        return nil;
    }

    return UIImagePNGRepresentation(result);
}

@end