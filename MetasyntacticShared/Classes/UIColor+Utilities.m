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

#import "UIColor+Utilities.h"


@implementation UIColor(UIColorUtilities)

- (CGColorSpaceModel) colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}


- (CGFloat) red {
  const CGFloat* c = CGColorGetComponents(self.CGColor);
	return c[0];
}


- (CGFloat) green {
  const CGFloat* c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) {
    return c[0];
  } else {
    return c[1];
  }
}


- (CGFloat) blue {
  const CGFloat* c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) {
    return c[0];
  } else {
    return c[2];
  }
}


- (CGFloat) alpha {
	const CGFloat* c = CGColorGetComponents(self.CGColor);
	return c[CGColorGetNumberOfComponents(self.CGColor)-1];
}


- (NSString*) toHexString {
  CGFloat a = MIN(MAX(self.alpha, 0), 1);
  CGFloat r = MIN(MAX(self.red, 0), 1);
	CGFloat g = MIN(MAX(self.green, 0), 1);
	CGFloat b = MIN(MAX(self.blue, 0), 1);

	// Convert to hex string between 0x00 and 0xFF
	return [NSString stringWithFormat:@"0x%02X%02X%02X%02X",
          (int)(a * 255), (int)(r * 255), (int)(g * 255), (int)(b * 255)];
}


BOOL validChar(unichar c) {
  return (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') || (c >= '0' && c <= '9');
}


NSInteger intValue(unichar c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  } else if (c >= 'A' && c <= 'F') {
    return (c - 'A') + 10;
  } else {
    return (c - 'a') + 10;
  }
}


NSInteger getColor(NSString* string, NSInteger start) {
  unichar c1 = [string characterAtIndex:start];
  unichar c2 = [string characterAtIndex:start + 1];

  if (validChar(c1) && validChar(c2)) {
    return intValue(c1) << 4 | intValue(c2);
  }

  return -1;
}


+ (UIColor*) fromHexString:(NSString*) string {
  if (string.length == 0) {
    return nil;
  }

  if (![string hasPrefix:@"0x"] &&
      ![string hasPrefix:@"0X"]) {
    return nil;
  }

  string = [string substringFromIndex:2];
  if (string.length == 6) {
    //rgb
    NSInteger red, green, blue;
    if ((red  = getColor(string, 0)) == -1 ||
        (green = getColor(string, 2)) == -1 ||
        (blue  = getColor(string, 4)) == -1) {
      return nil;
    }
    return RGBUIColor(red, green, blue);
  } else if (string.length == 8) {
    //argb
    NSInteger red, green, blue, alpha;
    if ((alpha = getColor(string, 0)) == -1 ||
        (red   = getColor(string, 2)) == -1 ||
        (green = getColor(string, 4)) == -1 ||
        (blue  = getColor(string, 6)) == -1) {
      return nil;
    }
    return RGBAUIColor(red, green, blue, alpha);
  } else {
    return nil;
  }
}

@end
