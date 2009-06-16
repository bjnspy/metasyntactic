//
//  AbstractPersistentThreadsafeValue.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadsafeValue.h"

@interface AbstractPersistentThreadsafeValue : ThreadsafeValue {
@protected
  NSString* file;
}

/* @protected */
- (id) initWithGate:(id<NSLocking>) gate file:(NSString*) file_;

@end
