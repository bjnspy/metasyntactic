// Copyright (C) 2008 Cyrus Najmabadi
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

#import "DateUtilities.h"

@implementation DateUtilities

static NSMutableDictionary* timeDifferenceMap;
static NSCalendar* calendar;
static NSDate* today;
static NSRecursiveLock* gate = nil;


static NSDateFormatter* shortDateFormatter;
static NSDateFormatter* mediumDateFormatter;
static NSDateFormatter* longDateFormatter;
static NSDateFormatter* fullDateFormatter;
static NSDateFormatter* shortTimeFormatter;


static NSMutableDictionary* yearsAgoMap;
static NSMutableDictionary* monthsAgoMap;
static NSMutableDictionary* weeksAgoMap;

+ (void) initialize {
    if (self == [DateUtilities class]) {
        gate = [[NSRecursiveLock alloc] init];

        timeDifferenceMap = [[NSMutableDictionary dictionary] retain];
        calendar = [[NSCalendar currentCalendar] retain];
        NSDateComponents* todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate:[NSDate date]];
        todayComponents.hour = 12;
        today = [[calendar dateFromComponents:todayComponents] retain];

        yearsAgoMap = [[NSMutableDictionary dictionary] retain];
        monthsAgoMap = [[NSMutableDictionary dictionary] retain];
        weeksAgoMap = [[NSMutableDictionary dictionary] retain];

        {
            shortDateFormatter = [[NSDateFormatter alloc] init];
            [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
            [shortDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        }

        {
            mediumDateFormatter = [[NSDateFormatter alloc] init];
            [mediumDateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [mediumDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        }

        {
            longDateFormatter = [[NSDateFormatter alloc] init];
            [longDateFormatter setDateStyle:NSDateFormatterLongStyle];
            [longDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        }

        {
            fullDateFormatter = [[NSDateFormatter alloc] init];
            [fullDateFormatter setDateStyle:NSDateFormatterFullStyle];
            [fullDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        }

        {
            shortTimeFormatter = [[NSDateFormatter alloc] init];
            [shortTimeFormatter setDateStyle:NSDateFormatterNoStyle];
            [shortTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
    }
}


+ (NSString*) agoString:(NSInteger) time
                    map:(NSMutableDictionary*) map
               singular:(NSString*) singular
                 plural:(NSString*) plural {
    if (time == 1) {
        return singular;
    } else {
        NSNumber* number = [NSNumber numberWithInt:time];
        NSString* result = [map objectForKey:number];
        if (result == nil) {
            result = [NSString stringWithFormat:plural, time];
            [map setObject:result forKey:number];
        }
        return result;
    }
}


+ (NSString*) yearsAgoString:(NSInteger) year {
    return [self agoString:year
                       map:yearsAgoMap
                  singular:NSLocalizedString(@"1 year ago", nil)
                    plural:NSLocalizedString(@"%d years ago", nil)];
}


+ (NSString*) monthsAgoString:(NSInteger) month {
    return [self agoString:month
                       map:monthsAgoMap
                  singular:NSLocalizedString(@"1 month ago", nil)
                    plural:NSLocalizedString(@"%d months ago", nil)];
}


+ (NSString*) weeksAgoString:(NSInteger) week {
    return [self agoString:week
                       map:weeksAgoMap
                  singular:NSLocalizedString(@"1 week ago", nil)
                    plural:NSLocalizedString(@"%d weeks ago", nil)];
}


+ (NSString*) timeSinceNowWorker:(NSDate*) date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit)
                                               fromDate:date
                                                 toDate:today
                                                options:0];

    if (components.year >= 1) {
        return [self yearsAgoString:components.year];
    } else if (components.month >= 1) {
        return [self monthsAgoString:components.month];
    } else if (components.week >= 1) {
        return [self weeksAgoString:components.week];
    } else if (components.day == 0) {
        return NSLocalizedString(@"Today", nil);
    } else if (components.day == 1) {
        return NSLocalizedString(@"Yesterday", nil);
    } else {
        NSDateComponents* components2 = [calendar components:NSWeekdayCalendarUnit fromDate:date];

        NSInteger weekday = components2.weekday;
        switch (weekday) {
            case 1: return NSLocalizedString(@"Last Sunday", nil);
            case 2: return NSLocalizedString(@"Last Monday", nil);
            case 3: return NSLocalizedString(@"Last Tuesday", nil);
            case 4: return NSLocalizedString(@"Last Wednesday", nil);
            case 5: return NSLocalizedString(@"Last Thursday", nil);
            case 6: return NSLocalizedString(@"Last Friday", nil);
            default: return NSLocalizedString(@"Last Saturday", nil);
        }
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


+ (NSString*) format:(NSDate*) date formatter:(NSDateFormatter*) formatter {
    NSString* result;
    [gate lock];
    {
        result = [formatter stringFromDate:date];
    }
    [gate unlock];
    return result;
}


+ (NSString*) formatShortTime:(NSDate*) date {
    return [self format:date formatter:shortTimeFormatter];
}


+ (NSString*) formatMediumDate:(NSDate*) date {
    return [self format:date formatter:mediumDateFormatter];
}


+ (NSString*) formatShortDate:(NSDate*) date {
    return [self format:date formatter:shortDateFormatter];
}


+ (NSString*) formatLongDate:(NSDate*) date {
    return [self format:date formatter:longDateFormatter];
}


+ (NSString*) formatFullDate:(NSDate*) date {
    return [self format:date formatter:fullDateFormatter];
}


+ (NSDate*) dateWithNaturalLanguageString:(NSString*) string {
    //return nil;
    return [NSDate dateWithNaturalLanguageString:string];
}


@end