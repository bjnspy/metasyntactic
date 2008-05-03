//
//  XmlElement.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XmlElement.h"


@implementation XmlElement

@synthesize name;
@synthesize attributes;
@synthesize children;
@synthesize text;

- (id) initWithName:(NSString*) name_
         attributes:(NSDictionary*) attributes_
           children:(NSArray*) children_
               text:(NSString*) text_
{
    if (self = [super init])
    {
        self.name = name_;
        self.attributes = attributes_;
        self.children = children_;
        self.text = text_;
    }
    
    return self;
}

- (void) dealloc
{
    self.name = nil;
    self.attributes = nil;
    self.children = nil;
    self.text = nil;
    [super dealloc];
}

- (NSString*) description
{
    return [[self dictionary] description];
}

- (NSDictionary*) dictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    NSMutableArray* array = [NSMutableArray array];
    for (XmlElement* element in self.children)
    {
        [array addObject:[element dictionary]];
    }
    
    [dictionary setValue:self.name forKey:@"name"];
    
    if (![self.text isEqualToString:@""])
    {
        [dictionary setValue:self.text forKey:@"text"];
    }
    
    if ([self.attributes count] > 0)
    {
        [dictionary setValue:self.attributes forKey:@"attributes"];
    }
    
    if ([array count] > 0)
    {
        [dictionary setValue:array forKey:@"children"];
    }
    
    return dictionary;
}

- (XmlElement*) element:(NSString*) name_
{
    for (XmlElement* child in self.children)
    {
        if ([name_ isEqualToString:child.name])
        {
            return child;
        }
    }
    
    return nil;
}

- (NSArray*) elements:(NSString*) name_
{
    NSMutableArray* array = [NSMutableArray array];
    for (XmlElement* child in self.children)
    {
        if ([name_ isEqualToString:child.name])
        {
            [array addObject:child];
        }
    }
    
    return array;
}

@end
