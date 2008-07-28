//
//  DateUtilies.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface DateUtilities : NSObject {

}

+ (NSString*) timeSinceNow:(NSDate*) date;

+ (NSDate*) today;
+ (NSDate*) tomorrow;

+ (NSDate*) dateWithNaturalLanguageString:(NSString*) string;

+ (BOOL) isSameDay:(NSDate*) d1
              date:(NSDate*) d2;

+ (BOOL) isToday:(NSDate*) date;

+ (NSString*) formatShortTime:(NSDate*) date;
+ (NSString*) formatShortDate:(NSDate*) date;
+ (NSString*) formatLongDate:(NSDate*) date;
+ (NSString*) formatFullDate:(NSDate*) date;

@end
