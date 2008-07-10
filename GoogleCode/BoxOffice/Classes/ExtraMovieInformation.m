//
//  ExtraMovieInformation.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ExtraMovieInformation.h"


@implementation ExtraMovieInformation

@synthesize link;
@synthesize synopsis;
@synthesize ranking;

- (id) initWithLink:(NSString*) aLink
           synopsis:(NSString*) aSynopsis
            ranking:(NSString*) aRanking {
    if (self = [super init]) {
        self.link = aLink;
        self.synopsis = aSynopsis;
        self.ranking = aRanking;
    }
    
    return self;
}

+ (ExtraMovieInformation*) infoWithLink:(NSString*) link
                               synopsis:(NSString*) synopsis
                                ranking:(NSString*) ranking {
    return [[[ExtraMovieInformation alloc] initWithLink:link synopsis:synopsis ranking:ranking] autorelease];
}

+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary {
    return [ExtraMovieInformation infoWithLink:[dictionary objectForKey:@"link"]
                                      synopsis:[dictionary objectForKey:@"synopsis"]
                                       ranking:[dictionary objectForKey:@"ranking"]];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.link forKey:@"link"];
    [dictionary setObject:self.synopsis forKey:@"synopsis"];
    [dictionary setObject:self.ranking forKey:@"ranking"];
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
