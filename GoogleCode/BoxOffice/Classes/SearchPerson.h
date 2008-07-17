//
//  SearchPerson.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonKey.h"

@interface SearchPerson : NSObject {
    PersonKey* key;
    NSArray* producer;
    NSArray* director;
    NSArray* cast;
    NSArray* writer;
    NSString* biography;
    NSArray* quotes;
    NSArray* trivia;
    NSString* imageUrl;
    NSData* imageData;
    NSString* birthDate;
    NSString* deathDate;
}

@property (retain) PersonKey* key;
@property (retain) NSArray* producer;
@property (retain) NSArray* director;
@property (retain) NSArray* cast;
@property (retain) NSArray* writer;
@property (copy) NSString* biography;
@property (retain) NSArray* quotes;
@property (retain) NSArray* trivia;
@property (copy) NSString* imageUrl;
@property (copy) NSString* birthDate;
@property (copy) NSString* deathDate;
@property (retain) NSData* imageData;

+ (SearchPerson*) personWithKey:(PersonKey*) key
                       producer:(NSArray*) producer
                       director:(NSArray*) director
                           cast:(NSArray*) cast
                         writer:(NSArray*) writer
                      biography:(NSString*) biography
                         quotes:(NSArray*) quotes
                         trivia:(NSArray*) trivia
                       imageUrl:(NSString*) imageUrl
                      imageData:(NSData*) imageData
                      birthDate:(NSString*) birthDate
                      deathDate:(NSString*) deathDate;

+ (SearchPerson*) personWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

@end
