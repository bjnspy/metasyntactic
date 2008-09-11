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

#import "IMDbCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation IMDbCache

@synthesize gate;
@synthesize movieToAddressData;

- (void) dealloc {
    self.gate = nil;
    self.movieToAddressData = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (IMDbCache*) cache {
    return [[[IMDbCache alloc] init] autorelease];
}


- (void) deleteObsoleteAddresses:(NSArray*) movies {

}


- (NSString*) dataFile {
    return [[Application imdbFolder] stringByAppendingPathComponent:@"Data.plist"];
}


- (NSDictionary*) loadMovieToAddress {
    NSDictionary* result = [Utilities readObject:self.dataFile];
    if (result == nil) {
        return [NSDictionary dictionary];
    }
    
    return result;
}


- (NSDictionary*) movieToAddress {
    if (movieToAddressData == nil) {
        self.movieToAddressData = [self loadMovieToAddress];
    }
    
    return movieToAddressData;
}


- (void) update:(NSArray*) movies {
    [self deleteObsoleteAddresses:movies];

    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:[NSArray arrayWithObjects:movies, self.movieToAddress, nil]
                                   gate:gate
                                visible:NO];
}


- (void) backgroundEntryPoint:(NSArray*) arguments {
    NSArray* movies = [arguments objectAtIndex:0];
    NSDictionary* data = [arguments objectAtIndex:1];
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    for (Movie* movie in movies) {
        NSString* imdbAddress = [data objectForKey:movie.canonicalTitle];
        if (imdbAddress.length == 0) {
            NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
            imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
        }
        
        if (imdbAddress.length > 0) {
            [result setObject:imdbAddress forKey:movie.canonicalTitle];
        }
    }
    
    if (result.count > 0) {
        [Utilities writeObject:result toFile:self.dataFile];
        [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
    }
}


- (void) reportResult:(NSDictionary*) dictionary {
    self.movieToAddressData = dictionary;
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [self.movieToAddress objectForKey:movie.canonicalTitle];
}


@end