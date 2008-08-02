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

@interface Movie : NSObject {
    NSString* identifier;
    NSString* title;
    NSString* rating;
    NSString* length; // minutes;
    NSDate* releaseDate;
    NSString* poster;
    NSString* synopsis;
}

@property (copy) NSString* identifier;
@property (copy) NSString* title;
@property (copy) NSString* rating;
@property (copy) NSString* length;
@property (copy) NSDate* releaseDate;
@property (copy) NSString* poster;
@property (copy) NSString* synopsis;

+ (Movie*) movieWithDictionary:(NSDictionary*) dictionary;
+ (Movie*) movieWithIdentifier:(NSString*) identifier
                         title:(NSString*) title
                        rating:(NSString*) rating
                        length:(NSString*) length
                   releaseDate:(NSDate*) releaseDate
                        poster:(NSString*) poster
                      synopsis:(NSString*) synopsis;

- (NSDictionary*) dictionary;
- (NSString*) ratingAndRuntimeString;

+ (NSString*) massageTitle:(NSString*) title;

@end
