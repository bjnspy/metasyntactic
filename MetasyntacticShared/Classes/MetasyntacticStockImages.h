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

+ (UIImage*) standardActionButton;
+ (UIImage*) standardActionButtonRoundLowerRight;

+ (UIImage*) smallActivityBackground;
+ (UIImage*) largeActivityBackground;

+ (UIImage*) expandArrow;
+ (UIImage*) collapseArrow;

/* @protected */
+ (UIImage*) imageForPath:(NSString*) path;

@end
