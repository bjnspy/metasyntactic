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

- (void) dealloc {

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
    }

    return self;
}


+ (NSDictionary*) theaterDistanceMap:(Location*) location
                            theaters:(NSArray*) theaters {
    NSMutableDictionary* theaterDistanceMap = [NSMutableDictionary dictionary];
    
    for (Theater* theater in theaters) {
        double d;
        if (location != nil) {
            d = [location distanceTo:theater.location];
        } else {
            d = UNKNOWN_DISTANCE;
        }
        
        NSNumber* value = [NSNumber numberWithDouble:d];
        NSString* key = theater.name;
        [theaterDistanceMap setObject:value forKey:key];
    }
    
    return theaterDistanceMap;
}


@end