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
