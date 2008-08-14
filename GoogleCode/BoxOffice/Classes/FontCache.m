// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
