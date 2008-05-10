//
//  Movie.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface Movie : NSObject {
    NSString* title;
    NSString* link;
    NSString* synopsis;
    NSString* rating;
}

@property (copy) NSString* title;
@property (copy) NSString* link;
@property (copy) NSString* synopsis;
@property (copy) NSString* rating;

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary;
+ (Movie*) movieWithTitle:(NSString*) title
                     link:(NSString*) link
                 synopsis:(NSString*) synopsis
                   rating:(NSString*) rating;

- (NSDictionary*) dictionary;

- (NSInteger) ratingValue;

@end
