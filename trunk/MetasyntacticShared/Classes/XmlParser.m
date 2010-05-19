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
  xmlParser.delegate = (id)self;

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
