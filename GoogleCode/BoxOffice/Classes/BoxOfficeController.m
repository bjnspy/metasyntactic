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
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[Application ratingsFile:[self.model currentRatingsProvider]]
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
    if ([postalCode isEqual:[self.model postalCode]]) {
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
