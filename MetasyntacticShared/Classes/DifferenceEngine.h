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

@interface DifferenceEngine : NSObject {
@private
  NSInteger addCost;
  NSInteger deleteCost;
  NSInteger switchCost;
  NSInteger transposeCost;

  NSInteger costTable[128][128];

  NSInteger cached_S_length;
  NSInteger cached_T_length;

  NSInteger costThreshold;
}

+ (DifferenceEngine*) engine;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold;

- (BOOL) similar:(NSString*) s1
           other:(NSString*) s2;

+ (BOOL) areSimilar:(NSString*) s1
              other:(NSString*) s2;

+ (BOOL) substringSimilar:(NSString*) s1 other:(NSString*) s2;

- (NSInteger) findClosestMatchIndex:(NSString*) string
                            inArray:(NSArray*) array;
- (NSString*) findClosestMatch:(NSString*) string
                       inArray:(NSArray*) array;

@end
