//
//  Utilities.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface Utilities : NSObject {
    
}

+ (BOOL) isNilOrEmpty:(NSString*) string;

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void *)) comparator
                          context:(void*) context;

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                          context1:(void*) context1
                          context2:(void*) context2;

@end
