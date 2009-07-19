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

#import "ImageUtilities.h"
#import "MetasyntacticSharedApplication.h"
#import "ThreadingUtilities.h"

@interface ImageCache()
@property (retain) NSMutableDictionary* pathToImageMap;
@property (retain) NSCondition* condition;
@property (retain) NSMutableArray* pathsToFault;
@end


@implementation ImageCache

@synthesize pathToImageMap;
@synthesize condition;
@synthesize pathsToFault;

- (void) dealloc {
  self.pathToImageMap = nil;
  self.condition = nil;
  self.pathsToFault = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.condition = [[[NSCondition alloc] init] autorelease];
    self.pathToImageMap = [NSMutableDictionary dictionary];
    self.pathsToFault = [NSMutableArray array];

    [ThreadingUtilities backgroundSelector:@selector(faultBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                    daemon:YES];
  }

  return self;
}


+ (ImageCache*) cache {
  return [[[ImageCache alloc] init] autorelease];
}


- (void) clearNoLock {
  [pathToImageMap removeAllObjects];
  imageCount = 0;

  [condition lock];
  {
    [pathsToFault removeAllObjects];
  }
  [condition unlock];
}


- (void) didReceiveMemoryWarning {
  [dataGate lock];
  {
    [self clearNoLock];
  }
  [dataGate unlock];
}


- (BOOL) objectIsImage:(id) object {
  return object != nil && object != [NSNull null];
}


- (void) setObject:(id) object forPath:(NSString*) path {
  [dataGate lock];
  {
    if ([self objectIsImage:object]) {
      if ([pathToImageMap objectForKey:path] != nil) {
        imageCount++;

        if (imageCount > 200) {
          [self clearNoLock];
        }
      }
    }

    if (object == nil) {
      [pathToImageMap removeObjectForKey:path];
    } else {
      [pathToImageMap setObject:object forKey:path];
    }
  }
  [dataGate unlock];
}


- (void) setImage:(UIImage*) image forPath:(NSString*) path {
  if (image != nil) {
    // don't store images past a certain size.
    CGSize size = image.size;
    if (size.width >= 300 || size.height >= 300) {
      return;
    }
  }

  [self setObject:image forPath:path];
}


- (UIImage*) imageForPathWorker:(NSString*) path
                   loadFromDisk:(BOOL) loadFromDisk {
  id result = [[[pathToImageMap objectForKey:path] retain] autorelease];
  if ([self objectIsImage:result]) {
    return result;
  }

  if (loadFromDisk) {
    result = [UIImage imageWithContentsOfFile:path];
    [self setImage:result forPath:path];
    return result;
  }

  return nil;
}


- (UIImage*) imageForPathWorker:(NSString*) path
                          fault:(BOOL) fault {
  id result = [[[pathToImageMap objectForKey:path] retain] autorelease];
  if ([self objectIsImage:result]) {
    return result;
  }

  if (result == [NSNull null]) {
    // we're already faulting it in.
    return nil;
  }

  if (fault) {
    [self setObject:[NSNull null] forPath:path];
    [condition lock];
    {
      [pathsToFault addObject:path];
      [condition signal];
    }
    [condition unlock];
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


- (UIImage*) imageForPath:(NSString*) path
                    fault:(BOOL) fault {
  if (path.length == 0) {
    return nil;
  }

  UIImage* result;
  [dataGate lock];
  {
    result = [self imageForPathWorker:path
                                fault:fault];
  }
  [dataGate unlock];
  return result;
}


- (void) faultBackgroundEntryPointWorker {
  NSString* path = nil;
  [condition lock];
  {
    while (pathsToFault.count == 0) {
      [condition wait];
    }

    path = [[pathsToFault.lastObject retain] autorelease];
    [pathsToFault removeLastObject];
  }
  [condition unlock];

  UIImage* image = [self imageForPath:path loadFromDisk:YES];
  image = [ImageUtilities faultImage:image];
  [self setImage:image forPath:path];

  [MetasyntacticSharedApplication minorRefresh];
}


- (void) faultBackgroundEntryPoint {
  while (YES) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self faultBackgroundEntryPointWorker];
    }
    [pool release];
  }
}

@end
