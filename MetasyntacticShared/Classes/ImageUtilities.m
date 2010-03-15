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
  return CFAutoRelease(CGBitmapContextCreate(NULL,
                                             roundf(size.width),
                                             roundf(size.height),
                                             8,
                                             4 * roundf(size.width),
                                             CFAutoRelease(CGColorSpaceCreateDeviceRGB()),
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


+ (UIImage*) scaleImage:(UIImage*) image toWidth:(CGFloat) width {
  if (image == nil) {
    return nil;
  }
  
  CGSize imageSize = image.size;
  
  CGFloat height = imageSize.height * (width / imageSize.width);
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
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return UIImageJPEGRepresentation(result, 0.9f);
  } else {
    return UIImageJPEGRepresentation(result, 0.5f);
  }
}


+ (NSData*) scaleImageData:(NSData*) data
                   toWidth:(CGFloat) width {
  if (data.length == 0) {
    return nil;
  }
  
  UIImage* source = [UIImage imageWithData:data];
  if (source == nil) {
    return nil;
  }
  
  if (source.size.width <= width) {
    return data;
  }
  
  UIImage* result = [self scaleImage:source toWidth:width];
  if (result == nil) {
    return nil;
  }
  
  return UIImageJPEGRepresentation(result, 0.5f);
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

    CGContextSetRGBFillColor(currentContext, 0.75f, 0.75f, 0.75f, 1.f);
    CGContextFillRect(currentContext, clippedRect);

    CGContextTranslateCTM(currentContext, 0.0f, drawRect.size.height);
    CGContextScaleCTM(currentContext, 1.0f, -1.0f);

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
  CGFloat height = roundf(size.height);
  CGFloat width = roundf(size.width);

  size_t length = 4 * height * width;
  void* rawData = malloc(length);

  if (rawData == NULL) {
    return image;
  }

  CGColorSpaceRef colorSpace = CFAutoRelease(CGColorSpaceCreateDeviceRGB());

  CGContextRef context =
  CFAutoRelease(CGBitmapContextCreate(rawData,
                                      width,
                                      height,
                                      8,
                                      4 * width,
                                      colorSpace,
                                      kCGImageAlphaPremultipliedFirst));

  CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);

  CGDataProviderRef dataProvider =
  CFAutoRelease(CGDataProviderCreateWithCFData(
                                               CFAutoRelease(CFDataCreateWithBytesNoCopy(NULL, rawData, length, kCFAllocatorMalloc))));

  CGImageRef imageRef =
  CFAutoRelease(CGImageCreate(width,
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


+ (UIImage*) makeGrayscale:(UIImage*) source {
  typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
  } PIXELS;

  CGSize size = [source size];
  int width = size.width;
  int height = size.height;

  // the pixels will be painted to this array
  uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));

  // clear the pixels so any transparency is preserved
  memset(pixels, 0, width * height * sizeof(uint32_t));

  CGColorSpaceRef colorSpace = CFAutoRelease(CGColorSpaceCreateDeviceRGB());

  // create a context with RGBA pixels
  CGContextRef context = CFAutoRelease(CGBitmapContextCreate(pixels,
                                               width,
                                               height,
                                               8,
                                               width * sizeof(uint32_t),
                                               colorSpace,
                                               kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast));

  // paint the bitmap to our context which will fill in the pixels array
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), [source CGImage]);

  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      uint8_t* rgbaPixel = (uint8_t*) &pixels[y * width + x];

      uint32_t gray = (uint32_t)(0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE]);

      // set the pixels to gray
      rgbaPixel[RED] = gray;
      rgbaPixel[GREEN] = gray;
      rgbaPixel[BLUE] = gray;
    }
  }

  // create a new CGImageRef from our context with the modified pixels
  CGImageRef image = CFAutoRelease(CGBitmapContextCreateImage(context));

  // we're done with the pixels
  free(pixels);

  return [UIImage imageWithCGImage:image];
}

@end
