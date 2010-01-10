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

#import "AbstractPersonPosterDownloader.h"

#import "Application.h"
#import "WikipediaCache.h"

@implementation AbstractPersonPosterDownloader

- (NSArray*) determineImageAddresses:(Person*) person AbstractMethod;


- (NSData*) pickBestImage:(NSArray*) imageAddresses {
  NSData* fallback = nil;

  // First, try to find a portrait.
  for (NSString* imageAddress in imageAddresses) {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:imageAddress];
    UIImage* image = [UIImage imageWithData:data];
    if (image.size.height >= 140) {
      if (image.size.height > image.size.width) {
        return data;
      } else if (fallback != nil) {
        fallback = data;
      }
    }
  }

  // Or fallback to anything that's large enough.
  return fallback;
}


- (NSData*) download:(Person*) person {
  NSArray* imageAddresses = [self determineImageAddresses:person];
  return [self pickBestImage:imageAddresses];
}

@end
