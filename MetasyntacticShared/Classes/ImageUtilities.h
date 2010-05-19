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

@interface ImageUtilities : NSObject {
}

+ (UIImage*) faultImage:(UIImage*) image;

+ (UIImage*) scaleImage:(UIImage*) image toSize:(CGSize) size;
+ (UIImage*) scaleImage:(UIImage*) image toHeight:(CGFloat) height;
+ (UIImage*) scaleImage:(UIImage*) image toWidth:(CGFloat) width;

+ (UIImage*) cropImage:(UIImage*) image toRect:(CGRect) rect;
+ (UIImage*) roundUpperLeftCornerOfImage:(UIImage*) image;
+ (UIImage*) roundLowerLeftCornerOfImage:(UIImage*) image;
+ (UIImage*) roundCornersOfImage:(UIImage*) image;
+ (UIImage*) makeGrayscale:(UIImage*) image;

+ (NSData*) scaleImageData:(NSData*) image toHeight:(CGFloat) height;
+ (NSData*) scaleImageData:(NSData*) image toWidth:(CGFloat) width;

@end
