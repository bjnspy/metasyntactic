//
//  RatingsDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxOfficeModel;

@interface RatingsCache : NSObject {
    BoxOfficeModel* model;
    NSDictionary* ratingsAndHash;
}

@property (retain) BoxOfficeModel* model;
@property (retain) NSDictionary* ratingsAndHash;

+ (RatingsCache*) cacheWithModel:(BoxOfficeModel*) model;

- (NSDictionary*) update;
- (NSDictionary*) ratings;

- (void) onRatingsProviderChanged;

@end

/*
 
 
 - (NSDictionary*) supplementaryInformation {
 if (self.supplementaryInformationData == nil) {
 self.supplementaryInformationData = [self loadSupplementaryInformation];
 }
 
 return self.supplementaryInformationData;
 }
*/