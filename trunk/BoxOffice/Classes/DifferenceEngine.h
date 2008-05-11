//
//  DifferenceEngine.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface DifferenceEngine : NSObject {
    NSInteger addCost;
    NSInteger deleteCost;
    NSInteger switchCost;
    NSInteger transposeCost;
    
    NSInteger costTable[128][128];
    
    NSInteger cached_S_length;
    NSInteger cached_T_length;
    
    NSInteger costThreshold;
}

+ (DifferenceEngine*) engine;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold;

- (BOOL) similar:(NSString*) s1
           other:(NSString*) s2;

+ (BOOL) areSimilar:(NSString*) s1
              other:(NSString*) s2;
@end
