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

#import "BoxOfficeController.h"

#import "Application.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeModel.h"
#import "NorthAmericaDataProvider.h"
#import "RatingsCache.h"
#import "Utilities.h"

@implementation BoxOfficeController

@synthesize ratingsLookupLock;
@synthesize dataProviderLock;

- (void) dealloc {
    self.ratingsLookupLock = nil;
    self.dataProviderLock = nil;

    [super dealloc];
}


- (BoxOfficeModel*) model {
    return appDelegate.model;
}


- (void) onBackgroundTaskStarted:(NSString*) description {
    [self.model addBackgroundTask:description];
}


- (BOOL) tooSoon:(NSDate*) lastDate {
    if (lastDate == nil) {
        return NO;
    }

    NSDate* now = [NSDate date];
    NSDateComponents* lastDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit fromDate:lastDate];
    NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit fromDate:now];

    if ([lastDateComponents day] != [nowDateComponents day]) {
        // different days.  we definitely need to refresh
        return NO;
    }

    // same day, check if they're at least 8 hours apart.
    if ([nowDateComponents hour] >= ([lastDateComponents hour] + 8)) {
        return NO;
    }

    // it's been less than 8 hours.  it's too soon to refresh
    return YES;
}


- (void) spawnRatingsLookupThread {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[Application ratingsFile:self.model.currentRatingsProvider]
                                                                               error:NULL] objectForKey:NSFileModificationDate];
    if ([self tooSoon:lastLookupDate]) {
        return;
    }

    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading movie list", nil)];
    [self performSelectorInBackground:@selector(ratingsLookupBackgroundThreadEntryPoint:) withObject:nil];
}


- (void) spawnDataProviderLookupThread {
    if ([Utilities isNilOrEmpty:self.model.postalCode]) {
        return;
    }

    if ([self tooSoon:[[self.model currentDataProvider] lastLookupDate]]) {
        return;
    }

    [self onBackgroundTaskStarted:NSLocalizedString(@"Downloading ticketing data", nil)];
    [self performSelectorInBackground:@selector(dataProviderLookupBackgroundThreadEntryPoint:) withObject:nil];
}


- (void) spawnBackgroundThreads {
    [self spawnRatingsLookupThread];
    [self spawnDataProviderLookupThread];
}


- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        appDelegate = appDelegate_;
        self.ratingsLookupLock = [[[NSLock alloc] init] autorelease];
        self.dataProviderLock = [[[NSLock alloc] init] autorelease];

        [self spawnBackgroundThreads];
    }

    return self;
}


+ (BoxOfficeController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate {
    return [[[BoxOfficeController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (NSDictionary*) ratingsLookup {
    return [self.model.ratingsCache update];
}


- (void) ratingsLookupBackgroundThreadEntryPoint:(id) arguments {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [self.ratingsLookupLock lock];
    {
        NSDictionary* ratings = [self ratingsLookup];
        [self performSelectorOnMainThread:@selector(setRatings:) withObject:ratings waitUntilDone:NO];
    }
    [self.ratingsLookupLock unlock];
    [autoreleasePool release];
}


- (void) onBackgroundTaskEnded:(NSString*) description {
    [self.model removeBackgroundTask:description];
    [appDelegate.tabBarController refresh];
}


- (void) setRatings:(NSDictionary*) ratings {
    if (ratings.count > 0) {
        [self.model onRatingsUpdated];
    }

    [self onBackgroundTaskEnded:NSLocalizedString(@"Finished downloading movie list", nil)];
}


- (void) dataProviderLookupBackgroundThreadEntryPoint:(id) anObject {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [self.dataProviderLock lock];
    {
        [[self.model currentDataProvider] lookup];
        [self performSelectorOnMainThread:@selector(onBackgroundTaskEnded:)
                               withObject:NSLocalizedString(@"Finished downloading movie and theater data", nil)
                            waitUntilDone:NO];
    }
    [self.dataProviderLock unlock];
    [autoreleasePool release];
}


- (void) setSearchDate:(NSDate*) searchDate {
    if ([searchDate isEqual:[self.model searchDate]]) {
        return;
    }

    [self.model setSearchDate:searchDate];
    [self spawnBackgroundThreads];
    [appDelegate.tabBarController popNavigationControllersToRoot];
    [appDelegate.tabBarController refresh];
}


- (void) setPostalCode:(NSString*) postalCode {
    if ([postalCode isEqual:self.model.postalCode]) {
        return;
    }

    [self.model setPostalCode:postalCode];
    [self spawnBackgroundThreads];
    [appDelegate.tabBarController popNavigationControllersToRoot];
    [appDelegate.tabBarController refresh];
}


- (void) setSearchRadius:(NSInteger) radius {
    [self.model setSearchRadius:radius];
    [appDelegate.tabBarController refresh];
}


- (void) setRatingsProviderIndex:(NSInteger) index {
    if (index == [self.model ratingsProviderIndex]) {
        return;
    }

    [self.model setRatingsProviderIndex:index];
    [self spawnRatingsLookupThread];
    [appDelegate.tabBarController refresh];
}


- (void) setDataProviderIndex:(NSInteger) index {
    if (index == [self.model dataProviderIndex]) {
        return;
    }

    [self.model setDataProviderIndex:index];
    [self spawnDataProviderLookupThread];
    [appDelegate.tabBarController refresh];
}


@end
