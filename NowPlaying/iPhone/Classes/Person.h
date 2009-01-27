//
//  Person.h
//  PocketFlix
//
//  Created by Cyrus Najmabadi on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Person : NSObject<NSCopying> {
@private
    NSString* identifier;
    NSString* name;
    NSString* biography;
    NSDictionary* additionalFields;
}

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* name;
@property (readonly, copy) NSString* biography;
@property (readonly, retain) NSDictionary* additionalFields;

+ (Person*) personWithDictionary:(NSDictionary*) dictionary;
+ (Person*) personWithIdentifier:(NSString*) identifier
                            name:(NSString*) name
                       biography:(NSString*) biography
                additionalFields:(NSDictionary*) additionalFields;

- (NSDictionary*) dictionary;

@end
