// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
