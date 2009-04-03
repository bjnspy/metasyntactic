//
//  NSArray+Utilities.m
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Utilities.h"


@implementation NSArray(NSArrayUtilities)

- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*)) comparator
                          context:(void*) context {
    if (self.count == 0) {
        return nil;
    }
    
    id value = [self objectAtIndex:0];
    
    for (NSInteger i = 1; i < self.count; i++) {
        id current = [self objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;
}


- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                         context1:(void*) context1
                         context2:(void*) context2 {
    if (self.count == 0) {
        return nil;
    }
    
    id value = [self objectAtIndex:0];
    
    for (NSInteger i = 1; i < self.count; i++) {
        id current = [self objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context1, context2);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;
}

@end