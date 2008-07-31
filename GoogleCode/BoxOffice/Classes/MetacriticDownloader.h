//
//  MetacriticDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoxOfficeModel.h"

@interface MetacriticDownloader : NSObject {
    BoxOfficeModel* model;
}

@property (retain) BoxOfficeModel* model;

+ (MetacriticDownloader*) downloaderWithModel:(BoxOfficeModel*) model;

- (NSDictionary*) lookupMovieListings:(NSString*) hash;

@end
