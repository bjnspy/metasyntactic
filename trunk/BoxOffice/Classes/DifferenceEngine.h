//
//  DifferenceEngine.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Matrix.h"

@interface DifferenceEngine : NSObject {
    NSInteger addCost;
    NSInteger deleteCost;
    NSInteger switchCost;
    NSInteger transposeCost;
    
    Matrix* costTable;
    
    NSString* S;
    NSString* T;
    NSInteger cached_S_length;
    NSInteger cached_T_length;
    
    NSInteger costThreshold;
}

@property (copy) NSString* S;
@property (copy) NSString* T;
@property (retain) Matrix* costTable;

- (void) dealloc;

+ (DifferenceEngine*) engine;

- (id) init;
- (id) initWithAddCost:(NSInteger) addCost
            deleteCost:(NSInteger) deleteCost
            switchCost:(NSInteger) switchCost
         transposeCost:(NSInteger) transposeCost;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to;

- (NSInteger) editDistanceFrom:(NSString*) from
                            to:(NSString*) to
                 withThreshold:(NSInteger) threshold;

@end
