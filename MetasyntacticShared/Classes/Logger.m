//
//  Logger.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Logger.h"

@interface Logger()
@property (retain) NSMutableArray* datesAndLogsData;
@end


@implementation Logger

@synthesize datesAndLogsData;

- (void) dealloc {
  self.datesAndLogsData = nil;
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
    self.datesAndLogsData = [NSMutableArray array];
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
    [datesAndLogsData addObject:value];
  }
  [dataGate unlock];
}


+ (void) log:(NSString*) string {
  [logger log:string];
}


- (NSArray*) datesAndLogs {
  NSArray* result;
  [dataGate lock];
  {
    result = [NSArray arrayWithArray:datesAndLogsData];
  }
  [dataGate unlock];
  return result;
}


+ (NSArray*) datesAndLogs {
  return [logger datesAndLogs];
}

@end
