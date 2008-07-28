//
//  LookupResults.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LookupResult : NSObject {
    NSArray* movies;
    NSArray* theaters;

    // theaterId -> movieId -> [ { showtime, showid } ]
    NSDictionary* performances;
}

@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSDictionary* performances;

+ (LookupResult*) resultWithMovies:(NSArray*) movies
                          theaters:(NSArray*) theaters
                      performances:(NSDictionary*) performances;

@end
