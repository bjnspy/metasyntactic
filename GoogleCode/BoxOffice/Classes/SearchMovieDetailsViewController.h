//
//  SearchMovieDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchDetailsViewController.h"
#import "XmlElement.h"

@interface SearchMovieDetailsViewController : SearchDetailsViewController {
    XmlElement* movieElement;
    XmlElement* movieDetailsElement;
}

@property (retain) XmlElement* movieElement;
@property (retain) XmlElement* movieDetailsElement;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController
                       movieDetails:(XmlElement*) movieElement;

@end
