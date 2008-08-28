// Copyright (C) 2008 Cyrus Najmabadi
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

#import "Utilities.h"

#import "NowPlayingModel.h"
#import "DataProvider.h"
#import "Performance.h"
#import "Theater.h"
#import "XmlDocument.h"
#import "XmlElement.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation Utilities

+ (BOOL) isNilOrEmpty:(NSString*) string {
    return string == nil || [@"" isEqual:string];
}


+ (id) findSmallestElementInArray:(NSArray*) array
                    usingFunction:(NSInteger(*)(id, id, void *)) comparator
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


+ (XmlElement*) downloadXml:(NSString*) urlString {
    NSData* data = [Utilities dataWithContentsOfAddress:urlString];
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
    NSData *postData = [post dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];

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


+ (NSInteger) hashString:(NSString*) string {
    if (string.length == 0) {
        return 0;
    }

    int result = [string characterAtIndex:0];
    for (int i = 1; i < string.length; i++) {
        result = 31 * result + [string characterAtIndex:i];
    }

    return result;
}


+ (NSArray*) nonNilArray:(NSArray*) array {
    if (array == nil) {
        return [NSArray array];
    }

    return array;
}


+ (NSString*) nonNilString:(NSString*) string {
    if (string == nil) {
        return @"";
    }

    return string;
}


+ (void) writeObject:(id) object toFile:(NSString*) file {
    NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:object
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                         errorDescription:NULL];
    if(plistData) {
        [plistData writeToFile:file atomically:YES];
    }
}


+ (id) readObject:(NSString*) file {
    NSData* data = [NSData dataWithContentsOfFile:file];
    if (data == nil) {
        return nil;
    }

    return [NSPropertyListSerialization propertyListFromData:data
                                            mutabilityOption:NSPropertyListImmutable
                                                      format:NULL
                                            errorDescription:NULL];
}


+ (NSString*)                      string:(NSString*) string
      byAddingPercentEscapesUsingEncoding:(NSStringEncoding) encoding {
    string = [string stringByAddingPercentEscapesUsingEncoding:encoding];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    return string;
}


+ (NSString*) stringByAddingPercentEscapes:(NSString*) string {
    return [self string:string byAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
}


+ (NSString*) generateShowtimeLinks:(BoxOfficeModel*) model
                              movie:(Movie*) movie
                            theater:(Theater*) theater
                       performances:(NSArray*) performances {
    NSMutableString* body = [NSMutableString string];

    for (int i = 0; i < performances.count; i++) {
        if (i != 0) {
            [body appendString:@", "];
        }

        Performance* performance = [performances objectAtIndex:i];

        if (![theater.sellsTickets isEqual:@"True"] ||
            [Utilities isNilOrEmpty:performance.identifier]) {
            [body appendString:performance.time];
        } else {
            NSString* url = [[model currentDataProvider] ticketingUrlForTheater:theater
                                                                          movie:movie
                                                                    performance:performance
                                                                           date:model.searchDate];

            [body appendString:@"<a href=\""];
            [body appendString:url];
            [body appendString:@"\">"];
            [body appendString:performance.time];
            [body appendString:@"</a>"];
        }
    }

    return body;
}


+ (NSString*) stringWithContentsOfAddress:(NSString*) address {
    if (address == nil) {
        return nil;
    }

    return [Utilities stringWithContentsOfUrl:[NSURL URLWithString:address]];
}


+ (NSString*) stringWithContentsOfUrl:(NSURL*) url {
    if (url == nil) {
        return nil;
    }

    NSData* data = [Utilities dataWithContentsOfUrl:url];
    if (data == nil) {
        return nil;
    }

    //return [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
    NSString* result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (result != nil) {
        return result;
    }

    return [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address {
    if (address == nil) {
        return nil;
    }

    return [Utilities dataWithContentsOfUrl:[NSURL URLWithString:address]];
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url {
    if (url == nil) {
        return nil;
    }

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 120;
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];

    NSURLResponse* response = nil;
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];

    if (error != nil) {
        return nil;
    }

    return data;
}


+ (NSString*) stripHtmlCodes:(NSString*) string {
    if (string == nil) {
        return @"";
    }

    NSArray* htmlCodes = [NSArray arrayWithObjects:@"em", @"p", @"b", @"i", @"br", nil];

    for (NSString* code in htmlCodes) {
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", code] withString:@""];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", code] withString:@""];
    }

    return string;
}


@end