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

#import "UserLocationCache.h"

#import "Application.h"

@implementation UserLocationCache

static UserLocationCache* cache;

+ (void) initialize {
  if (self == [UserLocationCache class]) {
    cache = [[UserLocationCache alloc] init];
  }
}


+ (UserLocationCache*) cache {
  return cache;
}


- (BOOL) containsNumber:(NSString*) string {
  for (NSInteger i = 0; i < string.length; i++) {
    unichar c = [string characterAtIndex:i];
    if (c >= '0' && c <= '9') {
      return YES;
    }
  }

  return NO;
}


- (NSString*) massageAddress:(NSString*) userAddress {
  userAddress = [userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (userAddress.length <= 8 &&
      [self containsNumber:userAddress]) {
    // possibly a postal code.  append the country to help make it unique

    NSString* country = [LocaleUtilities englishCountry];
    if (country != nil) {
      return [NSString stringWithFormat:@"%@. %@", userAddress, country];
    }
  }

  return nil;
}


- (NSString*) locationDirectory {
  return [Application userLocationsDirectory];
}


- (Location*) locationForUserAddress:(NSString*) userAddress {
  if (userAddress.length == 0) {
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


- (Location*) downloadUserAddressLocationBackgroundEntryPointWorker:(NSString*) userAddress {
  if (userAddress.length == 0) {
    return nil;
  }

  NSAssert(![NSThread isMainThread], @"Only call this from the background");
  Location* location = [self locationForUserAddress:userAddress];

  if (location == nil) {
    NSLog(@"UserLocationCache:downloadWorker - Didn't find address in cache");

    NSString* notification = [LocalizedString(@"Location", nil) lowercaseString];
    [NotificationCenter addNotification:notification];
    {
      NSLog(@"UserLocationCache:downloadWorker - Downloading address address");

      location = [self downloadAddressLocationFromWebService:[self massageAddress:userAddress]];
      if ([location.country isEqual:[LocaleUtilities isoCountry]]) {
        NSLog(@"UserLocationCache:downloadWorker - Massaged address found");
      } else {
        NSLog(@"UserLocationCache:downloadWorker - Downloading non-massaged address");
        location = [self downloadAddressLocationFromWebService:userAddress];
      }
    }
    [NotificationCenter removeNotification:notification];

    [self setLocation:location forUserAddress:userAddress];
  }

  return location;
}


- (Location*) downloadUserAddressLocationBackgroundEntryPoint:(NSString*) userAddress {
  Location* result;
  [runGate lock];
  {
    result = [self downloadUserAddressLocationBackgroundEntryPointWorker:userAddress];
  }
  [runGate unlock];
  return result;
}

@end
