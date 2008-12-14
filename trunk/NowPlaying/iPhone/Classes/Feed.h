//
//  Feed.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface Feed : NSObject {
@private
    NSString* url;
    NSString* key;
    NSString* name;
}

@property (readonly, retain) NSString* url;
@property (readonly, retain) NSString* key;

+ (Feed*) feedWithUrl:(NSString*) url key:(NSString*) key name:(NSString*) name;
+ (Feed*) feedWithDictionary:(NSDictionary*) dictionary;

- (NSString*) title;
- (NSDictionary*) dictionary;

- (BOOL) isRecommendationFeed;

@end
