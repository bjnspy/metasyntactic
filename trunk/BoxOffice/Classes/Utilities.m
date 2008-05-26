//
//  Utilities.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Utilities.h"
#import "XmlParser.h"

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
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 120;
    
    NSError* httpError = nil;
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&httpError];
    
    if (httpError == nil && data != nil) {
        return data;
    }
    
    return nil;
}

+ (XmlElement*) downloadXml:(NSString*) urlString {
    NSData* data = [self downloadData:urlString];
    if (data == nil) {
        return nil;
    }
    
    return [XmlParser parse:data];
}

@end
