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

#import "Logger.h"
#import "XmlElement.h"

@interface XmlParser()
@property (retain) NSMutableArray* elementsStack;
@property (retain) NSMutableArray* stringBufferStack;
@property (retain) NSMutableArray* attributesStack;
@end


@implementation XmlParser

+ (void) initialize {
  if (self == [XmlParser class]) {
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


- (id) init {
  if ((self = [super init])) {
  }
  
  return self;
}


+ (XmlParser*) parser {
  return [[[XmlParser alloc] init] autorelease];
}


- (void)     parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qualifiedName
         attributes:(NSDictionary *)attributes {
  [elementsStack addObject:[NSMutableArray array]];
  [stringBufferStack addObject:[NSMutableString string]];
  [attributesStack addObject:attributes];
}


- (void)     parser:(NSXMLParser *)parser
      didEndElement:(NSString *)elementName 
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName {
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


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  [stringBufferStack.lastObject appendString:string];
}


- (XmlElement*) run:(NSData*) data {
  NSXMLParser* xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
  xmlParser.delegate = self;
  
  self.elementsStack = [NSMutableArray array];
  self.stringBufferStack = [NSMutableArray array];
  self.attributesStack = [NSMutableArray array];
  
  [elementsStack addObject:[NSMutableArray array]];
  
  BOOL result = [xmlParser parse];
  
  if (!result) {
    [Logger log:[NSString stringWithFormat:@"Parse error occurred: %@", xmlParser.parserError]];
    return nil;
  }
  
  if (elementsStack.count == 0) {
    return nil;
  }
  
  NSArray* array = elementsStack.lastObject;
  if (array.count == 0) {
    return nil;
  }
  
  return array.lastObject;
}


+ (XmlElement*) parse:(NSData*) data {
  if (data == nil || data.length == 0) {
    return nil;
  }
  
  XmlParser* parser = [[[XmlParser alloc] init] autorelease];
  XmlElement* result = [parser run:data];
  
  return result;
}

@end
