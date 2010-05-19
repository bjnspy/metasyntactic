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

@interface Constitution : NSObject {
@private
    NSString* country;
    NSString* preamble;
    NSArray* articles;
    NSArray* amendments;
    NSString* conclusion;
    MultiDictionary* signers;
}

@property (readonly, copy) NSString* country;
@property (readonly, copy) NSString* preamble;
@property (readonly, retain) NSArray* articles;
@property (readonly, retain) NSArray* amendments;
@property (readonly, copy) NSString* conclusion;
@property (readonly, retain) MultiDictionary* signers;

+ (Constitution*) constitutionWithCountry:(NSString*) country
                                 preamble:(NSString*) preamble
                                 articles:(NSArray*) articles
                               amendments:(NSArray*) amendments
                               conclusion:(NSString*) conclusion
                                  signers:(MultiDictionary*) signers;

@end
