//
//  SearchResult.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmlElement.h"

@interface SearchResult : NSObject {
    XmlElement* element;
    NSInteger searchId;
}

@property (retain) XmlElement* element;
@property NSInteger searchId;

+ (SearchResult*) resultWithElement:(XmlElement*) element searchId:(NSInteger) searchId;

@end
