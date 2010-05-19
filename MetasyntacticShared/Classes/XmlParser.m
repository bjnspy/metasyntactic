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

#import "XmlElement.h"

@interface XmlParser()
@property (retain) NSMutableArray* elementsStack;
@property (retain) NSMutableArray* stringBufferStack;
@property (retain) NSMutableArray* attributesStack;
@end


@implementation XmlParser

static NSLock* gate = nil;

+ (void) initialize {
  if (self == [XmlParser class]) {
    gate = [[NSRecursiveLock alloc] init];
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


NSString* makeString(const XML_Char* string) {
  return [[[NSString alloc] initWithBytes:string length:strlen(string) encoding:NSUTF8StringEncoding] autorelease];
}


void startElementHandler(void* userData,
                         const XML_Char* name,
                         const XML_Char** atts) {
  XmlParser* parser = userData;

  [parser.elementsStack addObject:[NSMutableArray array]];
  [parser.stringBufferStack addObject:[NSMutableString string]];

  NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
  for (NSInteger i = 0; atts[i] != NULL; i += 2) {
    NSString* key = makeString(atts[i]);
    NSString* value = makeString(atts[i + 1]);
    [attributes setObject:value forKey:key];
  }

  [parser.attributesStack addObject:attributes];
}


void endElementHandler(void* userData,
                       const XML_Char* name) {
  XmlParser* parser = userData;

  NSArray* children = parser.elementsStack.lastObject;
  NSString* text = parser.stringBufferStack.lastObject;
  NSDictionary* attributes = parser.attributesStack.lastObject;

  [parser.elementsStack removeLastObject];
  [parser.stringBufferStack removeLastObject];
  [parser.attributesStack removeLastObject];

  NSString* elementName = makeString(name);
  XmlElement* element = [XmlElement elementWithName:elementName
                                         attributes:attributes
                                           children:children
                                               text:text];

  [parser.elementsStack.lastObject addObject:element];
}


void characterDataHandler(void* userData,
                          const XML_Char* s,
                          NSInteger len) {
  XmlParser* parser = userData;
  if (s != NULL) {
    NSString* string = [[[NSString alloc] initWithBytes:s length:len encoding:NSUTF8StringEncoding] autorelease];

    [parser.stringBufferStack.lastObject appendString:string];
  }
}


- (XmlElement*) run:(NSData*) data {
  self.elementsStack = [NSMutableArray array];
  self.stringBufferStack = [NSMutableArray array];
  self.attributesStack = [NSMutableArray array];

  [elementsStack addObject:[NSMutableArray array]];


  XML_Parser parser = XML_ParserCreate(NULL);
  XML_SetElementHandler(parser, startElementHandler, endElementHandler);
  XML_SetCharacterDataHandler(parser, characterDataHandler);
  XML_SetUserData(parser, self);

  NSInteger result = XML_Parse(parser, data.bytes, data.length, 1 /*isFinal*/);
  if (result == 0) {
    NSInteger line = XML_GetCurrentLineNumber(parser);
    NSInteger column = XML_GetCurrentColumnNumber(parser);
    NSString* xmlText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Error at: %d, %d. Text:\n%@", line, column, xmlText);
  }
  XML_ParserFree(parser);

  if (result == 0) {
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

  XmlElement* result = nil;

  [gate lock];
  {
    XmlParser* parser = [[XmlParser alloc] init];
    result = [parser run:data];
    [parser release];
  }
  [gate unlock];

  return result;
}

@end
