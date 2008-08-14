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

#import "ImageCache.h"

@implementation ImageCache

static UIImage* freshImage = nil;
static UIImage* rottenFadedImage = nil;
static UIImage* rottenFullImage = nil;
static UIImage* emptyStarImage = nil;
static UIImage* filledStarImage = nil;

static UIImage* redRatingImage = nil;
static UIImage* yellowRatingImage = nil;
static UIImage* greenRatingImage = nil;
static UIImage* unknownRatingImage = nil;

+ (void) initialize {
    if (self == [ImageCache class]) {
        freshImage          = [[UIImage imageNamed:@"Fresh.png"] retain];
        rottenFadedImage    = [[UIImage imageNamed:@"Rotten-Faded.png"] retain];
        rottenFullImage     = [[UIImage imageNamed:@"Rotten-Full.png"] retain];
        emptyStarImage      = [[UIImage imageNamed:@"Empty Star.png"] retain];
        filledStarImage     = [[UIImage imageNamed:@"Filled Star.png"] retain];

        redRatingImage      = [[UIImage imageNamed:@"Rating-Red.png"] retain];
        yellowRatingImage   = [[UIImage imageNamed:@"Rating-Yellow.png"] retain];
        greenRatingImage    = [[UIImage imageNamed:@"Rating-Green.png"] retain];
        unknownRatingImage  = [[UIImage imageNamed:@"Rating-Unknown.png"] retain];
    }
}


+ (UIImage*) freshImage {
    return freshImage;
}


+ (UIImage*) rottenFadedImage {
    return rottenFadedImage;
}


+ (UIImage*) rottenFullImage {
    return rottenFullImage;
}


+ (UIImage*) redRatingImage {
    return redRatingImage;
}


+ (UIImage*) yellowRatingImage {
    return yellowRatingImage;
}


+ (UIImage*) greenRatingImage {
    return greenRatingImage;
}


+ (UIImage*) unknownRatingImage {
    return unknownRatingImage;
}


+ (UIImage*) emptyStarImage {
    return emptyStarImage;
}


+ (UIImage*) filledStarImage {
    return filledStarImage;
}


@end
