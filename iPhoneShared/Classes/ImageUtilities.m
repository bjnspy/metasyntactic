// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ImageUtilities.h"

@implementation ImageUtilities

+ (UIImage*) scaleImage:(UIImage*) image toSize:(CGSize) size {
    if (image == nil) {
        return nil;
    }

    CGImageRef cgImage = image.CGImage;
    CGContextRef cgc = CGBitmapContextCreate(NULL,
                                             size.width,
                                             size.height,
                                             CGImageGetBitsPerComponent(cgImage),
                                             CGImageGetBytesPerRow(cgImage),
                                             CGImageGetColorSpace(cgImage),
                                             CGImageGetBitmapInfo(cgImage));
    CGContextDrawImage(cgc, CGRectMake(0, 0, size.width, size.height), cgImage);
    CGImageRef cgi = CGBitmapContextCreateImage(cgc);
    CGContextRelease(cgc);
    UIImage* scaledImage = [[[UIImage alloc] initWithCGImage:cgi] autorelease];
    CGImageRelease(cgi);

    return scaledImage;
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

    if (source.size.height <= height) {
        return data;
    }

    UIImage* result = [self scaleImage:source toHeight:height];
    if (result == nil) {
        return nil;
    }

    return UIImageJPEGRepresentation(result, 0.5);
}

@end