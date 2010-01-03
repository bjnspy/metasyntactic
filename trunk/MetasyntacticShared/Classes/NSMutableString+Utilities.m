//
//  NSMutableString+Utilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 1/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableString+Utilities.h"


@implementation NSMutableString(Utilities)

- (void) appendString:(NSString*) string repeat:(NSInteger) repeat {
  for (NSInteger i = 0; i < repeat; i++) {
    [self appendString:string];
  }
}

@end
