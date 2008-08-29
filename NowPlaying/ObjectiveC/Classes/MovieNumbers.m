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

#import "MovieNumbers.h"

#import "Movie.h"

@implementation MovieNumbers

@synthesize identifier;
@synthesize canonicalTitle;
@synthesize currentRank;
@synthesize previousRank;
@synthesize currentGross;
@synthesize totalGross;
@synthesize theaters;
@synthesize days;

- (void) dealloc {
    self.identifier = nil;
    self.canonicalTitle = nil;
    self.currentRank = 0;
    self.previousRank = 0;
    self.currentGross = 0;
    self.totalGross = 0;
    self.theaters = 0;
    self.days = 0;
    
    [super dealloc];
}


- (id) initWithIdentifier:(NSString*) identifier_
                    title:(NSString*) title_
              currentRank:(NSInteger) currentRank_
             previousRank:(NSInteger) previousRank_
             currentGross:(NSInteger) currentGross_
               totalGross:(NSInteger) totalGross_
                 theaters:(NSInteger) theaters_
                     days:(NSInteger) days_ {
    if (self = [super init]) {
        self.identifier = identifier_;
        self.canonicalTitle = [Movie makeCanonical:title_];
        self.currentRank = currentRank_;
        self.previousRank = previousRank_;
        self.currentGross = currentGross_;
        self.totalGross = totalGross_;
        self.theaters = theaters_;
        self.days = days_;
    }
    
    return self;
}


+ (MovieNumbers*) numbersWithIdentifier:(NSString*) identifier
                                  title:(NSString*) title
                            currentRank:(NSInteger) currentRank
                           previousRank:(NSInteger) previousRank
                           currentGross:(NSInteger) currentGross
                             totalGross:(NSInteger) totalGross
                               theaters:(NSInteger) theaters
                                   days:(NSInteger) days {
    return [[[MovieNumbers alloc] initWithIdentifier:identifier
                                               title:title
                                         currentRank:currentRank
                                        previousRank:previousRank
                                        currentGross:currentGross
                                          totalGross:totalGross
                                            theaters:theaters
                                                days:days] autorelease];
}


+ (MovieNumbers*) numbersWithDictionary:(NSDictionary*) dictionary {
    return [MovieNumbers numbersWithIdentifier:[dictionary objectForKey:@"identifier"]
                                         title:[dictionary objectForKey:@"title"]
                                   currentRank:[[dictionary objectForKey:@"currentRank"] intValue]
                                  previousRank:[[dictionary objectForKey:@"previousRank"] intValue]
                                  currentGross:[[dictionary objectForKey:@"currentGross"] intValue]
                                    totalGross:[[dictionary objectForKey:@"totalGross"] intValue]
                                      theaters:[[dictionary objectForKey:@"theaters"] intValue]
                                          days:[[dictionary objectForKey:@"days"] intValue]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:identifier forKey:@"identifier"];
    [dict setObject:canonicalTitle forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:currentRank] forKey:@"currentRank"];
    [dict setObject:[NSNumber numberWithInt:previousRank] forKey:@"previousRank"];
    [dict setObject:[NSNumber numberWithInt:currentGross] forKey:@"currentGross"];
    [dict setObject:[NSNumber numberWithInt:totalGross] forKey:@"totalGross"];
    [dict setObject:[NSNumber numberWithInt:theaters] forKey:@"theaters"];
    [dict setObject:[NSNumber numberWithInt:days] forKey:@"days"];
    return dict;
}

@end