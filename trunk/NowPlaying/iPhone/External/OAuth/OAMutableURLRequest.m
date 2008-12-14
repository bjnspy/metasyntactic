//
//  OAMutableURLRequest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OAMutableURLRequest.h"

#import "NSString+URLEncoding.h"
#import "OARequestParameter.h"
#import "NSURL+Base.h"
#import "OAConsumer.h"
#import "OAToken.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OASignatureProviding.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSURL+Base.h"

@interface OAMutableURLRequest()
@property (retain) OAConsumer *consumer;
@property (retain) OAToken *token;
@property (copy) NSString *realm;
@property (copy) NSString *signature;
@property (copy) NSString *nonce;
@property (copy) NSString *timestamp;
@end

@implementation OAMutableURLRequest

@synthesize consumer;
@synthesize token;
@synthesize realm;
@synthesize signature;
@synthesize nonce;
@synthesize timestamp;


- (void) dealloc {
    self.consumer = nil;
    self.realm = nil;
    self.signature = nil;
    self.nonce = nil;
    self.timestamp = nil;
    
    [super dealloc];
}


- (id) initWithURL:(NSURL*)aUrl
          consumer:(OAConsumer*)aConsumer
             token:(OAToken*)aToken
             realm:(NSString*)aRealm {
    if ([super initWithURL:aUrl
               cachePolicy:NSURLRequestReloadIgnoringCacheData
           timeoutInterval:10.0]) {
        
        self.consumer = aConsumer;
        
        // empty token for Unauthorized Request Token transaction
        if (aToken == nil) {
            self.token = [[[OAToken alloc] init] autorelease];
        } else {
            self.token = aToken;
        }
        
        if (aRealm == nil) {
            self.realm = @"";
        } else {
            self.realm = aRealm;
        }
        
        self.timestamp = [NSString stringWithFormat:@"%d", time(NULL)];
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, uuid);
        self.nonce = (NSString*)string;
        CFRelease(uuid);
    }
    
    return self;
}

// Setting a timestamp and nonce to known
// values can be helpful for testing
- (id) initWithURL:(NSURL*) aUrl
          consumer:(OAConsumer*) aConsumer
             token:(OAToken*) aToken
             realm:(NSString*) aRealm
             nonce:(NSString*) aNonce
         timestamp:(NSString*) aTimestamp {
    if (self = [self initWithURL:aUrl
                        consumer:aConsumer
                           token:aToken
                           realm:aRealm]) {
        self.nonce = aNonce;
        self.timestamp = aTimestamp;
    }
    
    return self;
}


- (NSString*) _signatureBaseString {
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    // build a sorted array of both request parameters and OAuth header parameters
    NSMutableArray* parameterPairs = [[NSMutableArray alloc] initWithCapacity:(6 + [[self parameters] count])]; // 6 being the number of OAuth params in the Signature Base String
    
    [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_consumer_key" value:consumer.key] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_signature_method" value:@"HMAC-SHA1"] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_timestamp" value:timestamp] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_nonce" value:nonce] URLEncodedNameValuePair]];
    [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
    
    if (![token.key isEqualToString:@""]) {
        [parameterPairs addObject:[[OARequestParameter parameterWithName:@"oauth_token" value:token.key] URLEncodedNameValuePair]];
    }
    
    for (OARequestParameter* param in self.parameters) {
        [parameterPairs addObject:param.URLEncodedNameValuePair];
    }
    
    NSArray* sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString* normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    return [NSString stringWithFormat:@"%@&%@&%@",
            self.HTTPMethod,
            self.URL.URLStringWithoutQuery.encodedURLParameterString,
            normalizedRequestParameters.encodedURLString];
}


- (void) prepare {
    // sign
    OAHMAC_SHA1SignatureProvider* provider =
    [[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease];
    
    self.signature = [provider signClearText:[self _signatureBaseString]
                                  withSecret:[NSString stringWithFormat:@"%@&%@", consumer.secret, token.secret]];
    
    // set OAuth headers
    
    NSString* oauthToken;
    if ([token.key isEqualToString:@""]) {
        oauthToken = @""; // not used on Request Token transactions
    } else {
        oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [token.key encodedURLParameterString]];
    }
    
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"",
                             realm.encodedURLParameterString,
                             consumer.key.encodedURLParameterString,
                             oauthToken,
                             [[provider name] encodedURLParameterString],
                             signature.encodedURLParameterString,
                             timestamp,
                             nonce];
    
    [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}

@end
