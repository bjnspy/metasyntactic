//
//  DecisionCell.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface DecisionCell : UITableViewCell {
@private
    Decision* decision;
    
    UILabel* titleLabel;
    UILabel* synopsisLabel;
    UILabel* categoryLabel;
}

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier;

+ (CGFloat) height:(Decision*) decision owner:(GreatestHitsViewController*) owner; 
- (void) setDecision:(Decision*) decision owner:(GreatestHitsViewController*) owner;

@end
