// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ColorCache.h"

@implementation ColorCache

static UIColor* commandColor = nil;
static UIColor* darkDarkGray = nil;
static UIColor* footerColor = nil;

+ (void) initialize {
    if (self == [ColorCache class]) {

        commandColor = [[UIColor colorWithRed:0.196 green:0.309 blue:0.521 alpha:1] retain];
        darkDarkGray = [[UIColor colorWithWhite:0.1666666666666 alpha:1] retain];
        footerColor  = [[UIColor colorWithRed:76.0 / 255.0 green:86.0 / 255.0 blue:107.0 / 255.0 alpha:1] retain];
    }
}


+ (UIColor*) commandColor {
    return commandColor;
}


+ (UIColor*) darkDarkGray {
    return darkDarkGray;
}


+ (UIColor*) footerColor {
    return footerColor;
}


@end