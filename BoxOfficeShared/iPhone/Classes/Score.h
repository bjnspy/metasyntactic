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

@interface Score : AbstractData<NSCopying, NSCoding> {
@private
  NSString* canonicalTitle;
  NSString* synopsis;
  NSString* score;
  NSString* provider;
  NSString* identifier;
  NSInteger scoreValue;
}

@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* synopsis;
@property (readonly, copy) NSString* score;
@property (readonly, copy) NSString* provider;
@property (readonly, copy) NSString* identifier;

+ (Score*) scoreWithTitle:(NSString*) title
                 synopsis:(NSString*) synopsis
                    score:(NSString*) score
                 provider:(NSString*) provider
               identifier:(NSString*) identifier;

- (NSInteger) scoreValue;

@end
