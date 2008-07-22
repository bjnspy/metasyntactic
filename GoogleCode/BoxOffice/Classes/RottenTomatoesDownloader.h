//
//  RottenTomatoesDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoxOfficeModel.h"

@interface RottenTomatoesDownloader : NSObject {
    BoxOfficeModel* model;
}

@property (retain) BoxOfficeModel* model;

+ (RottenTomatoesDownloader*) downloaderWithModel:(BoxOfficeModel*) model;

- (NSDictionary*) lookupMovieListings;

@end
