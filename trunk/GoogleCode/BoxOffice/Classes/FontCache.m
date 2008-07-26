//
//  FontCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FontCache.h"

@implementation FontCache

static UIFont* helvetica14 = nil;
static UIFont* boldSystem11 = nil;
static UIFont* boldSystem18 = nil;
static UIFont* boldSystem19 = nil;

+ (void) initialize {
    if (self == [FontCache class]) {
        helvetica14 = [[UIFont fontWithName:@"helvetica" size:14] retain];
        boldSystem11 = [[UIFont boldSystemFontOfSize:11] retain];
        boldSystem18 = [[UIFont boldSystemFontOfSize:18] retain];
        boldSystem19 = [[UIFont boldSystemFontOfSize:20] retain];
    }
}

+ (UIFont*) helvetica14 {
    return helvetica14;
}

+ (UIFont*) boldSystem11 {
    return boldSystem11;
}

+ (UIFont*) boldSystem18 {
    return boldSystem18;
}

+ (UIFont*) boldSystem19 {
    return boldSystem19;
}

@end
