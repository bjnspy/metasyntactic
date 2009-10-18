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

UIImage* BoxOfficeStockImage(NSString* name);

@interface BoxOfficeStockImages : MetasyntacticStockImages {
}

+ (UIImage*) freshImage;
+ (UIImage*) rottenFadedImage;
+ (UIImage*) rottenFullImage;

+ (UIImage*) whiteStar;

+ (UIImage*) emptyStarImage;
+ (UIImage*) filledYellowStarImage;
+ (UIImage*) redStar_0_5_Image;
+ (UIImage*) redStar_1_5_Image;
+ (UIImage*) redStar_2_5_Image;
+ (UIImage*) redStar_3_5_Image;
+ (UIImage*) redStar_4_5_Image;
+ (UIImage*) redStar_5_5_Image;

+ (UIImage*) searchImage;

+ (UIImage*) redRatingImage;
+ (UIImage*) yellowRatingImage;
+ (UIImage*) greenRatingImage;
+ (UIImage*) unknownRatingImage;

+ (UIImage*) imageLoading;
+ (UIImage*) imageLoadingNeutral;
+ (UIImage*) imageNotAvailable;

+ (UIImage*) upArrow;
+ (UIImage*) downArrow;
+ (UIImage*) neutralSquare;

+ (UIImage*) warning16x16;
+ (UIImage*) warning32x32;

@end
