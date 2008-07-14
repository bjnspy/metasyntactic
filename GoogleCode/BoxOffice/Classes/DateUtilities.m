//
//  DateUtilies.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DateUtilities.h"


@implementation DateUtilities

static NSMutableDictionary* timeDifferenceMap;
static NSCalendar* calendar;
static NSDate* today;
static NSDateFormatter* dateFormatter;

+ (void) initialize {
    if (self == [DateUtilities class]) {
        timeDifferenceMap = [[NSMutableDictionary dictionary] retain];
        calendar = [[NSCalendar currentCalendar] retain];
        today = [[NSDate date] retain];
        dateFormatter = [[NSDateFormatter alloc] init];
    }
}

+ (NSString*) timeSinceNowWorker:(NSDate*) date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit)
                                               fromDate:date
                                                 toDate:today
                                                options:0];
    
    if ([components year] == 1) {
        return NSLocalizedString(@"1 year ago", nil);
    } else if ([components year] > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d years ago", nil), [components year]];
    } else if ([components month] == 1) { 
        return NSLocalizedString(@"1 month ago", nil);
    } else if ([components month] > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d months ago", nil), [components month]];
    } else if ([components week] == 1) {
        return NSLocalizedString(@"1 week ago", nil);
    } else if ([components week] > 1) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago", nil), [components week]];
    } else {
        NSDateComponents* components2 = [calendar components:NSWeekdayCalendarUnit fromDate:date];
        
        NSInteger weekday = [components2 weekday];
        return [[dateFormatter weekdaySymbols] objectAtIndex:(weekday - 1)];
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
                 
@end
