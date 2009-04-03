//
//  CollectionUtilities.m
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 4/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CollectionUtilities.h"

@implementation CollectionUtilities

+ (NSDictionary*) nonNilDictionary:(NSDictionary*) dictionary {
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }
    
    return dictionary;
}


+ (NSArray*) nonNilArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }
    
    return array;
}

@end