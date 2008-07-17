//
//  SearchCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchMovie.h"
#import "SearchPerson.h"

@interface SearchCache : NSObject {

}

- (SearchMovie*) getMovie:(NSString*) identifier;
- (SearchPerson*) getPerson:(NSString*) identifier;

- (void) putMovie:(SearchMovie*) movie;
- (void) putPerson:(SearchPerson*) person;

@end
