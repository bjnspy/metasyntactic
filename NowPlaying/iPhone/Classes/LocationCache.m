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

#import "LocationCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Location.h"
#import "LocationUtilities.h"
#import "NetworkUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation LocationCache


- (void) dealloc {
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
    }

    return self;
}


- (Location*) processResult:(XmlElement*) resultElement {
    if (resultElement != nil) {
        NSString* latitude =    [resultElement attributeValue:@"latitude"];
        NSString* longitude =   [resultElement attributeValue:@"longitude"];
        NSString* address =     [resultElement attributeValue:@"address"];
        NSString* city =        [resultElement attributeValue:@"city"];
        NSString* state =       [resultElement attributeValue:@"state"];
        NSString* country =     [resultElement attributeValue:@"country"];
        NSString* postalCode =  [resultElement attributeValue:@"zipcode"];

        if (![Utilities isNilOrEmpty:latitude] &&
            ![Utilities isNilOrEmpty:longitude]) {
            return [Location locationWithLatitude:latitude.doubleValue
                                        longitude:longitude.doubleValue
                                          address:address
                                             city:city
                                            state:state
                                       postalCode:postalCode
                                          country:country];
        }
    }

    return nil;
}


- (Location*) downloadAddressLocationFromWebServiceWorker:(NSString*) address {
    NSString* escapedAddress = [Utilities stringByAddingPercentEscapes:address];
    if (escapedAddress != nil) {
        NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocation?q=%@", [Application host], escapedAddress];

        XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url important:NO];
        return [self processResult:element];
    }

    return nil;
}


- (Location*) downloadAddressLocationFromWebService:(NSString*) address {
    if ([Utilities isNilOrEmpty:address]) {
        return nil;
    }

    Location* result = [self downloadAddressLocationFromWebServiceWorker:address];
    if (result != nil && result.latitude != 0 && result.longitude != 0) {
        if ([Utilities isNilOrEmpty:result.postalCode]) {

            CLLocation* location = [[[CLLocation alloc] initWithLatitude:result.latitude longitude:result.longitude] autorelease];
            Location* resultLocation = [LocationUtilities findLocation:location];
            if (![Utilities isNilOrEmpty:resultLocation.postalCode]) {
                return [Location locationWithLatitude:result.latitude
                                            longitude:result.longitude
                                              address:result.address
                                                 city:result.city
                                                state:result.state
                                           postalCode:resultLocation.postalCode
                                              country:result.country];
            }
        }
    }

    return result;
}


- (NSString*) locationFolder {
    NSAssert(false, @"Someone subclassed incorrectly");
    return nil;
}


- (NSString*) locationFile:(NSString*) address {
    return [[[self locationFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]]
            stringByAppendingPathExtension:@"plist"];
}


- (Location*) loadLocation:(NSString*) address {
    if (![Utilities isNilOrEmpty:address]) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[self locationFile:address]];
        if (dict != nil) {
            return [Location locationWithDictionary:dict];
        }
    }

    return nil;
}


- (void) saveLocation:(Location*) location
          forAddress:(NSString*) address {
    if (location == nil || [Utilities isNilOrEmpty:address]) {
        return;
    }

    [FileUtilities writeObject:location.dictionary toFile:[self locationFile:address]];
}


@end