//
//  ImageCache.h
//  ComiXologyShared
//
//  Created by Cyrus Najmabadi on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface ImageCache : AbstractCache {
@private
  NSMutableDictionary* pathToImageMap;
}

+ (ImageCache*) cache;

- (UIImage*) imageForPath:(NSString*) path;
- (UIImage*) imageForPath:(NSString*) path loadFromDisk:(BOOL) loadFromDisk;

@end