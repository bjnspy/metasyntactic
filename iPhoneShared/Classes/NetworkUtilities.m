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

#import "PriorityMutex.h"
#import "Pulser.h"
#import "XmlParser.h"

@implementation NetworkUtilities

static PriorityMutex* priorityMutex = nil;

static NSLock* gate = nil;
static NSInteger inflightOperations = 0;
static Pulser* pulser = nil;

+ (void) initialize {
    if (self == [NetworkUtilities class]) {
        priorityMutex = [[PriorityMutex alloc] init];

        gate = [[NSRecursiveLock alloc] init];
        pulser = [[Pulser pulserWithTarget:self
                                    action:@selector(updateNetworkActivityIndicator)
                             pulseInterval:5] retain];
    }
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


+ (NSString*) stringWithContentsOfAddress:(NSString*) address
                                important:(BOOL) important {
    if (address.length == 0) {
        return nil;
    }

    return [self stringWithContentsOfUrl:[NSURL URLWithString:address]
                               important:important];
}


+ (NSURLRequest*) createRequest:(NSURL*) url {
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


+ (NSString*) stringWithContentsOfUrl:(NSURL*) url
                            important:(BOOL) important {
    return [self stringWithContentsOfUrlRequest:[self createRequest:url] important:important];
}


+ (NSString*) stringWithContentsOfUrlRequest:(NSURLRequest*) request
                                   important:(BOOL) important {
    if (request == nil) {
        return nil;
    }

    NSData* data = [self dataWithContentsOfUrlRequest:request
                                            important:important];
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


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address
                               important:(BOOL) important {
    return [self xmlWithContentsOfAddress:address
                                important:important
                                 response:NULL];
}


+ (XmlElement*) xmlWithContentsOfAddress:(NSString*) address
                               important:(BOOL) important
                                response:(NSHTTPURLResponse**) response {
    if (response != NULL) {
        *response = nil;
    }

    if (address.length == 0) {
        return nil;
    }

    return [self xmlWithContentsOfUrl:[NSURL URLWithString:address]
                            important:important
                             response:response];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url
                           important:(BOOL) important {
    return [self xmlWithContentsOfUrl:url important:important response:NULL];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url
                           important:(BOOL) important
                            response:(NSHTTPURLResponse**) response {
    return [self xmlWithContentsOfUrlRequest:[self createRequest:url]
                                   important:important
                                    response:response];
}


+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) request
                                  important:(BOOL) important {
    return [self xmlWithContentsOfUrlRequest:request
                                   important:important
                                    response:NULL];
}


+ (XmlElement*) xmlWithContentsOfUrlRequest:(NSURLRequest*) request
                                  important:(BOOL) important
                                   response:(NSHTTPURLResponse**) response {
    if (response != NULL) {
        *response = nil;
    }

    if (request == nil) {
        return nil;
    }

    NSData* data = [self dataWithContentsOfUrlRequest:request
                                            important:important
                                             response:response];
    return [XmlParser parse:data];
}


+ (NSData*) dataWithContentsOfAddress:(NSString*) address
                            important:(BOOL) important {
    if (address.length == 0) {
        return nil;
    }

    return [self dataWithContentsOfUrl:[NSURL URLWithString:address]
                             important:important];
}


+ (NSData*) dataWithContentsOfUrlRequestWorker:(NSURLRequest*) request
                                      response:(NSHTTPURLResponse**) response {
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
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&urlResponse
                                                     error:&error];


    [gate lock];
    {
        inflightOperations--;
        [pulser tryPulse];
    }
    [gate unlock];

    // pause a bit so we don't saturate the network.
    if (![NSThread isMainThread]) {
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


+ (NSData*) highPriorityDataWithContentsOfUrlRequest:(NSURLRequest*) request
                                            response:(NSHTTPURLResponse**) response {
    NSData* data;

    [priorityMutex lockHigh];
    {
        data = [self dataWithContentsOfUrlRequestWorker:request response:response];
    }
    [priorityMutex unlockHigh];

    return data;
}


+ (NSData*) lowPriorityDataWithContentsOfUrlRequest:(NSURLRequest*) request
                                           response:(NSHTTPURLResponse**) response {
    NSData* data;

    [priorityMutex lockLow];
    {
        data = [self dataWithContentsOfUrlRequestWorker:request response:response];
    }
    [priorityMutex unlockLow];

    return data;
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url
                        important:(BOOL) important {
    return [self dataWithContentsOfUrlRequest:[self createRequest:url]
                                    important:important];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request
                               important:(BOOL) important {
    return [self dataWithContentsOfUrlRequest:request important:important response:NULL];
}


+ (NSData*) dataWithContentsOfUrlRequest:(NSURLRequest*) request
                               important:(BOOL) important
                                response:(NSHTTPURLResponse**) response {
    if (response != NULL) {
        *response = nil;
    }

    if (request == nil) {
        return nil;
    }

    if (important) {
        return [self highPriorityDataWithContentsOfUrlRequest:request response:response];
    } else {
        return [self lowPriorityDataWithContentsOfUrlRequest:request response:response];
    }
}


+ (BOOL) isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags) flags
{
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


+ (BOOL) isNetworkAvailable {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));

    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef networkReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);

    SCNetworkReachabilityFlags flags;
    BOOL gotFlags = SCNetworkReachabilityGetFlags(networkReachability, &flags);
    if (!gotFlags) {
        return NO;
    }

    return [self isReachableWithoutRequiringConnection:flags];
}

@end