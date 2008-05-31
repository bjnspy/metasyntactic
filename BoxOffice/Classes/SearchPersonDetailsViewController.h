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
#import "BoxOfficeModel.h"

@interface SearchPersonDetailsViewController : SearchDetailsViewController {
    XmlElement* personElement;
    XmlElement* personDetailsElement;
}

@property (retain) XmlElement* personElement;
@property (retain) XmlElement* personDetailsElement;
@property (readonly) NSArray* directedMovies;
@property (readonly) NSArray* wroteMovies;
@property (readonly) NSArray* castMovies;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController
                      personDetails:(XmlElement*) personElement;

@end
