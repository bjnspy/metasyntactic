//
//  FandangoTheaterDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FandangoTheaterDownloader : NSObject {

}

+ (NSArray*) download:(NSString*) zipcode
               radius:(NSInteger) radius;

@end
