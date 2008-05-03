//
//  XmlParser.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser

@synthesize parser;
@synthesize elementsStack;
@synthesize stringBufferStack;
@synthesize attributesStack;

- (id) initWithData:(NSData*) data
{
    if (self = [super init])
    {
        self.parser = [[NSXMLParser alloc] initWithData:data];
        self.parser.delegate = self;
        
        self.elementsStack = [NSMutableArray array];
        self.stringBufferStack = [NSMutableArray array];
        
        [self.elementsStack addObject:[NSMutableArray array]];
        
        [self.parser parse];
    }
    
    return self;
}

- (void) dealloc
{
    self.parser = nil;
    [super dealloc];
}

+ (XmlElement*) parse:(NSData*) data
{
    XmlParser* xmlParser = [[[XmlParser alloc] initWithData:data] autorelease];
    return [[xmlParser.elementsStack lastObject] lastObject];
}

- (void)            parser:(NSXMLParser*) parser
           didStartElement:(NSString*) elementName
              namespaceURI:(NSString*) namespaceURI
             qualifiedName:(NSString*) qName
                attributes:(NSDictionary*) attributeDict
{
    [self.elementsStack addObject:[NSMutableArray array]];
    [self.stringBufferStack addObject:[NSMutableString string]];
    [self.attributesStack addObject:attributeDict];
}

- (void)            parser:(NSXMLParser*) parser
             didEndElement:(NSString*) elementName
              namespaceURI:(NSString*) namespaceURI
             qualifiedName:(NSString*) qName
{
    NSArray* children = [self.elementsStack lastObject];
    NSString* text = [self.stringBufferStack lastObject];
    NSDictionary* attributes = [self.attributesStack lastObject];
    
    [self.elementsStack removeLastObject];
    [self.stringBufferStack removeLastObject];
    [self.attributesStack removeLastObject];
    
    XmlElement* element = [[[XmlElement alloc] initWithName:elementName
                                                 attributes:attributes
                                                   children:children
                                                       text:text] autorelease];
    
    [[self.elementsStack lastObject] addObject:element];
}

- (void)            parser:(NSXMLParser*) parser
           foundCharacters:(NSString*) string
{
    [[self.stringBufferStack lastObject] appendString:string];
}

@end
