//
//  NSArray+Utilities.h
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NSArray(NSArrayUtilities)
- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*)) comparator
                          context:(void*) context;

- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                         context1:(void*) context1
                         context2:(void*) context2;
@end