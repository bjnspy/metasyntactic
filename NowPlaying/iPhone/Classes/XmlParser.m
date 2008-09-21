// Copyright (C) 2008 Cyrus Najmabadi
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

#import "XmlParser.h"

#import "XmlElement.h"

@implementation XmlParser

static NSLock* gate = nil;

+ (void) initialize {
    if (self == [XmlParser class]) {
        gate = [[NSLock alloc] init];
    }
}

@synthesize elementsStack;
@synthesize stringBufferStack;
@synthesize attributesStack;

- (void) dealloc {
    self.elementsStack = nil;
    self.stringBufferStack = nil;
    self.attributesStack = nil;

    [super dealloc];
}


- (void) run:(NSXMLParser*) parser {
    parser.delegate = self;

    self.elementsStack = [NSMutableArray array];
    self.stringBufferStack = [NSMutableArray array];
    self.attributesStack = [NSMutableArray array];

    [elementsStack addObject:[NSMutableArray array]];

    if ([parser parse] == NO) {
        self.elementsStack = nil;
        NSLog(@"%@", [parser parserError]);
    }
}


- (id) initWithData:(NSData*) data {
    if (self = [super init]) {
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
        [self run:parser];
        [parser release];
    }

    return self;
}


+ (XmlElement*) collect:(XmlParser*) parser {
    if (parser.elementsStack == nil) {
        return nil;
    }

    return [parser.elementsStack.lastObject lastObject];
}


+ (XmlElement*) parseWorker:(NSData*) data {
    if (data == nil) {
        return nil;
    }

    XmlParser* xmlParser = [[XmlParser alloc] initWithData:data];
    XmlElement* result = [XmlParser collect:xmlParser];
    [xmlParser release];

    return result;
}


+ (XmlElement*) parse:(NSData*) data {
    XmlElement* result = nil;

    [gate lock];
    {
        result = [self parseWorker:data];
    }
    [gate unlock];

    return result;
}


- (void)       parser:(NSXMLParser*) parser
      didStartElement:(NSString*) elementName
         namespaceURI:(NSString*) namespaceURI
        qualifiedName:(NSString*) qName
           attributes:(NSDictionary*) attributeDict {
    [elementsStack addObject:[NSMutableArray array]];
    [stringBufferStack addObject:[NSMutableString string]];
    [attributesStack addObject:[NSDictionary dictionaryWithDictionary:attributeDict]];
}


- (void)     parser:(NSXMLParser*) parser
      didEndElement:(NSString*) elementName
       namespaceURI:(NSString*) namespaceURI
      qualifiedName:(NSString*) qName {
    NSArray* children = elementsStack.lastObject;
    NSString* text = stringBufferStack.lastObject;
    NSDictionary* attributes = attributesStack.lastObject;

    [elementsStack removeLastObject];
    [stringBufferStack removeLastObject];
    [attributesStack removeLastObject];

    XmlElement* element = [XmlElement elementWithName:elementName
                                           attributes:attributes
                                             children:children
                                                 text:text];

    [elementsStack.lastObject addObject:element];
}


- (void)       parser:(NSXMLParser*) parser
      foundCharacters:(NSString*) string {
    if (string == nil) {
        return;
    }

    [stringBufferStack.lastObject appendString:string];
}


- (void)          parser:(NSXMLParser*) parser
      parseErrorOccurred:(NSError*) parseError {
    NSLog(@"%@", parseError);
}

@end