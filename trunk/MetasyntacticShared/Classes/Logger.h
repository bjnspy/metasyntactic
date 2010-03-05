//
//  Logger.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 3/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AbstractCache.h"

@interface Logger : AbstractCache {
@private
  NSMutableArray* datesAndLogsData;
}

+ (Logger*) logger;

+ (void) log:(NSString*) string;

+ (NSArray*) datesAndLogs;

@end
