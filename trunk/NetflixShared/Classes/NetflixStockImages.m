//
//  NetflixStockImages.m
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixStockImages.h"

NSString* NetflixResourcePath(NSString* name) {
  static NSString* bundleName = @"NetflixResources.bundle";
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
  
  return [NSBundle pathForResource:name ofType:nil inDirectory:bundlePath];
}


UIImage* NetflixStockImage(NSString* name) {
  NSString* path = NetflixResourcePath(name);
  return [MetasyntacticStockImages imageForPath:path];
}

@implementation NetflixStockImages

@end