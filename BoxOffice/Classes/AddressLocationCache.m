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
#import "Utilities.h"
#import "XmlElement.h"

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

    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:addresses]];
}


- (Location*) processResult:(XmlElement*) resultElement {
    if (resultElement != nil) {
        NSString* latitude = [resultElement attributeValue:@"latitude"];
        NSString* longitude = [resultElement attributeValue:@"longitude"];
        NSString* address = [resultElement attributeValue:@"address"];
        NSString* city = [resultElement attributeValue:@"city"];
        NSString* country = [resultElement attributeValue:@"country"];

        if (![Utilities isNilOrEmpty:latitude] && ![Utilities isNilOrEmpty:longitude]) {
            return [Location locationWithLatitude:[latitude doubleValue]
                                        longitude:[longitude doubleValue]
                                          address:address
                                             city:city
                                          country:country];
        }
    }

    return nil;
}


- (Location*) downloadAddressLocationFromWebService:(NSString*) address {
    if ([Utilities isNilOrEmpty:address]) {
        return nil;
    }

    NSString* escapedAddress = [Utilities stringByAddingPercentEscapes:address];
    if (escapedAddress != nil) {
        NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocation?q=%@", [Application host], escapedAddress];

        XmlElement* element = [Utilities downloadXml:url];
        return [self processResult:element];
    }

    return nil;
}


- (NSString*) locationFile:(NSString*) address {
    return [[[Application locationsFolder] stringByAppendingPathComponent:[Application sanitizeFileName:address]]
            stringByAppendingPathExtension:@"plist"];
}


- (Location*) locationForAddress:(NSString*) address {
    if (![Utilities isNilOrEmpty:address]) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[self locationFile:address]];
        if (dict != nil) {
            return [Location locationWithDictionary:dict];
        }
    }

    return nil;
}


- (void) setLocation:(Location*) location
          forAddress:(NSString*) address {
    if (location == nil || [Utilities isNilOrEmpty:address]) {
        return;
    }

    [Utilities writeObject:location.dictionary toFile:[self locationFile:address]];
    [self performSelectorOnMainThread:@selector(invalidateCachedData:) withObject:nil waitUntilDone:NO];
}


- (void) invalidateCachedData:(id) object {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
}


- (Location*) downloadAddressLocation:(NSString*) address {
    NSAssert(![NSThread isMainThread], @"Only call this from the background");
    Location* location = [self locationForAddress:address];

    if (location == nil) {
        location = [self downloadAddressLocationFromWebService:address];

        [self setLocation:location forAddress:address];
    }

    return location;
}


- (void) downloadAddressLocations:(NSArray*) addresses {
    for (NSString* address in addresses) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        [self downloadAddressLocation:address];

        [autoreleasePool release];
    }
}


- (void) backgroundEntryPoint:(NSArray*) addresses {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [NSThread setThreadPriority:0.0];

        [self downloadAddressLocations:addresses];
    }
    [gate unlock];
    [autoreleasePool release];
}


- (Location*) locationForPostalCode:(NSString*) postalCode {
    return [self locationForAddress:postalCode];
}


- (void) updatePostalCodeBackgroundEntryPoint:(NSString*) postalCode {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    {
        [NSThread setThreadPriority:0.0];

        [self downloadAddressLocation:postalCode];
    }
    [autoreleasePool release];
}


- (void) updatePostalCode:(NSString*) postalCode {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];

    if ([Utilities isNilOrEmpty:postalCode]) {
        return;
    }

    if ([self locationForPostalCode:postalCode] != nil) {
        return;
    }

    [self performSelectorInBackground:@selector(updatePostalCodeBackgroundEntryPoint:)
                           withObject:postalCode];
}


- (NSDictionary*) theaterDistanceMap:(NSString*) userPostalCode
                            theaters:(NSArray*) theaters
                       useKilometers:(BOOL) useKilometers {
    Location* userLocation = [self locationForPostalCode:userPostalCode];

    NSMutableDictionary* theaterDistanceMap = [self.cachedTheaterDistanceMap objectForKey:userPostalCode];
    if (theaterDistanceMap == nil) {
        theaterDistanceMap = [NSMutableDictionary dictionary];

        for (Theater* theater in theaters) {
            double d;
            if (userLocation != nil) {
                d = [userLocation distanceTo:[self locationForAddress:theater.address]  useKilometers:useKilometers];
            } else {
                d = UNKNOWN_DISTANCE;
            }

            NSNumber* value = [NSNumber numberWithDouble:d];
            NSString* key = theater.address;
            [theaterDistanceMap setObject:value forKey:key];
        }

        [self.cachedTheaterDistanceMap setObject:theaterDistanceMap
         forKey:userPostalCode];
    }

    return theaterDistanceMap;
}


@end