//
//  Decision.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

typedef enum {
    FreedomOfAssociation,
    FreedomOfThePress,
    FreedomOfExpression,
    EqualityUnderTheLaw,
    RightToFairProcedures,
    RightToPrivacy,
    ChecksAndBalances,
    SeparationOfChurchAndState,
    FreeExerciseOfReligion,
} Category;

@interface Decision : NSObject {
@private
    NSInteger year;
    Category category;
    NSString* title;
    NSString* synopsis;
    NSString* link;
}

@property (readonly) NSInteger year;
@property (readonly) Category category;
@property (readonly, retain) NSString* title;
@property (readonly, retain) NSString* synopsis;
@property (readonly, retain) NSString* link;

+ (Decision*) decisionWithYear:(NSInteger) year
                      category:(Category) category
                         title:(NSString*) title
                      synopsis:(NSString*) synopsis
                          link:(NSString*) link;

+ (NSArray*) greatestHits;

@end
