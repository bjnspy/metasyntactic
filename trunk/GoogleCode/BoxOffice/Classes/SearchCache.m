// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchCache.h"

#import "Application.h"
#import "MovieKey.h"
#import "PersonKey.h"
#import "SearchMovie.h"
#import "SearchPerson.h"

@implementation SearchCache

- (NSString*) file:(NSString*) identifier {
    return [[[Application searchFolder] stringByAppendingPathComponent:identifier] stringByAppendingPathExtension:@"plist"];
}

- (NSString*) movieFile:(NSString*) identifier {
    return [self file:[NSString stringWithFormat:@"movie-%@", identifier]];
}

- (NSString*) personFile:(NSString*) identifier {
    return [self file:[NSString stringWithFormat:@"person-%@", identifier]];
}

- (SearchMovie*) getMovie:(NSString*) identifier {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[self movieFile:identifier]];
    if (dictionary == nil) {
        return nil;
    }

    return [SearchMovie movieWithDictionary:dictionary];
}

- (SearchPerson*) getPerson:(NSString*) identifier {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[self personFile:identifier]];
    if (dictionary == nil) {
        return nil;
    }

    return [SearchPerson personWithDictionary:dictionary];
}

- (void) putMovie:(SearchMovie*) movie {
    [[movie dictionary] writeToFile:[self movieFile:movie.key.identifier] atomically:YES];
}

- (void) putPerson:(SearchPerson*) person {
    [[person dictionary] writeToFile:[self personFile:person.key.identifier] atomically:YES];
}

@end
