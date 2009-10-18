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

#import "NetworkUtilities.h"

#import "Pulser.h"
#import "XmlParser.h"

@implementation NetworkUtilities

static NSLock* gate = nil;
static NSInteger inflightOperations = 0;
static Pulser* pulser = nil;

+ (void) initialize {
  if (self == [NetworkUtilities class]) {
    gate = [[NSRecursiveLock alloc] init];
    pulser = [[Pulser pulserWithTarget:self
                                action:@selector(updateNetworkActivityIndicator)
                         pulseInterval:3] retain];
  }
}


+ (NSMutableURLRequest*) createRequest:(NSURL*) url {
  if (url == nil) {
    return nil;
  }

  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  request.timeoutInterval = 120;
  request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  [request setValue:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" forHTTPHeaderField:@"User-Agent"];

  return request;
}


+ (void) updateNetworkActivityIndicator {
  [gate lock];
  {
    if (inflightOperations > 0) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }
  [gate unlock];
}


+ (NSString*) stringWithContentsOfAddress:(NSString*) address pause:(BOOL) pause {
  if (address.length == 0) {
    return nil;
  }

  return [self stringWithContentsOfUrl:[NSURL URLWithString:address] pause:pause];
}


+ (NSString*) stringWithContentsOfAddress:(NSString*) address {
  return [self stringWithContentsOfAddress:address pause:YES];
}


+ (NSString*) stringWithContentsOfUrl:(NSURL*) url
                                pause:(BOOL) pause {
  return [self stringWithContentsOfUrlRequest:[self createRequest:url]
                                        pause:pause];
}


+ (NSString*) stringWithContentsOfUrl:(NSURL*) url {
  return [self stringWithContentsOfUrl:url pause:YES];
}


+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) request pause:(BOOL) pause {
  if (request == nil) {
    return nil;
  }

  NSData* data = [self dataWithContentsOfUrlRequest:request pause:pause];
  if (data == nil) {
    return nil;
  }

  NSString* result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
  if (result != nil) {
    return result;
  }

  return [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
}


+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) request {
  return [self stringWithContentsOfUrlRequest:request pause:YES];
}


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address pause:(BOOL) pause {
  return [self xmlWithContentsOfAddress:address
                               response:NULL
                                  pause:pause];
}


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address {
  return [self xmlWithContentsOfAddress:address pause:YES];
}


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address
                                response:(NSHTTPURLResponse**) response
                                   pause:(BOOL) pause {
  if (response != NULL) {
    *response = nil;
  }

  if (address.length == 0) {
    return nil;
  }

  return [self xmlWithContentsOfUrl:[NSURL URLWithString:address]
                           response:response
                              pause:pause];
}


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address
                                response:(NSHTTPURLResponse**) response {
  return [self xmlWithContentsOfAddress:address response:response pause:YES];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url {
  return [self xmlWithContentsOfUrl:url
                           response:NULL];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url
                            response:(NSHTTPURLResponse**) response
                               pause:(BOOL) pause {
  return [self xmlWithContentsOfUrlRequest:[self createRequest:url]
                                  response:response
                                     pause:pause];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url
                            response:(NSHTTPURLResponse**) response {
  return [self xmlWithContentsOfUrl:url response:response pause:YES];
}


+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) request {
  return [self xmlWithContentsOfUrlRequest:request
                                  response:NULL];
}


+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) request
                                   response:(NSHTTPURLResponse**) response
                                      pause:(BOOL) pause {
  if (response != NULL) {
    *response = nil;
  }

  if (request == nil) {
    return nil;
  }

  NSData* data = [self dataWithContentsOfUrlRequest:request
                                           response:response
                                              pause:pause];
  return [XmlParser parse:data];
}


+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) request
                                   response:(NSHTTPURLResponse**) response {
  return [self xmlWithContentsOfUrlRequest:request response:response pause:YES];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address pause:(BOOL) pause {
  return [self dataWithContentsOfAddress:address
                                response:NULL
                                   pause:pause];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address {
  return [self dataWithContentsOfAddress:address pause:YES];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address
                             response:(NSHTTPURLResponse**) response
                                pause:(BOOL) pause {
  if (address.length == 0) {
    return nil;
  }

  return [self dataWithContentsOfUrl:[NSURL URLWithString:address]
                            response:response
                               pause:pause];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address
                             response:(NSHTTPURLResponse**) response {
  return [self dataWithContentsOfAddress:address response:response pause:YES];
}


+ (NSData*) dataWithContentsOfUrlRequestWorker:(NSURLRequest*) request
                                      response:(NSHTTPURLResponse**) response
                                         pause:(BOOL) pause {
  NSAssert(![NSThread isMainThread], @"");

  if (response != NULL) {
    *response = nil;
  }

  if (request == nil) {
    return nil;
  }

  [gate lock];
  {
    inflightOperations++;
    [pulser tryPulse];
  }
  [gate unlock];

  NSURLResponse* urlResponse = nil;
  NSError* error = nil;
  NSData* data = [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:&urlResponse
                                                   error:&error];


  [gate lock];
  {
    inflightOperations--;
    [pulser tryPulse];
  }
  [gate unlock];

  if (pause) {
    // pause a bit so we don't saturate the network.
    [NSThread sleepForTimeInterval:0.25];
  }

  if (error != nil) {
    return nil;
  }

  if (response != NULL && [urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
    *response = (NSHTTPURLResponse*)urlResponse;
  }

  return data;
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url
                         response:(NSHTTPURLResponse**) response
                            pause:(BOOL) pause {
  return [self dataWithContentsOfUrlRequest:[self createRequest:url]
                                   response:response
                                      pause:pause];
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url
                         response:(NSHTTPURLResponse**) response {
  return [self dataWithContentsOfUrl:url response:response pause:YES];
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url {
  return [self dataWithContentsOfUrl:url
                            response:NULL];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request
                                   pause:(BOOL) pause {
  return [self dataWithContentsOfUrlRequest:request
                                   response:NULL
                                      pause:pause];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request {
  return [self dataWithContentsOfUrlRequest:request pause:YES];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request
                                response:(NSHTTPURLResponse**) response
                                   pause:(BOOL) pause {
  if (response != NULL) {
    *response = nil;
  }

  if (request == nil) {
    return nil;
  }

  return [self dataWithContentsOfUrlRequestWorker:request
                                         response:response
                                            pause:pause];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request
                                response:(NSHTTPURLResponse**) response {
  return [self dataWithContentsOfUrlRequest:request response:response pause:YES];
}


+ (BOOL) isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags) flags {
  // kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
  // be reached using the current network configuration.
  BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;

  // This flag indicates that the specified nodename or address can
  // be reached using the current network configuration, but a
  // connection must first be established.
  //
  // If the flag is false, we don't have a connection. But because CFNetwork
  // automatically attempts to bring up a WWAN connection, if the WWAN reachability
  // flag is present, a connection is not required.
  BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
  if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
    noConnectionRequired = YES;
  }

  return (isReachable && noConnectionRequired) ? YES : NO;
}


+ (BOOL) isNetworkAvailableWorker:(SCNetworkReachabilityRef) networkReachability {
  SCNetworkReachabilityFlags flags;
  BOOL gotFlags = SCNetworkReachabilityGetFlags(networkReachability, &flags);
  if (!gotFlags) {
    return NO;
  }

  return [self isReachableWithoutRequiringConnection:flags];
}


+ (BOOL) isNetworkAvailable {
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));

  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;

  BOOL result;

  SCNetworkReachabilityRef networkReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
  {
    result = [self isNetworkAvailableWorker:networkReachability];
  }
  CFRelease(networkReachability);

  return result;
}

@end
