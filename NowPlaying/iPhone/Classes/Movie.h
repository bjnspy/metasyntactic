// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

@interface Movie : NSObject {
    NSString* identifier;
    NSString* canonicalTitle;
    NSString* rating;
    NSString* length; // minutes;
    NSDate* releaseDate;
    NSString* imdbId;
    NSString* poster;
    NSString* synopsis;
    NSString* studio;
    NSArray* directors;
    NSArray* cast;
    NSArray* genres;

    NSString* displayTitle;
}

@property (copy) NSString* identifier;
@property (copy) NSString* canonicalTitle;
@property (copy) NSString* rating;
@property (copy) NSString* length;
@property (copy) NSString* imdbId;
@property (copy) NSString* poster;
@property (copy) NSString* synopsis;
@property (copy) NSString* displayTitle;
@property (copy) NSString* studio;
@property (retain) NSDate* releaseDate;
@property (retain) NSArray* directors;
@property (retain) NSArray* cast;
@property (retain) NSArray* genres;

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary;
+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        imdbId:(NSString*) imdbId
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres;

- (NSDictionary*) dictionary;

- (BOOL) isUnrated;
- (NSString*) ratingString;
- (NSString*) runtimeString;
- (NSString*) ratingAndRuntimeString;

+ (NSString*) makeCanonical:(NSString*) title;
+ (NSString*) makeDisplay:(NSString*) title;

@end