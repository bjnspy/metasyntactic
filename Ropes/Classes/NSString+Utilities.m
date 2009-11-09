//
//  NSString+Utilities.m
//  Ropes
//
//  Created by Cyrus Najmabadi on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utilities.h"


@implementation NSString(Utilities)

+ (NSString*) stringWithCharacter:(unichar) character {
  return [self stringWithCharacters:&character length:1];
}

@end
