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

#import "WikipediaScrapePersonPosterDownloader.h"

#import "Application.h"

@implementation WikipediaScrapePersonPosterDownloader

- (NSString*) mobileAddress:(NSString*) address {
  NSRange range = [address rangeOfString:@"en.wikipedia.org"];
  if (range.length <= 0) {
    return nil;
  }

  return [address stringByReplacingCharactersInRange:range withString:@"en.m.wikipedia.org"];
}


- (NSArray*) scrapePage:(NSString*) address {
  if (address.length == 0) {
    return [NSArray array];
  }

  NSMutableArray* result = [NSMutableArray array];

  NSString* contents = [NetworkUtilities stringWithContentsOfAddress:address];
  for (NSInteger i = 0; i < contents.length; i++) {
    NSRange imgRange = [contents rangeOfString:@"<img" options:0 range:NSMakeRange(i, contents.length - i)];
    if (imgRange.length == 0) {
      break;
    }
    NSString* srcText = @"src=\"";
    NSRange srcRange = [contents rangeOfString:srcText options:0 range:NSMakeRange(imgRange.location, contents.length - imgRange.location)];
    if (srcRange.length > 0) {
      NSInteger searchIndex = srcRange.location + [@"src=\"" length];
      NSRange endQuoteRange = [contents rangeOfString:@"\"" options:0 range:NSMakeRange(searchIndex, contents.length - searchIndex)];
      if (endQuoteRange.length > 0) {
        NSString* subString = [contents substringWithRange:NSMakeRange(searchIndex, endQuoteRange.location - searchIndex)];

        if (![result containsObject:subString]) {
          [result addObject:subString];
        }
      }
    }

    i = imgRange.location + 1;
  }

  return result;
}


- (NSArray*) determineImageAddresses:(Person*) person
                    wikipediaAddress:(NSString*) wikipediaAddress {
  NSArray* result = nil;
  if ((result = [self scrapePage:[self mobileAddress:wikipediaAddress]]).count > 0 ||
      (result = [self scrapePage:wikipediaAddress]).count > 0) {
    return result;
  }

  return nil;
}

@end
