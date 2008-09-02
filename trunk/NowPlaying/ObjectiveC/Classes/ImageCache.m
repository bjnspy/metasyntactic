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

static UIImage* imageNotAvailable = nil;

static UIImage* upArrow = nil;
static UIImage* downArrow = nil;
static UIImage* neutralSquare = nil;

static UIImage* warning16x16 = nil;
static UIImage* warning32x32 = nil;

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

        imageNotAvailable   = [[UIImage imageNamed:@"ImageNotAvailable.png"] retain];

        upArrow             = [[UIImage imageNamed:@"UpArrow.png"] retain];
        downArrow           = [[UIImage imageNamed:@"DownArrow.png"] retain];
        neutralSquare       = [[UIImage imageNamed:@"NeutralSquare.png"] retain];

        warning16x16        = [[UIImage imageNamed:@"Warning-16x16.png"] retain];
        warning32x32        = [[UIImage imageNamed:@"Warning-32x32.png"] retain];
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


+ (UIImage*) imageNotAvailable {
    return imageNotAvailable;
}


+ (UIImage*) upArrow {
    return upArrow;
}


+ (UIImage*) downArrow {
    return downArrow;
}


+ (UIImage*) neutralSquare {
    return neutralSquare;
}


+ (UIImage*) warning16x16 {
    return warning16x16;
}


+ (UIImage*) warning32x32 {
    return warning32x32;
}


@end