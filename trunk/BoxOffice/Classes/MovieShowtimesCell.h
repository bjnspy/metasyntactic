//
//  MovieShowtimesCell.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MovieShowtimesCell : UITableViewCell {
	NSArray* showtimes;
}

@property (retain) NSArray* showtimes;

+ (MovieShowtimesCell*) cellWithShowtimes:(NSArray*) showtimes;

@end
