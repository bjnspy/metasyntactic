//
//  untitled.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NSSet(NSSetUtilities)
- (NSSet*) filteredSetUsingFunction:(BOOL(*)(id)) predicate;
@end
