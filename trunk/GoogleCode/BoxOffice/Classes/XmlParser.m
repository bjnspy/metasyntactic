//
//  XmlParser.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser

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
    
    [self.elementsStack addObject:[NSMutableArray array]];
    
    if ([parser parse] == NO) {
        self.elementsStack = nil;
        NSLog(@"%@", [parser parserError]);
    }
}

- (id) initWithData:(NSData*) data {
    if (self = [super init]) {
        NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
        [self run:parser];
    }

    return self;
}

- (id) initWithUrl:(NSString*) url {
    if (self = [super init]) {
        NSXMLParser* parser = [[[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        [self run:parser];
    }
    
    return self;
}

+ (XmlElement*) collect:(XmlParser*) parser {
    if (parser.elementsStack == nil) {
        return nil;
    }
    
    return [[parser.elementsStack lastObject] lastObject];  
}

+ (XmlElement*) parse:(NSData*) data {
    if (data == nil) {
        return nil;
    }

    XmlParser* xmlParser = [[[XmlParser alloc] initWithData:data] autorelease];
    return [XmlParser collect:xmlParser];
}

+ (XmlElement*) parseUrl:(NSString*) url {
    if (url == nil) {
        return nil;
    }
    
    XmlParser* xmlParser = [[[XmlParser alloc] initWithUrl:url] autorelease];
    return [XmlParser collect:xmlParser];
}

- (void)            parser:(NSXMLParser*) parser
           didStartElement:(NSString*) elementName
              namespaceURI:(NSString*) namespaceURI
             qualifiedName:(NSString*) qName
                attributes:(NSDictionary*) attributeDict {
    [self.elementsStack addObject:[NSMutableArray array]];
    [self.stringBufferStack addObject:[NSMutableString string]];
    [self.attributesStack addObject:[NSDictionary dictionaryWithDictionary:attributeDict]];
}

- (void)            parser:(NSXMLParser*) parser
             didEndElement:(NSString*) elementName
              namespaceURI:(NSString*) namespaceURI
             qualifiedName:(NSString*) qName {
    NSArray* children = [self.elementsStack lastObject];
    NSString* text = [self.stringBufferStack lastObject];
    NSDictionary* attributes = [self.attributesStack lastObject];

    [self.elementsStack removeLastObject];
    [self.stringBufferStack removeLastObject];
    [self.attributesStack removeLastObject];

    XmlElement* element = [XmlElement elementWithName:elementName
                                           attributes:attributes
                                             children:children
                                                 text:text];

    [[self.elementsStack lastObject] addObject:element];
}

- (void)            parser:(NSXMLParser*) parser
           foundCharacters:(NSString*) string {
    if (string == nil) {
        return;
    }
    
    [[self.stringBufferStack lastObject] appendString:string];
}

@end
