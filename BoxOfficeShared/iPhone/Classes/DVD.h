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

@interface DVD : AbstractData<NSCopying, NSCoding> {
@private
  NSString* canonicalTitle;
  NSString* price;
  NSString* format;
  NSString* discs;
  NSString* url;
}

@property (readonly, copy) NSString* canonicalTitle;
@property (readonly, copy) NSString* price;
@property (readonly, copy) NSString* format;
@property (readonly, copy) NSString* discs;
@property (readonly, copy) NSString* url;

+ (DVD*) dvdWithTitle:(NSString*) title
                price:(NSString*) price
               format:(NSString*) format
                discs:(NSString*) discs
                  url:(NSString*) url;

@end
