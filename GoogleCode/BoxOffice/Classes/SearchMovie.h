//
//  SearchMovie.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieKey.h"

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
