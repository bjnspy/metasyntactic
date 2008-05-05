//
//  RatingsView.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RatingsView : UIView {
    NSInteger rating;
}

- (id) initWithFrame:(CGRect) frame
              rating:(NSInteger) rating;

@end
