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

#import "AddressLocationCache.h"

#import "Application.h"
#import "Location.h"
#import "Theater.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation AddressLocationCache

@synthesize gate;
@synthesize cachedTheaterDistanceMap;

- (void) dealloc {
    self.gate = nil;
    self.cachedTheaterDistanceMap = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
    }

    return self;
}


+ (AddressLocationCache*) cache {
    return [[[AddressLocationCache alloc] init] autorelease];
}


- (void) updateAddresses:(NSArray*) addresses {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];

    [ThreadingUtilities performSelector:@selector(downloadAddressLocationsBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:[NSArray arrayWithArray:addresses]
                                   gate:gate
                                visible:NO];
}


- (NSString*) locationFolder {
    return [Application locationsFolder];
}


- (Location*) locationForAddress:(NSString*) address {
    return [self loadLocation:address];
}


- (void) setLocation:(Location*) location
          forAddress:(NSString*) address {
    if (location == nil || [Utilities isNilOrEmpty:address]) {
        return;
    }

    [self saveLocation:location forAddress:address];
    [self performSelectorOnMainThread:@selector(invalidateCachedData) withObject:nil waitUntilDone:NO];
}


- (void) invalidateCachedData {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
}


- (Location*) downloadAddressLocationBackgroundEntryPoint:(NSString*) address {
    NSAssert(![NSThread isMainThread], @"Only call this from the background");
    Location* location = [self locationForAddress:address];

    if (location == nil) {
        location = [self downloadAddressLocationFromWebService:address];

        [self setLocation:location forAddress:address];
    }

    return location;
}


- (void) downloadAddressLocationsBackgroundEntryPoint:(NSArray*) addresses {
    for (NSString* address in addresses) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        [self downloadAddressLocationBackgroundEntryPoint:address];

        [autoreleasePool release];
    }
}


- (Location*) locationForTheater:(Theater*) theater {
    if (theater.latitude != 0 && theater.longitude != 0) {
        return [Location locationWithLatitude:theater.latitude longitude:theater.longitude];
    } else {
        return [self locationForAddress:theater.address];
    }
}


- (NSDictionary*) theaterDistanceMap:(Location*) location
                            theaters:(NSArray*) theaters {
    NSString* userPostalCode = [Utilities nonNilString:location.postalCode];
    NSMutableDictionary* theaterDistanceMap = [cachedTheaterDistanceMap objectForKey:userPostalCode];
    if (theaterDistanceMap == nil) {
        theaterDistanceMap = [NSMutableDictionary dictionary];

        for (Theater* theater in theaters) {
            double d;
            if (location != nil) {
                
                d = [location distanceTo:[self locationForTheater:theater]];
            } else {
                d = UNKNOWN_DISTANCE;
            }

            NSNumber* value = [NSNumber numberWithDouble:d];
            NSString* key = theater.address;
            [theaterDistanceMap setObject:value forKey:key];
        }

        [cachedTheaterDistanceMap setObject:theaterDistanceMap
                                     forKey:userPostalCode];
    }

    return theaterDistanceMap;
}


@end