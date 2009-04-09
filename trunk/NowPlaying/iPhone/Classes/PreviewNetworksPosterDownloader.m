//
//  PreviewNetworksPosterDownloader.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreviewNetworksPosterDownloader.h"

#import "Application.h"
#import "Movie.h"
#import "InternationalDataCache.h"
#import "LocaleUtilities.h"
#import "NetworkUtilities.h"
#import "StringUtilities.h"
#import "XmlElement.h"

@implementation PreviewNetworksPosterDownloader

- (NSDictionary*) processElement:(XmlElement*) element {
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    for (XmlElement* child in element.children) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            NSString* title = [[child element:@"title"] text];
            NSString* poster = [[child element:@"poster"] text];
            
            if (title.length > 0 && poster.length > 0) {
                [map setObject:poster forKey:title];
            }
        }
        [pool release];
    }
    
    return map;
}


- (NSDictionary*) createMapWorker {
    if (![InternationalDataCache isAllowableCountry]) {
        return nil;
    }
    
    NSString* address = [NSString stringWithFormat:@"http://%@.iphone.filmtrailer.com/v2.0/cinema/AllCinemaMovies/?channel_user_id=391100099-1&format=mov&size=xlarge", [[LocaleUtilities isoCountry] lowercaseString]];
    NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource?q=%@",
                             [Application host],
                             [StringUtilities stringByAddingPercentEscapes:address]];
    
    XmlElement* element;
    if ((element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress]) == nil &&
        (element = [NetworkUtilities xmlWithContentsOfAddress:address]) == nil) {
        return nil;
    }
    
    return [self processElement:element];
}

@end