//
//  AbstractModel.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface AbstractModel : AbstractCache {
@private
  NSNumber* isInReviewPeriodData;
}

- (BOOL) isInReviewPeriod;
- (void) clearInReviewPeriod;

/* @protected */ 
- (void) synchronize;
- (NSInteger) runCount;

@end
