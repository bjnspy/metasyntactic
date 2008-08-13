// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "DateUtilities.h"

@implementation DateUtilities

static NSMutableDictionary* timeDifferenceMap;
static NSCalendar* calendar;
static NSDate* today;
static NSDateFormatter* dateFormatter;
static NSRecursiveLock* gate = nil;

+ (void) initialize {
    if (self == [DateUtilities class]) {
        gate = [[NSRecursiveLock alloc] init];

        timeDifferenceMap = [[NSMutableDictionary dictionary] retain];
        calendar = [[NSCalendar currentCalendar] retain];
        dateFormatter = [[NSDateFormatter alloc] init];

        NSDateComponents* todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate:[NSDate date]];
        todayComponents.hour = 12;
        today = [[calendar dateFromComponents:todayComponents] retain];
    }
}


+ (NSString*) timeSinceNowWorker:(NSDate*) date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit)
                                               fromDate:date
                                                 toDate:today
                                                options:0];

    if (components.year == 1) {
        return NSLocalizedString(@"1 year ago", nil);
    } else if (components.year > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d years ago", nil), components.year];
    } else if (components.month == 1) {
        return NSLocalizedString(@"1 month ago", nil);
    } else if (components.month > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d months ago", nil), components.month];
    } else if (components.week == 1) {
        return NSLocalizedString(@"1 week ago", nil);
    } else if (components.week > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago", nil), components.week];
    } else if (components.day == 0) {
        return NSLocalizedString(@"Today", nil);
    } else if (components.day == 1) {
        return NSLocalizedString(@"Yesterday", nil);
    } else {
        NSDateComponents* components2 = [calendar components:NSWeekdayCalendarUnit fromDate:date];

        NSInteger weekday = components2.weekday;
        return [NSString stringWithFormat:NSLocalizedString(@"Last %@", nil),
                                           [dateFormatter.weekdaySymbols objectAtIndex:(weekday - 1)]];
    }
}


+ (NSString*) timeSinceNow:(NSDate*) date {
    NSString* result = [timeDifferenceMap objectForKey:date];
    if (result == nil) {
        result = [DateUtilities timeSinceNowWorker:date];
        [timeDifferenceMap setObject:result forKey:date];
    }
    return result;
}


+ (NSDate*) today {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:[NSDate date]];
    [components setHour:12];
    return [calendar dateFromComponents:components];
}


+ (NSDate*) tomorrow {
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.day = 1;

    return [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                         toDate:[DateUtilities today]
                                                        options:0];
}


+ (BOOL) isSameDay:(NSDate*) d1
              date:(NSDate*) d2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:d1];
    NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:d2];

    return
    [components1 year] == [components2 year] &&
    [components1 month] == [components2 month] &&
    [components1 day] == [components2 day];
}


+ (BOOL) isToday:(NSDate*) date {
    return [DateUtilities isSameDay:[NSDate date] date:date];
}


+ (NSString*) formatShortTime:(NSDate*) date {
    NSString* result;
    [gate lock];
    {
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}


+ (NSString*) formatShortDate:(NSDate*) date {
    NSString* result;
    [gate lock];
    {
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}


+ (NSString*) formatLongDate:(NSDate*) date {
    NSString* result;
    [gate lock];
    {
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}


+ (NSString*) formatFullDate:(NSDate*) date {
    NSString* result;
    [gate lock];
    {
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        result = [dateFormatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}


+ (NSDate*) dateWithNaturalLanguageString:(NSString*) string {
    return [NSDate dateWithNaturalLanguageString:string];
}


@end
