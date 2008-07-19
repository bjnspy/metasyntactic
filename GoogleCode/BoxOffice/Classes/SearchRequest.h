//
//  SearchRequest.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchRequest : NSObject {
    NSString* text;
    NSInteger searchId;
}

@property (copy) NSString* text;
@property NSInteger searchId;

+ (SearchRequest*) requestWithText:(NSString*) text searchId:(NSInteger) searchId;

@end
