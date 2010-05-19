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

@interface DateUtilities : NSObject {
}

+ (NSString*) timeSinceNow:(NSDate*) date;

+ (NSDate*) today;
+ (NSDate*) tomorrow;

+ (NSDate*) dateWithNaturalLanguageString:(NSString*) string;
+ (NSDate*) parseISO8601Date:(NSString*) string;

+ (BOOL) isSameDay:(NSDate*) d1
              date:(NSDate*) d2;

+ (BOOL) isToday:(NSDate*) date;

+ (NSString*) formatShortTime:(NSDate*) date;
+ (NSString*) formatShortDate:(NSDate*) date;
+ (NSString*) formatLongDate:(NSDate*) date;
+ (NSString*) formatMediumDate:(NSDate*) date;
+ (NSString*) formatFullDate:(NSDate*) date;
+ (NSString*) formatYear:(NSDate*) date;

+ (BOOL) use24HourTime;

+ (NSDate*) currentTime;

@end
