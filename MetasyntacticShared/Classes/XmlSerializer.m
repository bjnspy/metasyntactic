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

#import "NSMutableString+Utilities.h"
#import "XmlDocument.h"
#import "XmlElement.h"

@implementation XmlSerializer

+ (NSString*) sanitizeNonQuotedString:(NSString*) orig {
  NSString* sanitized;
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
                   indent:(BOOL) indent
                    level:(NSInteger) level
               withBuffer:(NSMutableString*) buffer {
  if (node == nil) {
    return;
  }

  if (indent) {
    [buffer appendString:@" " repeat:level];
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

  if (node.children.count == 0 && node.text.length == 0) {
    [buffer appendString:@"/>"];
    return;
  }

  [buffer appendString:@">"];
  if (node.text.length > 0)  {
    if (indent) {
      [buffer appendString:@"\n"];
      [buffer appendString:@" " repeat:level + 1];
    }
    [buffer appendString:[XmlSerializer sanitizeNonQuotedString:node.text]];
  }

  for (XmlElement* child in node.children) {
    if (indent) {
      [buffer appendString:@"\n"];
    }
    [XmlSerializer serializeElement:child
                             indent:indent
                              level:level + 1
                         withBuffer:buffer];
  }

  if (indent) {
    [buffer appendString:@"\n"];
    [buffer appendString:@" " repeat:level];
  }
  [buffer appendString:@"</"];
  [buffer appendString:node.name];
  [buffer appendString:@">"];
}


+ (void) serializeElement:(XmlElement*) node
                   indent:(BOOL) indent
               withBuffer:(NSMutableString*) buffer {
  [self serializeElement:node indent:indent level:0 withBuffer:buffer];
}


+ (NSString*) serializeElement:(XmlElement*) node
                        indent:(BOOL) indent {
  NSMutableString* buffer = [NSMutableString string];
  [self serializeElement:node indent:indent withBuffer:buffer];
  return buffer;
}


+ (NSString*) serializeElement:(XmlElement*) node {
  return [self serializeElement:node indent:YES];
}


+ (NSString*) serializeDocument:(XmlDocument*) document indent:(BOOL) indent {
  NSMutableString* buffer = [NSMutableString string];
  [buffer appendString:@"<?xml"];

  if (document.version.length > 0) {
    [XmlSerializer serializeAttribute:@"version" value:document.version withBuffer:buffer];
  }

  if (document.encoding.length > 0) {
    [XmlSerializer serializeAttribute:@"encoding" value:document.encoding withBuffer:buffer];
  }

  [buffer appendString:@"?>"];

  if (document.root != nil) {
    if (indent) {
      [buffer appendString:@"\n"];
    }
    [XmlSerializer serializeElement:document.root indent:indent withBuffer:buffer];
  }

  return buffer;
}


+ (NSString*) serializeDocument:(XmlDocument*) document {
  return [self serializeDocument:document indent:YES];
}

@end
