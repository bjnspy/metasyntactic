//
//  NSArray+Utilities.m
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Utilities.h"

@implementation NSMutableArray(NSArrayUtilities)

- (void) insertObjects:(NSArray*) array atIndex:(NSInteger) index {
    for (NSInteger i = array.count - 1; i >= 0; i--) {
        [self insertObject:[array objectAtIndex:i] atIndex:index];
    }
}

@end