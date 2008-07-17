//
//  SearchCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchCache.h"
#import "Application.h"


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
