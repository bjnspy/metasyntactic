// Copyright 2010 Cyrus Najmabadi
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

@interface Movie : AbstractData<NSCopying, NSCoding> {
@private
  NSString* identifier;
  NSString* canonicalTitle;
  NSString* rating;
  NSInteger length; // minutes;
  NSDate* releaseDate;
  NSString* imdbAddress;
  NSString* poster;
  NSString* synopsis;
  NSString* studio;
  NSArray* directors;
  NSArray* cast;
  NSArray* genres;

  NSString* displayTitle;

  NSDictionary* additionalFields;

  // accessed on multiple threads.  Always access through property.
  NSString* simpleNetflixIdentifierData;
}

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* displayTitle;
@property (readonly, copy) NSString* rating;
@property (readonly) NSInteger length;
@property (readonly, copy) NSString* imdbAddress;
@property (readonly, copy) NSString* poster;
@property (readonly, copy) NSString* synopsis;
@property (readonly, copy) NSString* studio;
@property (readonly, retain) NSDate* releaseDate;
@property (readonly, retain) NSArray* directors;
@property (readonly, retain) NSArray* cast;
@property (readonly, retain) NSArray* genres;
@property (readonly, retain) NSDictionary* additionalFields;

+ (BOOL) canReadDictionary:(NSDictionary*) dictionary;

+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSInteger) length
                   releaseDate:(NSDate*) releaseDate
                   imdbAddress:(NSString*) imdbAddress
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres;
+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSInteger) length
                   releaseDate:(NSDate*) releaseDate
                   imdbAddress:(NSString*) imdbAddress
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis
                        studio:(NSString*) studio
                     directors:(NSArray*) directors
                          cast:(NSArray*) cast
                        genres:(NSArray*) genres
              additionalFields:(NSDictionary*) additionalFields;

+ (NSString*) runtimeString:(NSInteger) length;

+ (NSString*) makeCanonical:(NSString*) title;
+ (NSString*) makeDisplay:(NSString*) title;

- (BOOL) isNetflix;
- (NSString*) simpleNetflixIdentifier;

@end
