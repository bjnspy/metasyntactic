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
