//
//  Item.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

#import "StringUtilities.h"

@interface Item()
@property (copy) NSString* title;
@property (copy) NSString* link;
@property (copy) NSString* description;
@property (copy) NSString* date;
@property (copy) NSString* author;
@end


@implementation Item

property_definition(title);
property_definition(link);
property_definition(description);
property_definition(date);
property_definition(author);

- (void) dealloc {
    self.title = nil;
    self.link = nil;
    self.description = nil;
    self.date = nil;
    self.author = nil;
    
    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
                link:(NSString*) link_
         description:(NSString*) description_
                date:(NSString*) date_
              author:(NSString*) author_ {
    if (self = [super init]) {
        self.title = [StringUtilities nonNilString:title_];
        self.link = [StringUtilities nonNilString:link_];
        self.description = [StringUtilities nonNilString:description_];
        self.date = [StringUtilities nonNilString:date_];
        self.author = [StringUtilities nonNilString:author_];
    }
    
    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithTitle:[coder decodeObjectForKey:title_key]
                          link:[coder decodeObjectForKey:link_key]
                   description:[coder decodeObjectForKey:description_key]
                          date:[coder decodeObjectForKey:date_key]
                        author:[coder decodeObjectForKey:author_key]];
}


+ (Item*) itemWithDictionary:(NSDictionary*) dictionary {
    return [self itemWithTitle:[dictionary objectForKey:title_key]
                          link:[dictionary objectForKey:link_key]
                   description:[dictionary objectForKey:description_key]
                          date:[dictionary objectForKey:date_key]
                        author:[dictionary objectForKey:author_key]];
}


+ (Item*) itemWithTitle:(NSString*) title
                   link:(NSString*) link
            description:(NSString*) description
                   date:(NSString*) date
                 author:(NSString*) author {
    return [[[Item alloc] initWithTitle:title
                                   link:link
                            description:description
                                   date:date
                                 author:author] autorelease];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:title         forKey:title_key];
    [result setObject:link          forKey:link_key];
    [result setObject:description   forKey:description_key];
    [result setObject:date          forKey:date_key];
    [result setObject:author        forKey:author_key];
    return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:title         forKey:title_key];
    [coder encodeObject:link          forKey:link_key];
    [coder encodeObject:description   forKey:description_key];
    [coder encodeObject:date          forKey:date_key];
    [coder encodeObject:author        forKey:author_key]; 
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}

@end
