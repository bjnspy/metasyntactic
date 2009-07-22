//
//  BoxOfficeSharedApplication.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface BoxOfficeSharedApplication : NSObject {

}

+ (void) setSharedApplicationDelegate:(id<BoxOfficeSharedApplicationDelegate>) delegate;

+ (void) resetTabs;

+ (BOOL) largePosterCacheAlwaysEnabled;
+ (BOOL) netflixCacheAlwaysEnabled;

@end
