//
//  CharacterKey.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CharacterKey.h"


@implementation CharacterKey

+ (CharacterKey*) keyWithIdentifier:(NSString*) identifier
                            name:(NSString*) name {
    return [[[CharacterKey alloc] initWithIdentifier:identifier name:name] autorelease];
}

@end
