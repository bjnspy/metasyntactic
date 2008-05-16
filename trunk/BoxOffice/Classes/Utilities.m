//
//  Utilities.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (BOOL) isNilOrEmpty:(NSString*) string {
    return string == nil || [@"" isEqual:string];
}

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void *)) comparator
                          context:(void*) context {
    if ([array count] == 0) {
        return nil;
    }
    
    id value = [array objectAtIndex:0];
    
    for (NSInteger i = 1; i < [array count]; i++) {
        id current = [array objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;
}

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                         context1:(void*) context1
                         context2:(void*) context2 {
    if ([array count] == 0) {
        return nil;
    }
    
    id value = [array objectAtIndex:0];
    
    for (NSInteger i = 1; i < [array count]; i++) {
        id current = [array objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context1, context2);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;    
}

@end
