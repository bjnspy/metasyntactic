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