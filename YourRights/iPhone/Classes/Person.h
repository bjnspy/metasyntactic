//
//  Person.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Person : NSObject {
@private
    NSString* name;
    NSString* link;
}

@property (readonly, copy) NSString* name;
@property (readonly, copy) NSString* link;

+ (Person*) personWithName:(NSString*) name link:(NSString*) link;

@end

Person* person(NSString* name, NSString* link);