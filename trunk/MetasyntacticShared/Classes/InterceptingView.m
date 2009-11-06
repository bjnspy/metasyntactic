//
//  InterceptingView.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InterceptingView.h"


@implementation InterceptingView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Intercepting: touchesBegan");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Intercepting: touchesMoved");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Intercepting: touchesEnded");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Intercepting: touchesCancelled");
}

@end
