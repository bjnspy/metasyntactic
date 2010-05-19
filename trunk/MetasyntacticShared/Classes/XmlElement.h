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

@interface XmlElement : NSObject {
@private
  NSString* name;
  NSDictionary* attributes;
  NSArray* children;
  // the text between the start and end tags (not counting the child elements)
  NSString* text;
}

@property (readonly, copy) NSString* name;
@property (readonly, retain) NSDictionary* attributes;
@property (readonly, retain) NSArray* children;
@property (readonly, copy) NSString* text;

+ (id) elementWithName:(NSString*) name;

+ (id) elementWithName:(NSString*) name
            attributes:(NSDictionary*) attributes;

+ (id) elementWithName:(NSString*) name
              children:(NSArray*) children;

+ (id) elementWithName:(NSString*) name
                 child:(XmlElement*) child;

+ (id) elementWithName:(NSString*) name
                  text:(NSString*) text;

+ (id) elementWithName:(NSString*) name
            attributes:(NSDictionary*) attributes
              children:(NSArray*) children;

+ (id) elementWithName:(NSString*) name
            attributes:(NSDictionary*) attributes
                  text:(NSString*) text;

+ (id) elementWithName:(NSString*) name
              children:(NSArray*) children
                  text:(NSString*) text;

+ (id) elementWithName:(NSString*) name
            attributes:(NSDictionary*) attributes
              children:(NSArray*) children
                  text:(NSString*) text;

- (id) initWithName:(NSString*) name
         attributes:(NSDictionary*) attributes
           children:(NSArray*) children
               text:(NSString*) text;

- (NSString*) description;

- (NSDictionary*) dictionary;
+ (XmlElement*) elementWithDictionary:(NSDictionary*) dictionary;

- (XmlElement*) element:(NSString*) name;
- (XmlElement*) element:(NSString*) name recurse:(BOOL) recurse;
- (NSArray*) elements:(NSString*) name;
- (NSArray*) elements:(NSString*) name recurse:(BOOL) recurse;

- (XmlElement*) elementAtIndex:(NSInteger) index;

- (NSString*) attributeValue:(NSString*) key;

- (NSString*) toXmlString;
- (NSString*) toXmlString:(BOOL) indent;

@end
