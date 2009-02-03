//
//  Item.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Item : NSObject<NSCopying,NSCoding> {
@private
    NSString* title;
    NSString* link;
    NSString* description;
    NSString* date;
    NSString* author;
}

@property (readonly, copy) NSString* title;
@property (readonly, copy) NSString* link;
@property (readonly, copy) NSString* description;
@property (readonly, copy) NSString* date;
@property (readonly, copy) NSString* author;

+ (Item*) itemWithDictionary:(NSDictionary*) dictionary;
+ (Item*) itemWithTitle:(NSString*) title
                   link:(NSString*) link
            description:(NSString*) description
                   date:(NSString*) date
                 author:(NSString*) author;

- (NSDictionary*) dictionary;

@end
