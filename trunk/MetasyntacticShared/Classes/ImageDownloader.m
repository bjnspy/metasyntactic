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

#import "ImageDownloader.h"

#import "AbstractApplication.h"
#import "FileUtilities.h"
#import "ImageCache.h"
#import "MetasyntacticSharedApplication.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"

@interface ImageDownloader()
@property (retain) NSCondition* downloadImagesCondition;
@property (retain) NSMutableArray* imagesToDownload;
@property (retain) NSMutableArray* priorityImagesToDownload;
@end


@implementation ImageDownloader

static ImageDownloader* downloader;

+ (void) initialize {
  if (self == [ImageDownloader class]) {
    downloader = [[ImageDownloader alloc] init];
  }
}


+ (ImageDownloader*) downloader {
  return downloader;
}

@synthesize downloadImagesCondition;
@synthesize imagesToDownload;
@synthesize priorityImagesToDownload;

- (void) dealloc {
  self.downloadImagesCondition = nil;
  self.imagesToDownload = nil;
  self.priorityImagesToDownload = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.downloadImagesCondition = [[[NSCondition alloc] init] autorelease];
    self.imagesToDownload = [NSMutableArray array];
    self.priorityImagesToDownload = [NSMutableArray array];

    [ThreadingUtilities backgroundSelector:@selector(downloadImagesBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                    daemon:YES];
  }

  return self;
}


- (NSString*) imagePath:(NSString*) address {
  return [[AbstractApplication imagesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]];
}


- (UIImage*) imageForAddress:(NSString*) address loadFromDisk:(BOOL) loadFromDisk {
  return [[ImageCache cache] imageForPath:[self imagePath:address] loadFromDisk:loadFromDisk];
}


- (UIImage*) imageForAddress:(NSString*) address {
  return [self imageForAddress:address loadFromDisk:YES];
}


- (void) downloadImage:(NSString*) address {
  if (address.length == 0) {
    return;
  }

  NSString* localPath = [self imagePath:address];

  if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
    return;
  }
  
  NSData* data = [NetworkUtilities dataWithContentsOfAddress:address pause:NO];
  if (data != nil) {
    [data writeToFile:localPath atomically:YES];
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (void) downloadImagesBackgroundEntryPoint {
  while (YES) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSString* address = nil;
      [downloadImagesCondition lock];
      {
        while (imagesToDownload.count == 0 && priorityImagesToDownload.count == 0) {
          [downloadImagesCondition wait];
        }

        if (priorityImagesToDownload.count > 0) {
          address = [[priorityImagesToDownload.lastObject retain] autorelease];
          [priorityImagesToDownload removeLastObject];
        } else {
          address = [[imagesToDownload.lastObject retain] autorelease];
          [imagesToDownload removeLastObject];
        }
      }
      [downloadImagesCondition unlock];

      [self downloadImage:address];
    }
    [pool release];
  }
}


- (void) addAddressesToDownload:(NSArray*) addresses {
  [downloadImagesCondition lock];
  {
    for (NSInteger i = addresses.count - 1; i >= 0; i--) {
      [imagesToDownload addObject:[addresses objectAtIndex:i]];
    }
    [downloadImagesCondition broadcast];
  }
  [downloadImagesCondition unlock];
}


- (void) addAddressToDownload:(NSString*) address priority:(BOOL) priority {
  [downloadImagesCondition lock];
  {
    if (priority) {
      [priorityImagesToDownload addObject:address];
    } else {
      [imagesToDownload addObject:address];
    } 
    [downloadImagesCondition broadcast];
  }
  [downloadImagesCondition unlock];
}


- (void) addAddressToDownload:(NSString*) address {
  [self addAddressToDownload:address priority:NO];
}

@end
