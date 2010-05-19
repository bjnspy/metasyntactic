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

#import "DeviceUtilities.h"

#include <sys/sysctl.h>

@implementation DeviceUtilities

+ (BOOL) isIPhone {
  UIDevice* device = [UIDevice currentDevice];
  return [[device model] isEqual:@"iPhone"];
}


+ (NSString*) hardware {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char* machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString* hardware = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
  free(machine);
  return hardware;
}


+ (BOOL) isIPhone3G {
  if (![self isIPhone]) {
    return NO;
  }

  NSString* hardware = [self hardware];
  return [hardware hasPrefix:@"iPhone1"];
}

@end
