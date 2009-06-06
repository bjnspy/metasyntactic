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


- (UIImage*) imageForPath:(NSString*) path
             loadFromDisk:(BOOL) loadFromDisk {
  if (path.length == 0) {
    return nil;
  }

  UIImage* result;
  [dataGate lock];
  {
    result = [pathToImageMap objectForKey:path];
    if (result == nil && loadFromDisk) {
      result = [UIImage imageWithContentsOfFile:path];
      CGSize size = result.size;
      if (result != nil && size.width < 200 && size.height < 200) {
        [pathToImageMap setObject:result forKey:path];
      }
    }
  }
  [dataGate unlock];
  return result;
}


- (UIImage*) imageForPath:(NSString*) path {
  return [self imageForPath:path loadFromDisk:YES];
}

@end
