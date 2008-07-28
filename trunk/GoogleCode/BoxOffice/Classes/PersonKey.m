//
//  PersonKey.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PersonKey.h"


@implementation PersonKey

+ (PersonKey*) keyWithIdentifier:(NSString*) identifier
                            name:(NSString*) name {
    return [[[PersonKey alloc] initWithIdentifier:identifier name:name] autorelease];
}

+ (PersonKey*) keyWithDictionary:(NSDictionary*) dict {
    return [PersonKey keyWithIdentifier:[dict objectForKey:@"identifier"]
                                   name:[dict objectForKey:@"name"]];
}

@end
