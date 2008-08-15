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

#import "MovieStatistics.h"

#import "Movie.h"

@implementation MovieStatistics

@synthesize canonicalTitle;
@synthesize weekendGross;
@synthesize change;
@synthesize theaters;
@synthesize totalGross;
@synthesize days;

- (void) dealloc {
    self.canonicalTitle = nil;
    self.weekendGross = 0;
    self.change = 0;
    self.theaters = 0;
    self.totalGross = 0;
    self.days = 0;
    
    [super dealloc];
}


- (id) initWithTitle:(NSString*) title_
        weekendGross:(NSInteger) weekendGross_
              change:(double) change_
            theaters:(NSInteger) theaters_
          totalGross:(NSInteger) totalGross_
                days:(NSInteger) days_ {
    if (self = [super init]) {
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.weekendGross = weekendGross_;
        self.change = change_;
        self.theaters = theaters_;
        self.totalGross = totalGross_;
        self.days = days_;
    }
    
    return self;
}


+ (MovieStatistics*) statisticsWithTitle:(NSString*) title
                            weekendGross:(NSInteger) weekendGross
                                  change:(double) change
                                theaters:(NSInteger) theaters
                              totalGross:(NSInteger) totalGross
                                    days:(NSInteger) days {
    return [[[MovieStatistics alloc] initWithTitle:title
                                      weekendGross:weekendGross
                                            change:change
                                          theaters:theaters
                                        totalGross:totalGross
                                              days:days] autorelease];
}


+ (MovieStatistics*) statisticsWithDictionary:(NSDictionary*) dictionary {
    return [MovieStatistics statisticsWithTitle:[dictionary objectForKey:@"title"]
                                   weekendGross:[[dictionary objectForKey:@"weekendGross"] intValue]
                                         change:[[dictionary objectForKey:@"change"] doubleValue]
                                       theaters:[[dictionary objectForKey:@"theaters"] intValue]
                                     totalGross:[[dictionary objectForKey:@"totalGross"] intValue]
                                           days:[[dictionary objectForKey:@"days"] intValue]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:canonicalTitle forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:weekendGross] forKey:@"weekendGross"];
    [dict setObject:[NSNumber numberWithDouble:change] forKey:@"change"];
    [dict setObject:[NSNumber numberWithInt:theaters] forKey:@"theaters"];
    [dict setObject:[NSNumber numberWithInt:totalGross] forKey:@"totalGross"];
    [dict setObject:[NSNumber numberWithInt:days] forKey:@"days"];
    return dict;
}

@end
