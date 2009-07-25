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

#import "MetasyntacticStockImages.h"

NSString* MetasyntacticStockImagePath(NSString* name) {
  static NSString* bundleName = @"MetasyntacticStockImages.bundle";
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
  
  return [NSBundle pathForResource:name ofType:nil inDirectory:bundlePath];
}


UIImage* MetasyntacticStockImage(NSString* name) {
  NSString* path = MetasyntacticStockImagePath(name);
  return [MetasyntacticStockImages imageForPath:path];
}


@implementation MetasyntacticStockImages

+ (UIImage*) imageForPath:(NSString*) path {
  static NSString* key = @"StockImages";
  
  NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
  NSMutableDictionary* dictionary = [threadDictionary objectForKey:key];
  if (dictionary == nil) {
    dictionary = [NSMutableDictionary dictionary];
    [threadDictionary setObject:dictionary forKey:key];
  }

  UIImage* result = [dictionary objectForKey:path];
  if (result == nil) {
    result = [UIImage imageWithContentsOfFile:path];
    [dictionary setObject:result forKey:path];
  }
  return result;
}


+ (UIImage*) leftArrow {
  return MetasyntacticStockImage(@"LeftArrow.png");
}


+ (UIImage*) rightArrow {
  return MetasyntacticStockImage(@"RightArrow.png");
}


+ (UIImage*) navigateBack {
  return MetasyntacticStockImage(@"Navigate-Back.png");
}


+ (UIImage*) navigateForward {
  return MetasyntacticStockImage(@"Navigate-Forward.png");
}


+ (UIImage*) directions {
  return MetasyntacticStockImage(@"Directions.png");
}


+ (UIImage*) actionButtonStandard {
  return MetasyntacticStockImage(@"ActionButton-Standard.png");
}


+ (UIImage*) actionButtonRoundLowerRight {
  return MetasyntacticStockImage(@"ActionButton-RoundLowerRight.png");
}


+ (UIImage*) smallActivityBackground {
  return MetasyntacticStockImage(@"SmallActivityBackground.png");
}


+ (UIImage*) largeActivityBackground {
  return MetasyntacticStockImage(@"LargeActivityBackground.png");
}

@end
