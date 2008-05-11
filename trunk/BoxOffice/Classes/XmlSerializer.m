//
//  XmlSerializer.m
//  BoxOffice
//
//  Created by Peter Schmitt on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "XmlSerializer.h"

@implementation XmlSerializer

+ (NSString*) sanitizeNonQuotedString:(NSString*) orig
{
    NSString* sanitized = [NSString string];
    sanitized = [orig stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];  
    sanitized = [sanitized stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    sanitized = [sanitized stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return sanitized;
}

+ (NSString*) serializeAttribute:(NSString*) key 
                           value:(NSString*) value
{
    NSMutableString* serialized = [NSMutableString string];
    [serialized appendString:@" "];
    [serialized appendString:key];
    [serialized appendString:@"=\""];
    [serialized appendString:[value stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]];
    [serialized appendString:@"\""];
    return serialized;
}


+ (NSString*) serializeElement:(XmlElement*) node 
{
    if (node == nil) {
        return @"";
    }
    
    NSMutableString* serialized = [NSMutableString string];
    [serialized appendString:@"<"];
    [serialized appendString:node.name];
    if ([node.attributes count] > 0)
    {        
        for (NSString* key in node.attributes) 
        {
            [serialized appendString:
             [XmlSerializer serializeAttribute:key value:[node.attributes valueForKey:key]]];
        }
    }
    
    if ([node.children count] == 0 && node.text == nil)
    {
        [serialized appendString:@"/>"];
        return serialized;
    }
    
    [serialized appendString:@">"];
    if (node.text != nil) 
    {
        [serialized appendString:[XmlSerializer sanitizeNonQuotedString:node.text]];
    }
    
    for (XmlElement* child in node.children)
    {
        [serialized appendString:[self serializeElement:child]];
    }
    [serialized appendString:@"</"];
    [serialized appendString:node.name];
    [serialized appendString:@">"];
    return serialized;
}

+ (NSString*) serializeDocument:(XmlDocument*) document
{
    NSMutableString* serialized = [NSMutableString string];
    [serialized appendString:@"<?xml"];
    
    if (document.version != nil) 
    {
        [serialized appendString:[XmlSerializer serializeAttribute:@"version" value:document.version]];
    }
    
    if (document.encoding != nil)
    {
        [serialized appendString:[XmlSerializer serializeAttribute:@"encoding" value:document.encoding]];
    }
    
    [serialized appendString:@"?>"];
    
    if (document.root != nil)
    {
        [serialized appendString:[XmlSerializer serializeElement:document.root]];
    }
    return serialized;
}

@end
