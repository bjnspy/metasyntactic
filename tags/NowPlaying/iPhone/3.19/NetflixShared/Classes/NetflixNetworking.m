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

@interface NetflixNetworking()
@property (retain) NSNumber* timeDrift;
@end

@implementation NetflixNetworking

static NetflixNetworking* networking = nil;

+ (void) initialize {
  if (self == [NetflixNetworking class]) {
    networking = [[NetflixNetworking alloc] init];
  }
}

@synthesize timeDrift;


- (void) dealloc {
  self.timeDrift = nil;
  [super dealloc];
}

- (NSInteger) computeTimeDrift {
  NSString* address = [NSString stringWithFormat:@"http://api.netflix.com/oauth/clock/time?oauth_consumer_key=%@", [NetflixAuthentication key]];
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO];  
  XmlElement* statusElement = [element element:@"status_code"];
  if (statusElement != nil) {
    return 0;
  }
  
  NSInteger serverTime = [[element text] integerValue];
  if (serverTime == 0) {
    return 0;
  }
  
  NSInteger localTime = time(NULL);
  
  return (serverTime - localTime);
}


- (NSString*) netflixTimestampWorker {
  if (timeDrift == nil) {
    self.timeDrift = [NSNumber numberWithInteger:[self computeTimeDrift]];
  }
  NSInteger value = time(NULL);
  value += timeDrift.integerValue;
  return [NSString stringWithFormat:@"%d", value];
}


- (NSString*) netflixTimestamp {
  NSString* result;
  [dataGate lock];
  {
    result = [self netflixTimestampWorker];
  }
  [dataGate unlock];
  return result;
}


+ (NSString*) netflixTimestamp {
  return [networking netflixTimestamp];
}


+ (OAMutableURLRequest*) createURLRequest:(NSString*) address account:(NetflixAccount*) acccount {
  OAConsumer* consumer = [OAConsumer consumerWithKey:[NetflixAuthentication key]
                                              secret:[NetflixAuthentication secret]];

  OAToken* token = [OAToken tokenWithKey:acccount.key
                                  secret:acccount.secret];

  OAMutableURLRequest* request =
  [OAMutableURLRequest requestWithURL:[NSURL URLWithString:address]
                             consumer:consumer
                                token:token
                                realm:nil
                            timestamp:[self netflixTimestamp]];

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
