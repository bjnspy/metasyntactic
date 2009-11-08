//
//  Fibonacci.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Fibonacci.h"

@implementation Fibonacci

static NSInteger* fibonacciArray;
static NSInteger fibonacciArrayLength;

+ (void) initialize {
  if (self == [Fibonacci class]) {
    NSMutableArray* numbers = [NSMutableArray array];
    
    NSInteger f1 = 1;
    NSInteger f2 = 1;
    
    while (f2 > 0) {
      [numbers addObject:[NSNumber numberWithInteger:f2]];
      NSInteger temp = f1 + f2;
      f1 = f2;
      f2 = temp;
    }
    
    [numbers addObject:[NSNumber numberWithInteger:NSIntegerMax]];
    
    fibonacciArrayLength = numbers.count;
    fibonacciArray = malloc(fibonacciArrayLength * sizeof(NSInteger));
    
    for (NSInteger i = 0; i < fibonacciArrayLength; i++) {
      fibonacciArray[i] = [[numbers objectAtIndex:i] integerValue];
    }
  }
}


+ (NSInteger*) fibonacciArray {
  return fibonacciArray;
}


+ (NSInteger) fibonacciArrayLength {
  return fibonacciArrayLength;
}

@end
