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

UIImage* StockImage(NSString* bundle, NSString* name);
UIImage* StockImage1(NSString* bundle, NSString* name, BOOL allowOverride);
UIImage* MetasyntacticStockImage(NSString* name);
UIImage* MetasyntacticStockImage1(NSString* name, BOOL allowOverride);

@interface MetasyntacticStockImages : NSObject {
}

+ (UIImage*) leftArrow;
+ (UIImage*) rightArrow;
+ (UIImage*) standardLeftArrow;
+ (UIImage*) standardRightArrow;

+ (UIImage*) navigateBack;
+ (UIImage*) navigateForward;
+ (UIImage*) directions;

+ (UIImage*) actionButton;
+ (UIImage*) actionButtonRoundLowerRight;

+ (UIImage*) smallActivityBackground;
+ (UIImage*) largeActivityBackground;

+ (UIImage*) expandArrow;
+ (UIImage*) collapseArrow;

/* @protected */
+ (UIImage*) imageForPath:(NSString*) path;

@end
