//
//  PersistentDictionaryThreadsafeValue.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractPersistentThreadsafeValue.h"

@interface PersistentDictionaryThreadsafeValue : AbstractPersistentThreadsafeValue {
}

+ (PersistentDictionaryThreadsafeValue*) valueWithGate:(id<NSLocking>) gate
                                             file:(NSString*) file;

@end
