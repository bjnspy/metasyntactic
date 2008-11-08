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
    if (self = [super init]) {
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
    for (int i = 0; atts[i] != NULL; i += 2) {
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


void characterDataHandler(void *userData,
                          const XML_Char *s,
                          int len) {
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

    int result = XML_Parse(parser, data.bytes, data.length, 1 /*isFinal*/);
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