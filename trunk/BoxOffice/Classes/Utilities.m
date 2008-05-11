//
//  Utilities.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (BOOL) isNilOrEmpty:(NSString*) string
{
    return
	string == nil ||
	[@"" isEqual:string];
}

@end
