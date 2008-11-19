// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

        if (latitude.length != 0 &&
            longitude.length != 0) {
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

        XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url important:YES];
        return [self processResult:element];
    }

    return nil;
}


- (Location*) downloadAddressLocationFromWebService:(NSString*) address {
    if (address.length == 0) {
        return nil;
    }

    Location* result = [self downloadAddressLocationFromWebServiceWorker:address];
    if (result != nil && result.latitude != 0 && result.longitude != 0) {
        if (result.postalCode.length == 0) {

            CLLocation* location = [[[CLLocation alloc] initWithLatitude:result.latitude longitude:result.longitude] autorelease];
            Location* resultLocation = [LocationUtilities findLocation:location];
            if (resultLocation.postalCode.length != 0) {
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


- (NSString*) locationDirectory {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) locationFile:(NSString*) address {
    return [[[self locationDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]]
            stringByAppendingPathExtension:@"plist"];
}


- (Location*) loadLocation:(NSString*) address {
    if (address.length != 0) {
        NSDictionary* dict = [FileUtilities readObject:[self locationFile:address]];
        if (dict != nil) {
            return [Location locationWithDictionary:dict];
        }
    }

    return nil;
}


- (void) saveLocation:(Location*) location
          forAddress:(NSString*) address {
    if (location == nil || address.length == 0) {
        return;
    }

    [FileUtilities writeObject:location.dictionary toFile:[self locationFile:address]];
}

@end