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

@interface Item : NSObject<NSCopying,NSCoding> {
@private
    NSString* title;
    NSString* link;
    NSString* description;
    NSString* date;
    NSString* author;
}

@property (readonly, copy) NSString* title;
@property (readonly, copy) NSString* link;
@property (readonly, copy) NSString* description;
@property (readonly, copy) NSString* date;
@property (readonly, copy) NSString* author;

+ (Item*) itemWithDictionary:(NSDictionary*) dictionary;
+ (Item*) itemWithTitle:(NSString*) title
                   link:(NSString*) link
            description:(NSString*) description
                   date:(NSString*) date
                 author:(NSString*) author;

- (NSDictionary*) dictionary;

@end
