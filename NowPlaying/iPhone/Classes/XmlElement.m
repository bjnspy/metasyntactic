// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "XmlElement.h"

@interface XmlElement()
@property (copy) NSString* name;
@property (retain) NSDictionary* attributes;
@property (retain) NSArray* children;
@property (copy) NSString* text;
@end


@implementation XmlElement

property_definition(name);
property_definition(attributes);
property_definition(children);
property_definition(text);

- (void) dealloc {
    self.name = nil;
    self.attributes = nil;
    self.children = nil;
    self.text = nil;

    [super dealloc];
}


+ (id) elementWithName:(NSString*) name_ {
    return [XmlElement elementWithName:name_ attributes:[NSDictionary dictionary] children:[NSArray array] text:[NSString string]];
}


+ (id) elementWithName:(NSString*) name_
            attributes:(NSDictionary*) attributes_ {
    return [XmlElement elementWithName:name_ attributes:attributes_ children:[NSArray array] text:[NSString string]];
}


+ (id) elementWithName:(NSString*) name_
                  text:(NSString*) text_ {
    return [XmlElement elementWithName:name_ attributes:[NSDictionary dictionary] children:[NSArray array] text:text_];
}


+ (id) elementWithName:(NSString*) name_
              children:(NSArray*) children_ {
    return [XmlElement elementWithName:name_ attributes:[NSDictionary dictionary] children:children_ text:[NSString string]];
}


+ (id) elementWithName:(NSString*) name_
            attributes:(NSDictionary*) attributes_
              children:(NSArray*) children_ {
    return [XmlElement elementWithName:name_ attributes:attributes_ children:children_ text:[NSString string]];
}


+ (id) elementWithName:(NSString*) name_
            attributes:(NSDictionary*) attributes_
                  text:(NSString*) text_ {
    return [XmlElement elementWithName:name_ attributes:attributes_ children:[NSArray array] text:text_];
}


+ (id) elementWithName:(NSString*) name_
              children:(NSArray*) children_
                  text:(NSString*) text_ {
    return [XmlElement elementWithName:name_ attributes:[NSDictionary dictionary] children:children_ text:text_];
}


+ (id) elementWithName:(NSString*) name_
            attributes:(NSDictionary*) attributes_
              children:(NSArray*) children_
                  text:(NSString*) text_ {
    return [[[XmlElement alloc] initWithName:name_ attributes:attributes_ children:children_ text:text_] autorelease];
}


- (id) initWithName:(NSString*) name_
         attributes:(NSDictionary*) attributes_
           children:(NSArray*) children_
               text:(NSString*) text_ {
    if (self = [super init]) {
        self.name = name_;
        self.attributes = attributes_;
        self.children = children_;
        self.text = text_;
    }

    return self;
}


- (NSString*) description {
    return [[self dictionary] description];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

    NSMutableArray* array = [NSMutableArray array];
    for (XmlElement* element in children) {
        [array addObject:element.dictionary];
    }

    [dictionary setValue:name forKey:name_key];

    if (![text isEqual:@""]) {
        [dictionary setValue:text forKey:text_key];
    }

    if (attributes.count > 0) {
        [dictionary setValue:attributes forKey:attributes_key];
    }

    if (array.count > 0) {
        [dictionary setValue:array forKey:children_key];
    }

    return dictionary;
}


+ (XmlElement*) elementWithDictionary:(NSDictionary*) dictionary {
    NSString* name = [dictionary valueForKey:name_key];
    if (name == nil) {
        name = @"";
    }

    NSString* text = [dictionary valueForKey:text_key];
    if (text == nil) {
        text = @"";
    }

    NSDictionary* attributes = [dictionary valueForKey:attributes_key];
    if (attributes == nil) {
        attributes = [NSDictionary dictionary];
    }

    NSArray* childDictionaries = [dictionary valueForKey:children_key];
    if (childDictionaries == nil) {
        childDictionaries = [NSArray array];
    }

    NSMutableArray* children = [NSMutableArray array];
    for (NSDictionary* childDict in childDictionaries) {
        [children addObject:[XmlElement elementWithDictionary:childDict]];
    }

    return [XmlElement elementWithName:name attributes:attributes children:children text:text];
}


- (XmlElement*) element:(NSString*) name_ {
    for (XmlElement* child in children) {
        if ([name_ isEqualToString:child.name]) {
            return child;
        }
    }

    return nil;
}


- (NSArray*) elements:(NSString*) name_ {
    NSMutableArray* array = [NSMutableArray array];
    for (XmlElement* child in children) {
        if ([name_ isEqualToString:child.name]) {
            [array addObject:child];
        }
    }

    return array;
}


- (XmlElement*) elementAtIndex:(NSInteger) index {
    if (index >= 0 && index < children.count) {
        return [[self children] objectAtIndex:index];
    }

    return nil;
}


- (NSString*) attributeValue:(NSString*) key {
    return [attributes valueForKey:key];
}

@end