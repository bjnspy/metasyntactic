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

#import "Utilities.h"

#import "Performance.h"

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

  for (NSInteger i = 0; i < performances.count; i++) {
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
