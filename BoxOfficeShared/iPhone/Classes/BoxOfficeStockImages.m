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

#import "BoxOfficeStockImages.h"

NSString* BoxOfficeResourcePath(NSString* name) {
  static NSString* bundleName = @"BoxOfficeResources.bundle.bundle";
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];

  return [NSBundle pathForResource:name ofType:nil inDirectory:bundlePath];
}


UIImage* BoxOfficeStockImage(NSString* name) {
  NSString* path = BoxOfficeResourcePath(name);
  return [MetasyntacticStockImages imageForPath:path];
}

@implementation BoxOfficeStockImages

+ (UIImage*) freshImage {
  return BoxOfficeStockImage(@"Fresh.png");
}


+ (UIImage*) rottenFadedImage {
  return BoxOfficeStockImage(@"Rotten-Faded.png");
}


+ (UIImage*) rottenFullImage {
  return BoxOfficeStockImage(@"Rotten-Full.png");
}


+ (UIImage*) redRatingImage {
  return BoxOfficeStockImage(@"Rating-Red.png");
}


+ (UIImage*) yellowRatingImage {
  return BoxOfficeStockImage(@"Rating-Yellow.png");
}


+ (UIImage*) greenRatingImage {
  return BoxOfficeStockImage(@"Rating-Green.png");
}


+ (UIImage*) unknownRatingImage {
  return BoxOfficeStockImage(@"Rating-Unknown.png");
}


+ (UIImage*) emptyStarImage {
  return BoxOfficeStockImage(@"Empty Star.png");
}


+ (UIImage*) filledYellowStarImage {
  return BoxOfficeStockImage(@"Filled Star.png");
}


+ (UIImage*) redStar_0_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.0.png");
}


+ (UIImage*) redStar_1_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.2.png");
}


+ (UIImage*) redStar_2_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.4.png");
}


+ (UIImage*) redStar_3_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.6.png");
}


+ (UIImage*) redStar_4_5_Image {
  return BoxOfficeStockImage(@"RedStar-0.8.png");
}


+ (UIImage*) redStar_5_5_Image {
  return BoxOfficeStockImage(@"RedStar-1.0.png");
}


+ (UIImage*) searchImage {
  return BoxOfficeStockImage(@"Search.png");
}


+ (UIImage*) imageLoading {
  return BoxOfficeStockImage(@"ImageLoading.png");
}


+ (UIImage*) imageLoadingNeutral {
  return BoxOfficeStockImage(@"ImageLoading-Neutral.png");
}


+ (UIImage*) imageNotAvailable {
  return BoxOfficeStockImage(@"ImageNotAvailable.png");
}


+ (UIImage*) upArrow {
  return BoxOfficeStockImage(@"UpArrow.png");
}


+ (UIImage*) downArrow {
  return BoxOfficeStockImage(@"DownArrow.png");
}


+ (UIImage*) neutralSquare {
  return BoxOfficeStockImage(@"NeutralSquare.png");
}


+ (UIImage*) warning16x16 {
  return BoxOfficeStockImage(@"Warning-16x16.png");
}


+ (UIImage*) warning32x32 {
  return BoxOfficeStockImage(@"Warning-32x32.png");
}

@end
