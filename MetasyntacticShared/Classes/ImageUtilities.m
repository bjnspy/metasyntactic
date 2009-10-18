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

+ (CGContextRef) getBitmapContext:(CGSize) size {
  CGColorSpaceRef colorSpace = CFAutoRelease(CGColorSpaceCreateDeviceRGB());

  return CFAutoRelease(CGBitmapContextCreate(NULL,
                                    round(size.width),
                                    round(size.height),
                                    8,
                                    4 * round(size.width),
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst));
}


+ (CFIndex) bitmapDataLength:(CGContextRef) context {
  return CGBitmapContextGetHeight(context) * CGBitmapContextGetBytesPerRow(context);
}


+ (UIImage*) scaleImage:(UIImage*) image toSize:(CGSize) size {
  if (image == nil) {
    return nil;
  }

  CGContextRef context = [self getBitmapContext:size];
  CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
  CGImageRef imageRef = CFAutoRelease(CGBitmapContextCreateImage(context));
  
  return [UIImage imageWithCGImage:imageRef];
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

  return UIImageJPEGRepresentation(result, 0.75);
}


+ (UIImage*) cropImage:(UIImage*) image toRect:(CGRect) rect {
  if (image == nil) {
    return nil;
  }

  UIImage* cropped;

  //create a context to do our clipping in
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  {
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect(currentContext, clippedRect);

    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 image.size.width,
                                 image.size.height);

    CGContextSetRGBFillColor(currentContext, 0.75, 0.75, 0.75, 1);
    CGContextFillRect(currentContext, clippedRect);

    CGContextTranslateCTM(currentContext, 0.0, drawRect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);

    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, image.CGImage);

    //pull the image from our cropped context
    cropped = UIGraphicsGetImageFromCurrentImageContext();
  }
  //pop the context to get back to the default
  UIGraphicsEndImageContext();

  return cropped;
}

#define RADIUS 9

void upperLeftRoundingFunction(CGContextRef context, CGRect rect) {
  CGContextSaveGState(context);
  {
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;

    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, RADIUS);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 0);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0);

    CGContextClosePath(context);
  }
  CGContextRestoreGState(context);
}


void lowerLeftRoundingFunction(CGContextRef context, CGRect rect) {
  CGContextSaveGState(context);
  {
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;

    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 0);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, RADIUS);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0);

    CGContextClosePath(context);
  }
  CGContextRestoreGState(context);
}


void cornerRoundingFunction(CGContextRef context, CGRect rect) {
  CGContextSaveGState(context);
  {
    CGFloat fw = rect.size.width;
    CGFloat fh = rect.size.height;

    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, RADIUS);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, RADIUS);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, RADIUS);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, RADIUS);

    CGContextClosePath(context);
  }
  CGContextRestoreGState(context);
}


+ (UIImage*) roundCornerOfImage:(UIImage*) image
               roundingFunction:(void (*)(CGContextRef, CGRect)) roundingFunction {
  if (image == nil) {
    return image;
  }

  CGSize size = image.size;
  CGContextRef context = [self getBitmapContext:size];
  
  CGContextBeginPath(context);
  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  roundingFunction(context, rect);
  CGContextClosePath(context);
  CGContextClip(context);
  
  CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
  
  CGImageRef imageMasked = CFAutoRelease(CGBitmapContextCreateImage(context));

  return [UIImage imageWithCGImage:imageMasked];
}


+ (UIImage*) roundUpperLeftCornerOfImage:(UIImage*) image {
  return [self roundCornerOfImage:image
                 roundingFunction:upperLeftRoundingFunction];
}


+ (UIImage*) roundLowerLeftCornerOfImage:(UIImage*) image {
  return [self roundCornerOfImage:image
                 roundingFunction:lowerLeftRoundingFunction];
}


+ (UIImage*) roundCornersOfImage:(UIImage*) image {
  return [self roundCornerOfImage:image
                 roundingFunction:cornerRoundingFunction];
}


+ (UIImage*) faultImage:(UIImage*) image {
  if (image == nil) {
    return nil;
  }

  CGSize size = image.size;
  CGFloat height = round(size.height);
  CGFloat width = round(size.width);

  size_t length = 4 * height * width;
  void* rawData = malloc(length);

  if (rawData == NULL) {
    return image;
  }
  
  CGColorSpaceRef colorSpace = CFAutoRelease(CGColorSpaceCreateDeviceRGB());
  
  CGContextRef context = CFAutoRelease(CGBitmapContextCreate(rawData,
                                                             width,
                                                             height,
                                                             8,
                                                             4 * width,
                                                             colorSpace,
                                                             kCGImageAlphaPremultipliedFirst));
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
  
  CFDataRef data = CFAutoRelease(CFDataCreateWithBytesNoCopy(NULL, rawData, length, kCFAllocatorMalloc));
  CGDataProviderRef dataProvider = CFAutoRelease(CGDataProviderCreateWithCFData(data));
  
  CGImageRef imageRef = CFAutoRelease(CGImageCreate(width,
                                                    height,
                                                    8,
                                                    8 * 4,
                                                    4 * width,
                                                    colorSpace,
                                                    CGBitmapContextGetBitmapInfo(context),
                                                    dataProvider,
                                                    NULL,
                                                    YES,
                                                    kCGRenderingIntentDefault));
  
  return [UIImage imageWithCGImage:imageRef];
}

@end
