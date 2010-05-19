// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
