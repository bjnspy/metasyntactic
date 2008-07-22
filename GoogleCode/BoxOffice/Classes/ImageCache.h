//
//  ImageCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageCache : NSObject {

}

+ (UIImage*) freshImage;
+ (UIImage*) rottenFadedImage;
+ (UIImage*) rottenFullImage;
+ (UIImage*) emptyStarImage;
+ (UIImage*) filledStarImage;

+ (UIImage*) redRatingImage;
+ (UIImage*) yellowRatingImage;
+ (UIImage*) greenRatingImage;
+ (UIImage*) unknownRatingImage;

@end
