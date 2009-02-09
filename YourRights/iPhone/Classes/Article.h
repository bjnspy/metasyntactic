//
//  Article.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Article : NSObject {
@private
    NSString* title;
    NSArray* sections;
}

@property (readonly, copy) NSString* title;
@property (readonly, retain) NSArray* sections;

+ (Article*) articleWithTitle:(NSString*) title
                     sections:(NSArray*) sections;

@end
