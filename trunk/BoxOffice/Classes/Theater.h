//
//  Theater.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface Theater : NSObject {
    NSString* name;
    NSString* address;
    NSDictionary* movieToShowtimesMap;
}

@property (copy) NSString* name;
@property (copy) NSString* address;
@property (retain) NSDictionary* movieToShowtimesMap;

- (void) dealloc;

+ (Theater*) theaterWithName:(NSString*) name
                     address:(NSString*) address
         movieToShowtimesMap:(NSDictionary*) movieToShowtimesMap;
+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

- (id)        initWithName:(NSString*) name
                   address:(NSString*) address
       movieToShowtimesMap:(NSDictionary*) movieToShowtimesMap;

- (NSDictionary*) dictionary;

- (NSString*) description;

- (BOOL) isEqual:(id) anObject;
- (NSUInteger) hash;

@end
