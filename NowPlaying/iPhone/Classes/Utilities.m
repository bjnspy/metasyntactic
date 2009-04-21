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

#import "Performance.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation Utilities

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


+ (NSString*) generateShowtimeLinks:(Model*) model
                              movie:(Movie*) movie
                            theater:(Theater*) theater
                       performances:(NSArray*) performances {
    NSMutableString* body = [NSMutableString string];

    for (int i = 0; i < performances.count; i++) {
        if (i != 0) {
            [body appendString:@", "];
        }

        Performance* performance = [performances objectAtIndex:i];

        if (performance.url.length == 0) {
            [body appendString:performance.timeString];
        } else {
            [body appendString:@"<a href=\""];
            [body appendString:performance.url];
            [body appendString:@"\">"];
            [body appendString:performance.timeString];
            [body appendString:@"</a>"];
        }
    }

    return body;
}

@end