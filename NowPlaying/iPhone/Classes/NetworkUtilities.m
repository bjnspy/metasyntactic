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
#import "XmlParser.h"

@implementation NetworkUtilities

static PriorityMutex* mutex = nil;

+ (void) initialize {
    if (self == [NetworkUtilities class]) {
        mutex = [[PriorityMutex alloc] init];
    }
}


+ (NSString*) stringWithContentsOfAddress:(NSString*) address
                                important:(BOOL) important {
    if (address.length == 0) {
        return nil;
    }

    return [self stringWithContentsOfUrl:[NSURL URLWithString:address]
                               important:important];
}


+ (NSString*) stringWithContentsOfUrl:(NSURL*) url
                            important:(BOOL) important {
    if (url == nil) {
        return nil;
    }

    NSData* data = [self dataWithContentsOfUrl:url
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
    if (address.length == 0) {
        return nil;
    }

    return [self xmlWithContentsOfUrl:[NSURL URLWithString:address]
                            important:important];
}


+ (XmlElement*) xmlWithContentsOfUrl:(NSURL*) url
                           important:(BOOL) important {
    if (url == nil) {
        return nil;
    }

    NSData* data = [self dataWithContentsOfUrl:url
                                     important:important];
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


+ (NSData*) dataWithContentsOfUrlWorker:(NSURL*) url {
    NSAssert(![NSThread isMainThread], @"");

    if (url == nil) {
        return nil;
    }

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 120;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"gzip" forHTTPHeaderField:@"User-Agent"];

    NSURLResponse* response = nil;
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];

    // pause a bit so we don't saturate the network.
    if (![NSThread isMainThread]) {
        [NSThread sleepForTimeInterval:0.25];
    }
    
    if (error != nil) {
        return nil;
    }

    return data;
}


+ (NSData*) highPriorityDataWithContentsOfUrl:(NSURL*) url {
    NSData* data;

    [mutex lockHigh];
    {
        data = [self dataWithContentsOfUrlWorker:url];
    }
    [mutex unlockHigh];

    return data;
}


+ (NSData*) lowPriorityDataWithContentsOfUrl:(NSURL*) url {
    NSData* data;

    [mutex lockLow];
    {
        data = [self dataWithContentsOfUrlWorker:url];
    }
    [mutex unlockLow];

    return data;
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url
                        important:(BOOL) important {
    if (important) {
        return [self highPriorityDataWithContentsOfUrl:url];
    } else {
        return [self lowPriorityDataWithContentsOfUrl:url];
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