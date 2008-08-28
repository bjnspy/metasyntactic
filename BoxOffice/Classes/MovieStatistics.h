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

@interface MovieStatistics : NSObject {
    NSString* canonicalTitle;
    NSInteger weekendGross;
    double change;
    NSInteger theaters;
    NSInteger totalGross;
    NSInteger days;
}

@property (copy) NSString* canonicalTitle;
@property NSInteger weekendGross;
@property double change;
@property NSInteger theaters;
@property NSInteger totalGross;
@property NSInteger days;

+ (MovieStatistics*) statisticsWithDictionary:(NSDictionary*) dictionary;
+ (MovieStatistics*) statisticsWithTitle:(NSString*) title
                            weekendGross:(NSInteger) weekendGross
                                  change:(double) change
                                theaters:(NSInteger) theaters
                              totalGross:(NSInteger) totalGross
                                    days:(NSInteger) days;

- (NSDictionary*) dictionary;


@end