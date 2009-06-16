//
//  PersistentThreadsafeValue.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadsafeValue.h"

@interface PersistentThreadsafeValue : ThreadsafeValue {
@private
  NSString* file;
}

+ (PersistentThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                        file:(NSString*) file;

@end
