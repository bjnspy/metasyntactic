//
//  DeviceUtilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
