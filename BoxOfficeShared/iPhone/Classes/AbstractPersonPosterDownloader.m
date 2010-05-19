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

#import "AbstractPersonPosterDownloader.h"

#import "Application.h"
#import "WikipediaCache.h"

@implementation AbstractPersonPosterDownloader

- (NSArray*) determineImageAddresses:(Person*) person AbstractMethod;


- (NSData*) pickBestImage:(NSArray*) imageAddresses {
  const NSInteger MIN_HEIGHT = 140;

  NSData* fallbackData = nil;

  for (NSString* imageAddress in imageAddresses) {
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:imageAddress];
    UIImage* image = [UIImage imageWithData:data];
    if (image.size.height >= MIN_HEIGHT) {
      if (image.size.height > image.size.width) {
        fallbackData = data;
        break;
      } else if (fallbackData != nil) {
        fallbackData = data;
      }
    }
  }

  // Don't want to save a huge image.  Resize to something more reasonable.
  return [ImageUtilities scaleImageData:fallbackData toWidth:MIN_HEIGHT];
}


- (NSData*) download:(Person*) person {
  NSArray* imageAddresses = [self determineImageAddresses:person];
  return [self pickBestImage:imageAddresses];
}

@end
