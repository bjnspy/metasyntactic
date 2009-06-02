//
//  ProtectedValue.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 6/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ThreadsafeValue : NSObject {
@private
  id delegate;
  id<NSLocking> gate;
  SEL loadSelector;
  SEL saveSelector;
  
  id valueData;
}

+ (ThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                         delegate:(id) delegate
                     loadSelector:(SEL) loadSelector
                     saveSelector:(SEL) saveSelector;


- (id) value;
- (void) setValue:(id) value;

@end