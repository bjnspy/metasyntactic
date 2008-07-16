//
//  ExtraMovieInformation.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ExtraMovieInformation.h"


@implementation ExtraMovieInformation

@synthesize title;
@synthesize link;
@synthesize synopsis;
@synthesize ranking;

- (void) dealloc {
    self.title = nil;
    self.link = nil;
    self.synopsis = nil;
    self.ranking = nil;
    
    [super dealloc];
}

- (id) initWithTitle:(NSString*) title_
                link:(NSString*) link_
           synopsis:(NSString*) synopsis_
            ranking:(NSString*) ranking_ {
    if (self = [super init]) {
        self.title = title_;
        self.link = link_;
        self.synopsis = synopsis_;
        self.ranking = ranking_;
    }
    
    return self;
}

+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                    link:(NSString*) link
                               synopsis:(NSString*) synopsis
                                ranking:(NSString*) ranking {
    return [[[ExtraMovieInformation alloc] initWithTitle:title
                                                    link:link
                                                synopsis:synopsis 
                                                 ranking:ranking] autorelease];
}

+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [ExtraMovieInformation infoWithTitle:[dictionary objectForKey:@"title"]
                                           link:[dictionary objectForKey:@"link"]
                                       synopsis:[dictionary objectForKey:@"synopsis"]
                                        ranking:[dictionary objectForKey:@"ranking"]];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:@"title"];
    [dictionary setObject:link forKey:@"link"];
    [dictionary setObject:synopsis forKey:@"synopsis"];
    [dictionary setObject:ranking forKey:@"ranking"];
    return dictionary;
}

- (NSInteger) rankingValue {
    int value = [self.ranking intValue]; 
    if (value >= 0 && value <= 100) {
        return value;
    }
    
    return -1;
}

@end
