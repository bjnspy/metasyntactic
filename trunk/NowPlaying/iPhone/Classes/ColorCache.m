// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ColorCache.h"

@implementation ColorCache

static UIColor* commandColor = nil;
static UIColor* darkDarkGray = nil;
static UIColor* footerColor = nil;
static UIColor* tintColor = nil;
static UIColor* netflixRed = nil;

+ (void) initialize {
    if (self == [ColorCache class]) {

        commandColor = [[UIColor colorWithRed:0.196 green:0.309 blue:0.521 alpha:1] retain];
        darkDarkGray = [[UIColor colorWithWhite:0.1666666666666 alpha:1] retain];
        footerColor  = [[UIColor colorWithRed:76.0 / 255.0 green:86.0 / 255.0 blue:107.0 / 255.0 alpha:1] retain];
        tintColor    = [[UIColor colorWithRed:27.0/255.0 green:55.0/255.0 blue:89.0/255.0 alpha:1] retain];
        netflixRed   = [[UIColor colorWithRed:100.0/255.5 green:14.0/255.0 blue:17.0/255.0 alpha:1] retain];
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


+ (UIColor*) tintColor {
    return tintColor;
}


+ (UIColor*) netflixRed {
    return netflixRed;
}

@end