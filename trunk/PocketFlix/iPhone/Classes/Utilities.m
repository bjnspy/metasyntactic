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

#import "Utilities.h"

#import "DateUtilities.h"
#import "Model.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation Utilities


+ (id) findSmallestElementInArray:(NSArray*) array
                    usingFunction:(NSInteger(*)(id, id, void*)) comparator
                          context:(void*) context {
    if (array.count == 0) {
        return nil;
    }

    id value = [array objectAtIndex:0];

    for (NSInteger i = 1; i < array.count; i++) {
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
    if (array.count == 0) {
        return nil;
    }

    id value = [array objectAtIndex:0];

    for (NSInteger i = 1; i < array.count; i++) {
        id current = [array objectAtIndex:i];

        NSComparisonResult result = comparator(value, current, context1, context2);
        if (result == NSOrderedDescending) {
            value = current;
        }
    }

    return value;
}


+ (NSString*) titleForMovie:(XmlElement*) element {
    if ([element attributeValue:@"year"] == nil) {
        return [element attributeValue:@"name"];
    } else {
        return [NSString stringWithFormat:@"%@ (%@)", [element attributeValue:@"name"], [element attributeValue:@"year"]];
    }
}


+ (XmlElement*) makeSoapRequest:(XmlElement*) element
                          atUrl:(NSString*) urlString
                         atHost:(NSString*) host
                     withAction:(NSString*) soapAction {

    XmlDocument* document = [XmlDocument documentWithRoot:element];
    NSString* post = [XmlSerializer serializeDocument:document];
    NSData* postData = [post dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];

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
    NSInteger index = rand() % array.count;
    id value = [array objectAtIndex:index];
    [array removeObjectAtIndex:index];

    return value;
}


+ (NSDictionary*) nonNilDictionary:(NSDictionary*) dictionary {
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }

    return dictionary;
}


+ (NSArray*) nonNilArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }

    return array;
}

@end