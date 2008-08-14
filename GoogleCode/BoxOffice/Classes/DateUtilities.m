// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
