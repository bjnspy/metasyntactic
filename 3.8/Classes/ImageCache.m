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

#import "ImageCache.h"

@interface ImageCache()
@property (retain) NSMutableDictionary* pathToImageMap;
@end


@implementation ImageCache

@synthesize pathToImageMap;

- (void) dealloc {
  self.pathToImageMap = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.pathToImageMap = [NSMutableDictionary dictionary];
  }

  return self;
}


+ (ImageCache*) cache {
  return [[[ImageCache alloc] init] autorelease];
}


- (void) didReceiveMemoryWarning {
  [dataGate lock];
  {
    [pathToImageMap removeAllObjects];
  }
  [dataGate unlock];
}


- (void) setImage:(UIImage*) image forPath:(NSString*) path {
  if (image == nil) {
    return;
  }

  CGSize size = image.size;
  if (size.width >= 300 || size.height >= 300) {
    return;
  }

  [dataGate lock];
  {
    if (pathToImageMap.count > 200) {
      [pathToImageMap removeAllObjects];
    }
    [pathToImageMap setObject:image forKey:path];
  }
  [dataGate unlock];
}


- (UIImage*) imageForPathWorker:(NSString*) path
                   loadFromDisk:(BOOL) loadFromDisk {
  UIImage* result = [pathToImageMap objectForKey:path];
  if (result == nil && loadFromDisk) {
    result = [UIImage imageWithContentsOfFile:path];
    [self setImage:result forPath:path];
  }

  return result;
}


- (UIImage*) imageForPath:(NSString*) path
             loadFromDisk:(BOOL) loadFromDisk {
  if (path.length == 0) {
    return nil;
  }

  UIImage* result;
  [dataGate lock];
  {
    result = [self imageForPathWorker:path
                         loadFromDisk:loadFromDisk];
  }
  [dataGate unlock];
  return result;
}


- (UIImage*) imageForPath:(NSString*) path {
  return [self imageForPath:path loadFromDisk:YES];
}

@end
