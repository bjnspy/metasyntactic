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

#import "NetflixNetworking.h"

#import "NetflixAccount.h"
#import "NetflixAuthentication.h"
#import "NetflixConstants.h"
#import "NetflixSiteStatus.h"
#import "NetflixUtilities.h"

@implementation NetflixNetworking

+ (OAMutableURLRequest*) createURLRequest:(NSString*) address account:(NetflixAccount*) acccount {
  OAConsumer* consumer = [OAConsumer consumerWithKey:[NetflixAuthentication key]
                                              secret:[NetflixAuthentication secret]];

  OAToken* token = [OAToken tokenWithKey:acccount.key
                                  secret:acccount.secret];

  OAMutableURLRequest* request =
  [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                             consumer:consumer
                                token:token
                                realm:nil];

  return request;
}


+ (NSURLRequest*) createPostURLRequest:(NSString*) address parameters:(NSArray*) parameters account:(NetflixAccount*) account {
  OAMutableURLRequest* request = [self createURLRequest:address account:account];
  [request setHTTPMethod:@"POST"];

  [NSMutableURLRequestAdditions setParameters:parameters
                                   forRequest:request];

  [request prepare];
  return request;
}


+ (NSURLRequest*) createGetURLRequest:(NSString*) address parameters:(NSArray*) parameters account:(NetflixAccount*) account {
  OAMutableURLRequest* request = [self createURLRequest:address account:account];

  if (parameters.count > 0) {
    [NSMutableURLRequestAdditions setParameters:parameters
                                     forRequest:request];
  }

  [request prepare];
  return request;
}


+ (NSURLRequest*) createGetURLRequest:(NSString*) address parameter:(OARequestParameter*) parameter account:(NetflixAccount*) account {
  return [self createGetURLRequest:address
                        parameters:[NSArray arrayWithObject:parameter]
                           account:account];
}


+ (NSURLRequest*) createGetURLRequest:(NSString*) address account:(NetflixAccount*) account {
  return [self createGetURLRequest:address
                        parameters:nil
                           account:account];
}


+ (NSURLRequest*) createDeleteURLRequest:(NSString*) address account:(NetflixAccount*) account {
  OAMutableURLRequest* request = [self createURLRequest:address account:account];

  [request setHTTPMethod:@"DELETE"];
  [request prepare];

  return request;
}


+ (void) checkForEtagMismatch:(XmlElement*) element
                    outOfDate:(BOOL*) outOfDate {
  if (outOfDate != NULL) {
    *outOfDate = [NetflixUtilities etagOutOfDate:element];
  }
}


+ (XmlElement*) downloadXml:(NSURLRequest*) request
                    account:(NetflixAccount*) account
                   response:(NSHTTPURLResponse**) response
                  outOfDate:(BOOL*) outOfDate {
  XmlElement* element = [NetworkUtilities xmlWithContentsOfUrlRequest:request response:response];

  [self checkForEtagMismatch:element outOfDate:outOfDate];
  [[NetflixSiteStatus status] checkApiResult:element];

  return element;
}

@end
