//
//  Theater.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface Theater : NSObject {
    NSString* identifier;
    NSString* name;
    NSString* address;
    NSString* phoneNumber;
    NSDictionary* movieToShowtimesMap;
    NSString* sellsTickets;
    NSString* sourceZipCode;
}

@property (copy) NSString* identifier;
@property (copy) NSString* name;
@property (copy) NSString* address;
@property (copy) NSString* phoneNumber;
@property (copy) NSString* sellsTickets;
@property (copy) NSString* sourceZipCode;
@property (retain) NSDictionary* movieToShowtimesMap;

+ (Theater*) theaterWithIdentifier:(NSString*) identifier
                              name:(NSString*) name
                           address:(NSString*) address
                       phoneNumber:(NSString*) phoneNumber
                      sellsTickets:(NSString*) sellsTickets
               movieToShowtimesMap:(NSDictionary*) movieToShowtimesMap
                     sourceZipCode:(NSString*) sourceZipCode;

+ (Theater*) theaterWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

+ (NSString*) processShowtime:(NSString*) showtime;

@end
