// Copyright 2010 Cyrus Najmabadi
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

#import "AbstractLocationCache.h"

#import "Application.h"

@interface AbstractLocationCache()
@property (retain) AutoreleasingMutableDictionary* addressToLocation;
@end

@implementation AbstractLocationCache

@synthesize addressToLocation;

- (void) dealloc {
  self.addressToLocation = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.addressToLocation = [AutoreleasingMutableDictionary dictionary];
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
  NSString* escapedAddress = [StringUtilities stringByAddingPercentEscapes:address];
  if (escapedAddress != nil) {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupLocation%@?q=%@",
                     [Application apiHost], [Application apiVersion], escapedAddress];

    XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];
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


- (NSString*) locationDirectory AbstractMethod;


- (NSString*) locationFile:(NSString*) address {
  return [[[self locationDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]]
          stringByAppendingPathExtension:@"plist"];
}


- (Location*) loadLocationWorker:(NSString*) address {
  if (address.length != 0) {
    NSDictionary* dict = [FileUtilities readObject:[self locationFile:address]];
    if (dict != nil) {
      return [Location locationWithDictionary:dict];
    }
  }

  return nil;
}


- (Location*) loadLocation:(NSString*) address {
  Location* result = nil;
  [dataGate lock];
  {
    result = [addressToLocation objectForKey:address];
    if (result == nil) {
      result = [self loadLocationWorker:address];
      if (result != nil) {
        [addressToLocation setObject:result forKey:address];
      }
    }
  }
  [dataGate unlock];

  return result;
}


- (void) saveLocation:(Location*) location
           forAddress:(NSString*) address {
  if (location == nil || address.length == 0) {
    return;
  }

  [dataGate lock];
  {
    [FileUtilities writeObject:location.dictionary toFile:[self locationFile:address]];
    [addressToLocation setObject:location forKey:address];
  }
  [dataGate unlock];
}

@end
