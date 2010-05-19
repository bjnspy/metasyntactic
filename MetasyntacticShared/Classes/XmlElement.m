// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "XmlElement.h"

#import "XmlSerializer.h"

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
                 child:(XmlElement*) child_ {
  return [XmlElement elementWithName:name_ children:[NSArray arrayWithObject:child_]];
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
  if ((self = [super init])) {
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
  return [self element:name_ recurse:NO];
}


- (XmlElement*) element:(NSString*) name_ recurse:(BOOL) recurse {
  for (XmlElement* child in children) {
    if ([name_ isEqualToString:child.name]) {
      return child;
    }
  }

  if (recurse) {
    XmlElement* result;
    for (XmlElement* child in children) {
      result = [child element:name_ recurse:recurse];
      if (result != nil) {
        return result;
      }
    }
  }

  return nil;
}


- (NSArray*) elements:(NSString*) name_ {
  return [self elements:name_ recurse:NO];
}


- (void) elements:(NSString*) name_
          recurse:(BOOL) recurse
           result:(NSMutableArray*) result {
  for (XmlElement* child in children) {
    if ([name_ isEqualToString:child.name]) {
      [result addObject:child];
    }
  }

  if (recurse) {
    for (XmlElement* child in children) {
      [child elements:name_ recurse:recurse result:result];
    }
  }
}


- (NSArray*) elements:(NSString*) name_
              recurse:(BOOL) recurse {
  NSMutableArray* result = [NSMutableArray array];

  [self elements:name_ recurse:recurse result:result];

  return result;
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


- (NSString*) toXmlString {
  return [self toXmlString:YES];
}


- (NSString*) toXmlString:(BOOL) indent {
  return [XmlSerializer serializeElement:self indent:indent];
}

@end
