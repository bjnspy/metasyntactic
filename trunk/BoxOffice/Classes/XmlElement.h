//
//  XmlElement.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface XmlElement : NSObject {
    NSString* name;
    NSDictionary* attributes;
    NSArray* children;
    // the text between the start and end tags (not counting the child elements)
    NSString* text;
}

@property (copy) NSString* name;
@property (assign) NSDictionary* attributes;
@property (assign) NSArray* children;
@property (copy) NSString* text;

- (id) initWithName:(NSString*) name
         attributes:(NSDictionary*) attributes
           children:(NSArray*) children
               text:(NSString*) text;

- (void) dealloc;

- (NSString*) description;
- (NSDictionary*) dictionary;

- (XmlElement*) element:(NSString*) name;

@end
