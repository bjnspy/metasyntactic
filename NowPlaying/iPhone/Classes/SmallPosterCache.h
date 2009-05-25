//
//  SmallPosterCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface SmallPosterCache : AbstractCache {
@private
  NSMutableDictionary* titleToPosterMap;
}

+ (SmallPosterCache*) cache;

- (void) setPoster:(UIImage*) image forTitle:(NSString*) title;
- (UIImage*) posterForTitle:(NSString*) title;

@end
