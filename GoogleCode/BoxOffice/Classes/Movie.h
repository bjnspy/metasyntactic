//
//  Movie.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/27/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//


@interface Movie : NSObject {
    NSString* identifier;
    NSString* title;
    NSString* rating;
    NSString* length; // minutes;
    NSDate* releaseDate;
    NSString* poster;
    NSString* backupSynopsis;
}

@property (copy) NSString* identifier;
@property (copy) NSString* title;
@property (copy) NSString* rating;
@property (copy) NSString* length;
@property (copy) NSDate* releaseDate;
@property (copy) NSString* poster;
@property (copy) NSString* backupSynopsis;

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary;
+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) poster
                backupSynopsis:(NSString*) backupSynopsis;

- (NSDictionary*) dictionary;

@end
