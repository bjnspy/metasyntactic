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
