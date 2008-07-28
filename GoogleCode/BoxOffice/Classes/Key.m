//
//  Key.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Key.h"


@implementation Key

@synthesize identifier;
@synthesize name;

- (id) initWithIdentifier:(NSString*) identifier_
                     name:(NSString*) name_ {
    if (self = [super init]) {
        self.identifier = identifier_;
        self.name = name_;
    }

    return self;
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:identifier forKey:@"identifier"];
    [dict setObject:name forKey:@"name"];
    return dict;
}

@end
