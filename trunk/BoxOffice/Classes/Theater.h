//
//  Theater.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface Theater : NSObject {
    NSString* name;
    NSString* address;
    NSString* phoneNumber;
    NSDictionary* movieToShowtimesMap;
}

@property (copy) NSString* name;
@property (copy) NSString* address;
@property (copy) NSString* phoneNumber;
@property (retain) NSDictionary* movieToShowtimesMap;

+ (Theater*) theaterWithName:(NSString*) name
                     address:(NSString*) address
                 phoneNumber:(NSString*) phoneNumber
         movieToShowtimesMap:(NSDictionary*) movieToShowtimesMap;
+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

+ (NSDictionary*) prepareShowtimesMap:(NSDictionary*) movieToShowtimesMap;

- (NSDictionary*) dictionary;

+ (NSString*) processShowtime:(NSString*) showtime;
    

@end
