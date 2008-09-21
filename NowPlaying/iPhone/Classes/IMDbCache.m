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
#import "FileUtilities.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation IMDbCache

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


+ (IMDbCache*) cache {
    return [[[IMDbCache alloc] init] autorelease];
}


- (NSString*) movieFileName:(NSString*) title {
    return [[FileUtilities sanitizeFileName:title] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) movieFilePath:(Movie*) movie {
    return [[Application imdbFolder] stringByAppendingPathComponent:[self movieFileName:movie.canonicalTitle]];
}


- (void) deleteObsoleteAddresses:(NSArray*) movies {

}


- (void) update:(NSArray*) movies {
    [self deleteObsoleteAddresses:movies];

    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:movies
                                   gate:gate
                                visible:NO];
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    for (Movie* movie in movies) {
        NSString* path = [self movieFilePath:movie];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            continue;
        }

        NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
        NSString* imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];

        if (imdbAddress.length > 0) {
            [FileUtilities writeObject:imdbAddress toFile:path];
        }
    }
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self movieFilePath:movie]];
}


@end