//
//  Utilities.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Utilities.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation Utilities

+ (BOOL) isNilOrEmpty:(NSString*) string {
    return string == nil || [@"" isEqual:string];
}

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void *)) comparator
                          context:(void*) context {
    if ([array count] == 0) {
        return nil;
    }
    
    id value = [array objectAtIndex:0];
    
    for (NSInteger i = 1; i < [array count]; i++) {
        id current = [array objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;
}

+ (id) findSmallestElementInArray:(NSArray*) array 
                    usingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                         context1:(void*) context1
                         context2:(void*) context2 {
    if ([array count] == 0) {
        return nil;
    }
    
    id value = [array objectAtIndex:0];
    
    for (NSInteger i = 1; i < [array count]; i++) {
        id current = [array objectAtIndex:i];
        
        NSComparisonResult result = comparator(value, current, context1, context2);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }
    
    return value;    
}

+ (NSString*) titleForMovie:(XmlElement*) element {
    return [NSString stringWithFormat:@"%@ (%@)", [element attributeValue:@"name"], [element attributeValue:@"year"]];    
}

+ (NSString*) titleForPerson:(XmlElement*) element {
    return [NSString stringWithFormat:@"%@ %@", [element attributeValue:@"firstName"], [element attributeValue:@"lastName"]];
}

+ (NSData*) downloadData:(NSString*) urlString {
    if (urlString == nil) {
        return nil;
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 120;
    
    NSError* httpError = nil;
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&httpError];
    
    if (httpError != nil) {
        return nil;
    }
    
    return data;
}

+ (XmlElement*) downloadXml:(NSString*) urlString {
    NSData* data = [self downloadData:urlString];
    if (data == nil) {
        return nil;
    }
    
    return [XmlParser parse:data];
}

+ (XmlElement*) makeSoapRequest:(XmlElement*) element
                          atUrl:(NSString*) urlString
                         atHost:(NSString*) host
                     withAction:(NSString*) soapAction {
    
    XmlDocument* document = [XmlDocument documentWithRoot:element];
    NSString* post = [XmlSerializer serializeDocument:document];    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:soapAction forHTTPHeaderField:@"Soapaction"];
    [request setValue:host forHTTPHeaderField:@"Host"];
    
    [request setHTTPBody:postData];    
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* result =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if (error != nil) {
        return nil;
    }
    
    return [XmlParser parse:result];    
}

+ (id) removeRandomElement:(NSMutableArray*) array {
    NSInteger index = rand() % [array count];
    id value = [array objectAtIndex:index];
    [array removeObjectAtIndex:index];
    
    return value;
}

@end
