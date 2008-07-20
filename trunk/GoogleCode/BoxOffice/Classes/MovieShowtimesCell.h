//
//  MovieShowtimesCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

@interface MovieShowtimesCell : UITableViewCell {
    UILabel* headerLabel;
    UILabel* showtimesLabel;
}

@property (retain) UILabel* headerLabel;
@property (retain) UILabel* showtimesLabel;

- (void) setShowtimes:(NSArray*) showtimes;

+ (NSString*) showtimesString:(NSArray*) showtimes;
+ (CGFloat) heightForShowtimes:(NSArray*) showtimes;

@end
