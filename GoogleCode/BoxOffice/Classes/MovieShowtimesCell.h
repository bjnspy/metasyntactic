//
//  MovieShowtimesCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface MovieShowtimesCell : UITableViewCell {
    UILabel* label;
}

@property (retain) UILabel* label;

- (void) setShowtimes:(NSArray*) showtimes;

+ (NSString*) showtimesString:(NSArray*) showtimes;
+ (CGFloat) heightForShowtimes:(NSArray*) showtimes;

@end
