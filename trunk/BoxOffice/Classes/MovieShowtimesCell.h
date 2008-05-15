//
//  MovieShowtimesCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface MovieShowtimesCell : UITableViewCell {
    UILabel* label;
    //NSArray* showtimes;
}

@property (retain) UILabel* label;

- (void) setShowtimes:(NSArray*) showtimes;

//@property (retain) NSArray* showtimes;
//+ (MovieShowtimesCell*) cellWithShowtimes:(NSArray*) showtimes;

@end
