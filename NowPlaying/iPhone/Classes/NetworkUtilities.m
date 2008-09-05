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

#import "NetworkUtilities.h"

#import "XmlParser.h"

@implementation NetworkUtilities

static NSCondition* gate = nil;
static NSInteger importantTaskCount = 0;

+ (void) initialize {
    if (self == [NetworkUtilities class]) {
        gate = [[NSCondition alloc] init];
    }
}


+ (NSString*) stringWithContentsOfAddress:(NSString*) address
                                important:(BOOL) important {
    if (address == nil) {
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
    if (address == nil) {
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
    if (address == nil) {
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


+ (NSData*) highPriorityDataWithContentsOfUrl:(NSURL*) url {
    [gate lock];
    {
        importantTaskCount++;
    }
    [gate unlock];
    
    NSData* data = [self dataWithContentsOfUrlWorker:url];
    
    [gate lock];
    {
        importantTaskCount--;
        
        if (importantTaskCount == 0) {
            [gate broadcast];
        }
    }
    [gate unlock];
    
    return data;  
}


+ (NSData*) lowPriorityDataWithContentsOfUrl:(NSURL*) url {
    [gate lock];
    {
        while (importantTaskCount > 0) {
            [gate wait];
        }
    }
    [gate unlock];
    
    return [self dataWithContentsOfUrlWorker:url];
}


+ (NSData*) dataWithContentsOfUrl:(NSURL*) url
                        important:(BOOL) important {
    if (important) {
        return [self highPriorityDataWithContentsOfUrl:url];
    } else {
        return [self lowPriorityDataWithContentsOfUrl:url];
    }
}


@end