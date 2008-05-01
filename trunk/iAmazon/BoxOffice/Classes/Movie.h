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
    NSString* description;
    NSString* rating;
}

@property (copy) NSString* title;
@property (copy) NSString* link;
@property (copy) NSString* description;
@property (copy) NSString* rating;

- (void) dealloc;

- (id) initWithDictionary:(NSDictionary*) dictionary;

- (id) initWithTitle:(NSString*) title
                link:(NSString*) link
         description:(NSString*) description
              rating:(NSString*) rating;

- (NSDictionary*) dictionary;

@end
