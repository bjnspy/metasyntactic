//
//  Logger.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Logger.h"

#import "NSArray+Utilities.h"

@interface Logger()
@property (retain) NSMutableArray* datesAndLogs;
@end


@implementation Logger

@synthesize datesAndLogs;

- (void) dealloc {
  self.datesAndLogs = nil;
  [super dealloc];
}

static Logger* logger;

+ (void) initialize {
  if (self == [Logger class]) {
    logger = [[Logger alloc] init];
  }
}


- (id) init {
  if ((self = [super init])) {
    self.datesAndLogs = [NSMutableArray array];
  }
  return self;
}


+ (Logger*) logger {
  return logger;
}


- (void) log:(NSString*) log {
  [dataGate lock];
  {
    NSArray* value = [NSArray arrayWithObjects:[NSDate date], log, nil];
    [datesAndLogs addObject:value];
  }
  [dataGate unlock];
}


+ (void) log:(NSString*) string {
  [logger log:string];
}


- (NSString*) logs {
  NSString* result;
  [dataGate lock];
  {
    NSMutableString* logs = [NSMutableString string];
    for (NSInteger i = datesAndLogs.count - 1; i >= 0; i--) {
      NSArray* dateAndLog = [datesAndLogs objectAtIndex:i];

      if (logs.length > 0) {
        [logs appendString:@"\n\n"];
      }
      
      NSDate* date = [dateAndLog firstObject];
      NSString* log = [dateAndLog lastObject];
      [logs appendFormat:@"%@: %@", date, log];
    }
    result = logs;
  }
  [dataGate unlock];
  return result;
}


+ (NSString*) logs {
  return [logger logs];
}

@end
