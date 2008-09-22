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

#import "UserLocationCache.h"

#import "Application.h"
#import "Location.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation UserLocationCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (UserLocationCache*) cache {
    return [[[UserLocationCache alloc] init] autorelease];
}


- (void) updateUserAddressLocation:(NSString*) userAddress {
    [ThreadingUtilities performSelector:@selector(downloadUserAddressLocationBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:userAddress
                                   gate:gate
                                visible:NO];
}


- (BOOL) containsNumber:(NSString*) string {
    for (int i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >= '0' && c <= '9') {
            return YES;
        }
    }

    return NO;
}


- (NSString*) userCountryISO {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}


- (NSString*) massageAddress:(NSString*) userAddress {
    userAddress = [userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (userAddress.length <= 7 &&
        [self containsNumber:userAddress]) {
        // possibly a postal code.  append the country to help make it unique

        NSString* isoCode = [self userCountryISO];
        NSLocale* englishLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease];
        NSString* country = [englishLocale displayNameForKey:NSLocaleCountryCode value:isoCode];
        if (country != nil) {
            return [NSString stringWithFormat:@"%@. %@", userAddress, country];
        }
    }

    return nil;
}


- (NSString*) locationFolder {
    return [Application userLocationsFolder];
}


- (Location*) locationForUserAddress:(NSString*) userAddress {
    if ([Utilities isNilOrEmpty:userAddress]) {
        return nil;
    }

    Location* location = [self loadLocation:[self massageAddress:userAddress]];
    if (location != nil) {
        return location;
    }

    return [self loadLocation:userAddress];
}


- (void) setLocation:(Location*) location
      forUserAddress:(NSString*) userAddress {
    [self saveLocation:location forAddress:userAddress];
}


- (Location*) downloadUserAddressLocationBackgroundEntryPoint:(NSString*) userAddress {
    if ([Utilities isNilOrEmpty:userAddress]) {
        return nil;
    }

    NSAssert(![NSThread isMainThread], @"Only call this from the background");
    Location* location = [self locationForUserAddress:userAddress];

    if (location == nil) {
        location = [self downloadAddressLocationFromWebService:[self massageAddress:userAddress]];
        if (![location.country isEqual:[self userCountryISO]]) {
            location = [self downloadAddressLocationFromWebService:userAddress];
        }

        [self setLocation:location forUserAddress:userAddress];
    }

    return location;
}


@end