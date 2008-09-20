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
#import "FileUtilities.h"
#import "Location.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

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


- (NSString*) locationFile:(NSString*) address {
    return [[[Application userLocationsFolder] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:address]]
            stringByAppendingPathExtension:@"plist"];
}


- (Location*) locationForUserAddress:(NSString*) userAddress {
    if (![Utilities isNilOrEmpty:userAddress]) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[self locationFile:userAddress]];
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
    
    [FileUtilities writeObject:location.dictionary toFile:[self locationFile:address]];
}


- (Location*) downloadUserAddressLocationBackgroundEntryPoint:(NSString*) userAddress {
    NSAssert(![NSThread isMainThread], @"Only call this from the background");
    Location* location = [self locationForUserAddress:userAddress];
    
    if (location == nil) {
        location = [self downloadAddressLocationFromWebService:userAddress];
        
        [self setLocation:location forAddress:userAddress];
    }
    
    return location;
}


@end