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
