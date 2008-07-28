//
//  ColorCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ColorCache.h"


@implementation ColorCache

static UIColor* commandColor = nil;
static UIColor* darkDarkGray = nil;

+ (void) initialize {
    if (self == [ColorCache class]) {

        commandColor = [[UIColor colorWithRed:0.196 green:0.309 blue:0.521 alpha:1] retain];
        darkDarkGray = [[UIColor colorWithWhite:0.1666666666666 alpha:1] retain];
    }
}

+ (UIColor*) commandColor {
    return commandColor;
}

+ (UIColor*) darkDarkGray {
    return darkDarkGray;
}

@end
