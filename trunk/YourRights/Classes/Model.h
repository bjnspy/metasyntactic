//
//  Model.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Model : NSObject {

}

+ (NSArray*) sectionTitles;
+ (NSArray*) shortSectionTitles;

+ (NSString*) shortSectionTitleForSectionTitle:(NSString*) sectionTitle;

+ (NSArray*) questionsForSectionTitle:(NSString*) sectionTitle;

@end
