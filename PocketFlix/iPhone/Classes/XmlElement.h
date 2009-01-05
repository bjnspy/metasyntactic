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
- (NSArray*) elements:(NSString*) name;

- (XmlElement*) elementAtIndex:(NSInteger) index;

- (NSString*) attributeValue:(NSString*) key;

@end