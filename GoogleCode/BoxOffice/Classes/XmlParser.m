// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "XmlParser.h"

#import "Utilities.h"
#import "XmlElement.h"

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
    return [self parse:[Utilities dataWithContentsOfAddress:url]];
}


- (void)       parser:(NSXMLParser*) parser
      didStartElement:(NSString*) elementName
         namespaceURI:(NSString*) namespaceURI
        qualifiedName:(NSString*) qName
           attributes:(NSDictionary*) attributeDict {
    [self.elementsStack addObject:[NSMutableArray array]];
    [self.stringBufferStack addObject:[NSMutableString string]];
    [self.attributesStack addObject:[NSDictionary dictionaryWithDictionary:attributeDict]];
}


- (void)     parser:(NSXMLParser*) parser
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


- (void)       parser:(NSXMLParser*) parser
      foundCharacters:(NSString*) string {
    if (string == nil) {
        return;
    }

    [[self.stringBufferStack lastObject] appendString:string];
}


@end
