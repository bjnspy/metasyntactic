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

#import "FontCache.h"

@implementation FontCache


static UIFont* helvetica14 = nil;
static UIFont* boldSystem11 = nil;
static UIFont* boldSystem18 = nil;
static UIFont* boldSystem19 = nil;
static UIFont* footerFont = nil;


+ (void) initialize {
    if (self == [FontCache class]) {
        helvetica14 = [[UIFont fontWithName:@"helvetica" size:14] retain];
        boldSystem11 = [[UIFont boldSystemFontOfSize:11] retain];
        boldSystem18 = [[UIFont boldSystemFontOfSize:18] retain];
        boldSystem19 = [[UIFont boldSystemFontOfSize:20] retain];
        footerFont   = [[UIFont systemFontOfSize:15] retain];
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


+ (UIFont*) footerFont {
    return footerFont;
}

@end