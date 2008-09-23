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

@interface ExtraMovieInformation : NSObject {
    NSString* canonicalTitle;
    NSString* synopsis;
    NSString* score;
    NSString* provider;
    NSString* identifier;
}

@property (copy) NSString* canonicalTitle;
@property (copy) NSString* synopsis;
@property (copy) NSString* score;
@property (copy) NSString* provider;
@property (copy) NSString* identifier;

+ (ExtraMovieInformation*) infoWithDictionary:(NSDictionary*) dictionary;
+ (ExtraMovieInformation*) infoWithTitle:(NSString*) title
                                synopsis:(NSString*) synopsis
                                   score:(NSString*) score
                                provider:(NSString*) provider
                              identifier:(NSString*) identifier;

- (NSDictionary*) dictionary;

- (NSInteger) scoreValue;

@end