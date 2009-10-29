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

#import "FileUtilities.h"

NSString* PathForName(NSString* bundle, NSString* name) {
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundle ofType:nil];

  return [NSBundle pathForResource:name ofType:nil inDirectory:bundlePath];
}

NSMutableDictionary* GetThreadLocalDictionary(NSString* key) {
  NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
  NSMutableDictionary* dictionary = [threadDictionary objectForKey:key];
  if (dictionary == nil) {
    dictionary = [NSMutableDictionary dictionary];
    [threadDictionary setObject:dictionary forKey:key];
  }

  return dictionary;
}


NSString* StockImagePathForName(NSString* bundle, NSString* name) {
  NSMutableDictionary* threadDictionary = GetThreadLocalDictionary(@"StockImagePaths");

  NSString* key = [NSString stringWithFormat:@"%@-%@", bundle, name];
  
  id result = [threadDictionary objectForKey:key];
  if (result == nil) {
    result = PathForName(bundle, name);
    if (result == nil) {
      result = [NSNull null];
    }
    [threadDictionary setObject:result forKey:key];
  }

  if (result == [NSNull null]) {
    return nil;
  }
  
  return result;
}


UIImage* StockImage(NSString* bundle, NSString* name) {
  NSString* overrideBundle = [NSString stringWithFormat:@"%@-Override.bundle", bundle];
  NSString* normalBundle = [NSString stringWithFormat:@"%@.bundle", bundle];
  NSString* bundles[] = { overrideBundle, normalBundle };
  
  for (NSInteger i = 0; i < ArrayLength(bundles); i++) {
    NSString* path = StockImagePathForName(bundles[i], name);
    UIImage* result = [MetasyntacticStockImages imageForPath:path];
    if (result != nil) {
      return result;
    }
  }
  
  return nil;
}


UIImage* MetasyntacticStockImage(NSString* name) {
  return StockImage(@"MetasyntacticResources", name);
}


@implementation MetasyntacticStockImages

+ (UIImage*) imageForPath:(NSString*) path {
  if (path.length == 0) {
    return nil;
  }

  NSMutableDictionary* threadDictionary = GetThreadLocalDictionary(@"StockImages");

  id result = [threadDictionary objectForKey:path];
  if (result == nil) {
    result = [UIImage imageWithContentsOfFile:path];
    if (result == nil) {
      result = [NSNull null];
    }
    [threadDictionary setObject:result forKey:path];
  }
  
  if (result == [NSNull null]) {
    return nil;
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


+ (UIImage*) expandArrow {
  return MetasyntacticStockImage(@"ExpandArrow.png");
}


+ (UIImage*) collapseArrow {
  return MetasyntacticStockImage(@"CollapseArrow.png");
  
}

@end
