// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchPerson.h"
#import "MovieKey.h"
#import "Utilities.h"
#import "PersonKey.h"

@implementation SearchPerson

@synthesize key;
@synthesize producer;
@synthesize director;
@synthesize cast;
@synthesize writer;
@synthesize biography;
@synthesize quotes;
@synthesize trivia;
@synthesize imageUrl;
@synthesize imageData;
@synthesize birthDate;
@synthesize deathDate;

- (void) dealloc {
    self.key = nil;
    self.producer = nil;
    self.director = nil;
    self.cast = nil;
    self.writer = nil;
    self.biography = nil;
    self.quotes = nil;
    self.trivia = nil;
    self.imageUrl = nil;
    self.imageData = nil;
    self.birthDate = nil;
    self.deathDate = nil;
    
    [super dealloc];
}

- (id) initWithKey:(PersonKey*) key_
          producer:(NSArray*) producer_
          director:(NSArray*) director_
              cast:(NSArray*) cast_
            writer:(NSArray*) writer_
         biography:(NSString*) biography_
            quotes:(NSArray*) quotes_
            trivia:(NSArray*) trivia_
          imageUrl:(NSString*) imageUrl_
         imageData:(NSData*) imageData_
         birthDate:(NSString*) birthDate_
         deathDate:(NSString*) deathDate_ {
    if (self = [super init]) {
        self.key = key_;
        self.producer = [Utilities nonNilArray:producer_];
        self.director = [Utilities nonNilArray:director_];
        self.cast = [Utilities nonNilArray:cast_];
        self.writer = [Utilities nonNilArray:writer_];
        self.biography = [Utilities nonNilString:biography_];
        self.quotes = [Utilities nonNilArray:quotes_];
        self.trivia = [Utilities nonNilArray:trivia_];
        self.imageUrl = [Utilities nonNilString:imageUrl_];
        self.imageData = imageData_;
        self.birthDate = [Utilities nonNilString:birthDate_];
        self.deathDate = [Utilities nonNilString:deathDate_];
    }

    return self;
}

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
                      deathDate:(NSString*) deathDate {
    return [[[SearchPerson alloc] initWithKey:key
                                     producer:producer
                                     director:director
                                         cast:cast
                                       writer:writer
                                    biography:biography
                                       quotes:quotes
                                       trivia:trivia
                                     imageUrl:imageUrl
                                    imageData:imageData
                                    birthDate:birthDate
                                    deathDate:deathDate] autorelease];
}

- (NSArray*) encodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (Key* k in array) {
        [result addObject:[k dictionary]];
    }
    return result;
}

+ (NSArray*) decodeArray:(NSArray*) array {
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        [result addObject:[MovieKey keyWithDictionary:dict]];
    }
    return result;
}

+ (SearchPerson*) personWithDictionary:(NSDictionary*) dictionary {
    return [SearchPerson personWithKey:[PersonKey keyWithDictionary:[dictionary objectForKey:@"key"]]
                              producer:[SearchPerson decodeArray:[dictionary objectForKey:@"producer"]]
                              director:[SearchPerson decodeArray:[dictionary objectForKey:@"director"]]
                                  cast:[SearchPerson decodeArray:[dictionary objectForKey:@"cast"]]
                                writer:[SearchPerson decodeArray:[dictionary objectForKey:@"writer"]]
                             biography:[dictionary objectForKey:@"biography"]
                                quotes:[dictionary objectForKey:@"quotes"]
                                trivia:[dictionary objectForKey:@"trivia"]
                              imageUrl:[dictionary objectForKey:@"imageUrl"]
                             imageData:[dictionary objectForKey:@"imageData"]
                             birthDate:[dictionary objectForKey:@"birthDate"]
                             deathDate:[dictionary objectForKey:@"deathDate"]];
}

- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[key dictionary] forKey:@"key"];
    [dict setObject:[self encodeArray:producer] forKey:@"producer"];
    [dict setObject:[self encodeArray:director] forKey:@"director"];
    [dict setObject:[self encodeArray:cast] forKey:@"cast"];
    [dict setObject:[self encodeArray:writer] forKey:@"writer"];
    [dict setObject:biography forKey:@"biography"];
    [dict setObject:quotes forKey:@"quotes"];
    [dict setObject:trivia forKey:@"trivia"];
    [dict setObject:imageUrl forKey:@"imageUrl"];
    if (imageData != nil) {
        [dict setObject:imageData forKey:@"imageData"];
    }
    [dict setObject:birthDate forKey:@"birthDate"];
    [dict setObject:deathDate forKey:@"deathDate"];
    return dict;
}

@end
