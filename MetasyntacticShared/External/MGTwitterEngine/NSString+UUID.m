//
//  NSString+UUID.m
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 16/09/2007.
//  Copyright 2008 Instinctive Code.
//

#import "NSString+UUID.h"


@implementation NSString (UUID)


+ (NSString*)stringWithNewUUID
{
  // Create a new UUID
  CFUUIDRef uuidObj = CFAutoRelease(CFUUIDCreate(nil));

  // Get the string representation of the UUID
  NSString* newUUID = CFAutoRelease(CFUUIDCreateString(nil, uuidObj));
  
  return newUUID;
}


@end