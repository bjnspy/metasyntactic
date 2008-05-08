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

+ (id) elementWithName:(NSString*) name;

+ (id) elementWithName:(NSString*) name 
			attributes:(NSDictionary*) attributes;

+ (id) elementWithName:(NSString*) name 
			  children:(NSArray*) children;

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

- (void) dealloc;

- (NSString*) description;
- (NSDictionary*) dictionary;

- (XmlElement*) element:(NSString*) name;
- (NSArray*) elements:(NSString*) name;

- (XmlElement*) elementAtIndex:(NSInteger) index;

@end
