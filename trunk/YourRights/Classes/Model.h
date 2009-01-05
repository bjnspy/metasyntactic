//
//  Model.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Model : NSObject {

}

+ (NSArray*) sectionTitles;
+ (NSArray*) shortSectionTitles;

+ (NSString*) shortSectionTitleForSectionTitle:(NSString*) sectionTitle;

+ (NSString*) preambleForSectionTitle:(NSString*) sectionTitle;
+ (NSArray*) questionsForSectionTitle:(NSString*) sectionTitle;
+ (NSArray*) otherResourcesForSectionTitle:(NSString*) sectionTitle;
+ (NSString*) answerForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle;
+ (NSArray*) linksForSectionTitle:(NSString*) sectionTitle;
+ (NSArray*) linksForQuestion:(NSString*) question withSectionTitle:(NSString*) sectionTitle;

@end
