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
