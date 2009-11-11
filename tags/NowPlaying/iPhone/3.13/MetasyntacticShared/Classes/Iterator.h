//
//  NSEnumerator+Utilities.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Iterator : NSObject {
@private
  NSEnumerator* enumerator;
  id next;
}

+ (Iterator*) iteratorWithEnumerator:(NSEnumerator*) enumerator;

- (BOOL) hasNext;
- (id) next;

@end
