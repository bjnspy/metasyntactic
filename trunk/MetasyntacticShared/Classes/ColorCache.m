// Copyright 2010 Cyrus Najmabadi
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

#import "UIColor+Utilities.h"

@implementation ColorCache

static UIColor* darkDarkGray = nil;
static UIColor* commandColor = nil;
static UIColor* footerColor = nil;
static UIColor* netflixRed = nil;
static UIColor* starYellow = nil;
static UIColor* tintColor = nil;
static UIColor* helpBlue = nil;
static UIColor* lightPurple = nil;

+ (void) initialize {
  if (self == [ColorCache class]) {
    commandColor    = [[UIColor colorWithRed:0.196f green:0.309f blue:0.521f alpha:1.f] retain];
    darkDarkGray    = [[UIColor colorWithWhite:0.1666666666666f alpha:1.f] retain];
    footerColor     = [RGBUIColor(76, 86, 107) retain];
    tintColor       = [RGBUIColor(27, 55, 89) retain];
    netflixRed      = [RGBUIColor(44, 13, 14) retain];
    starYellow      = [RGBUIColor(255, 220, 40) retain];
    helpBlue        = [RGBUIColor(219, 226, 237) retain];
    lightPurple     = [RGBUIColor(154, 125, 125) retain];
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


+ (UIColor*) starYellow {
  return starYellow;
}


+ (UIColor*) helpBlue {
  return helpBlue;
}


+ (UIColor*) lightPurple {
  return lightPurple;
}

@end
