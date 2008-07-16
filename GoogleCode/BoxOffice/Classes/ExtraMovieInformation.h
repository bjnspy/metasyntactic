//
//  ExtraMovieInformation.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface ExtraMovieInformation : NSObject {
    NSString* title;
    NSString* synopsis;
    NSString* link;
    NSString* ranking; 
}

@property (copy) NSString* title;
@property (copy) NSString* synopsis;
@property (copy) NSString* link;
@property (copy) NSString* ranking;

+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary;
+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                    link:(NSString*) link
                                synopsis:(NSString*) synopsis
                                 ranking:(NSString*) ranking;

- (NSDictionary*) dictionary;

- (NSInteger) rankingValue;

@end
