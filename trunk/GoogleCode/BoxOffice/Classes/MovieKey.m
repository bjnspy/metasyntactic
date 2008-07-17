//
//  MovieKey.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieKey.h"


@implementation MovieKey

+ (MovieKey*) keyWithIdentifier:(NSString*) identifier
                            name:(NSString*) name {
    return [[[MovieKey alloc] initWithIdentifier:identifier name:name] autorelease];
}

+ (MovieKey*) keyWithDictionary:(NSDictionary*) dict {
    return [MovieKey keyWithIdentifier:[dict objectForKey:@"identifier"] 
                                   name:[dict objectForKey:@"name"]];
}

@end
