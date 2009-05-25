//
//  SmallPosterCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SmallPosterCache.h"

@interface SmallPosterCache()
@property (retain) NSMutableDictionary* titleToPosterMap;
@end


@implementation SmallPosterCache

@synthesize titleToPosterMap;

- (void) dealloc {
  self.titleToPosterMap = nil;
  [super dealloc];
}


- (id) init {
  if (self = [super init]) {
    self.titleToPosterMap = [NSMutableDictionary dictionary];
  }
  
  return self;
}


+ (SmallPosterCache*) cache {
  return [[[SmallPosterCache alloc] init] autorelease];
}


- (void) didReceiveMemoryWarning {
  [dataGate lock];
  {
    [titleToPosterMap removeAllObjects];
  }
  [dataGate unlock];
}


- (void) setPoster:(UIImage*) poster forTitle:(NSString*) title {
  [dataGate lock];
  {
    [titleToPosterMap setObject:poster forKey:title];
  }
  [dataGate unlock];
}


- (UIImage*) posterForTitle:(NSString*) title {
  UIImage* result;
  [dataGate lock];
  {
    result = [titleToPosterMap objectForKey:title];
  }
  [dataGate unlock];
  return result;
}

@end
