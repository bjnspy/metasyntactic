// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "XmlSerializer.h"

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