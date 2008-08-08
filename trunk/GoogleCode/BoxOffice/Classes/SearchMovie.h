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

@interface SearchMovie : NSObject {
    MovieKey* key;
    NSArray* producers;
    NSArray* writers;
    NSArray* directors;
    NSArray* music;
    NSArray* cast;
    NSString* imageUrl;
    NSData* imageData;
    NSArray* genres;
    NSString* outline;
    NSString* plot;
    NSString* votes;
    NSString* rating;
}

@property (retain) MovieKey* key;
@property (retain) NSArray* producers;
@property (retain) NSArray* writers;
@property (retain) NSArray* directors;
@property (retain) NSArray* genres;
@property (retain) NSArray* music;
@property (retain) NSArray* cast;
@property (copy) NSString* imageUrl;
@property (copy) NSString* outline;
@property (copy) NSString* plot;
@property (copy) NSString* votes;
@property (copy) NSString* rating;
@property (retain) NSData* imageData;

+ (SearchMovie*) movieWithKey:(MovieKey*) key
                    producers:(NSArray*) producers
                      writers:(NSArray*) writers
                    directors:(NSArray*) directors
                        music:(NSArray*) music
                         cast:(NSArray*) cast
                     imageUrl:(NSString*) imageUrl
                    imageData:(NSData*) imageData
                       genres:(NSArray*) genres
                      outline:(NSString*) outline
                         plot:(NSString*) plot
                        votes:(NSString*) votes
                       rating:(NSString*) rating;

+ (SearchMovie*) movieWithDictionary:(NSDictionary*) dictionary;

- (NSDictionary*) dictionary;

@end
