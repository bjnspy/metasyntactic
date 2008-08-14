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

    NSString* escapedAddress = [address stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
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

    [Utilities writeObject:[location dictionary] toFile:[self locationFile:address]];
    [self performSelectorOnMainThread:@selector(invalidateCachedData:) withObject:nil waitUntilDone:NO];
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


- (void) invalidateCachedData:(id) object {
    self.cachedTheaterDistanceMap = [NSMutableDictionary dictionary];
}


- (NSDictionary*) theaterDistanceMap:(Location*) userLocation
                            theaters:(NSArray*) theaters {
    NSString* locationDescription = [userLocation description];
    if (locationDescription == nil) {
        locationDescription = @"";
    }

    NSMutableDictionary* theaterDistanceMap = [self.cachedTheaterDistanceMap objectForKey:locationDescription];
    if (theaterDistanceMap == nil) {
        theaterDistanceMap = [NSMutableDictionary dictionary];

        for (Theater* theater in theaters) {
            double d;
            if (userLocation != nil) {
                d = [userLocation distanceTo:[self locationForAddress:theater.address]];
            } else {
                d = UNKNOWN_DISTANCE;
            }

            NSNumber* value = [NSNumber numberWithDouble:d];
            NSString* key = theater.address;
            [theaterDistanceMap setObject:value forKey:key];
        }

        [self.cachedTheaterDistanceMap setObject:theaterDistanceMap
                                          forKey:locationDescription];
    }

    return theaterDistanceMap;
}


@end
