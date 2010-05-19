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
