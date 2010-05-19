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
