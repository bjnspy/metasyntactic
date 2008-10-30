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

#import "XmlSerializer.h"

#import "XmlDocument.h"
#import "XmlElement.h"

@implementation XmlSerializer

+ (NSString*) sanitizeNonQuotedString:(NSString*) orig {
    NSString* sanitized = [NSString string];
    sanitized = [orig stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    sanitized = [sanitized stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    sanitized = [sanitized stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return sanitized;
}


+ (void) serializeAttribute:(NSString*) key
                      value:(NSString*) value
                 withBuffer:(NSMutableString*) buffer {
    [buffer appendString:@" "];
    [buffer appendString:key];
    [buffer appendString:@"=\""];
    [buffer appendString:[value stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]];
    [buffer appendString:@"\""];
}


+ (void) serializeElement:(XmlElement*) node
               withBuffer:(NSMutableString*) buffer {
    if (node == nil) {
        return;
    }

    [buffer appendString:@"<"];
    [buffer appendString:node.name];
    if (node.attributes.count > 0) {
        for (NSString* key in node.attributes) {
            [XmlSerializer serializeAttribute:key
                                        value:[node.attributes valueForKey:key]
                                   withBuffer:buffer];
        }
    }

    if (node.children.count == 0 && node.text == nil) {
        [buffer appendString:@"/>"];
        return;
    }

    [buffer appendString:@">"];
    if (node.text != nil)  {
        [buffer appendString:[XmlSerializer sanitizeNonQuotedString:node.text]];
    }

    for (XmlElement* child in node.children) {
        [XmlSerializer serializeElement:child withBuffer:buffer];
    }

    [buffer appendString:@"</"];
    [buffer appendString:node.name];
    [buffer appendString:@">"];
}


+ (NSString*) serializeElement:(XmlElement*) node  {
    NSMutableString* buffer = [NSMutableString string];
    [self serializeElement:node withBuffer:buffer];
    return buffer;
}


+ (NSString*) serializeDocument:(XmlDocument*) document {
    NSMutableString* serialized = [NSMutableString string];
    [serialized appendString:@"<?xml"];

    if (document.version != nil) {
        [XmlSerializer serializeAttribute:@"version" value:document.version withBuffer:serialized];
    }

    if (document.encoding != nil) {
        [XmlSerializer serializeAttribute:@"encoding" value:document.encoding withBuffer:serialized];
    }

    [serialized appendString:@"?>"];

    if (document.root != nil) {
        [XmlSerializer serializeElement:document.root withBuffer:serialized];
    }

    return serialized;
}


@end