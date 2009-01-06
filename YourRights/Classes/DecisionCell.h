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
    
    UILabel* yearLabel;
    UILabel* titleLabel;
    UILabel* synopsisLabel;
    UILabel* categoryLabel;
}

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier;

+ (CGFloat) height:(Decision*) decision; 

- (void) setDecision:(Decision*) decision owner:(id) owner;

@end
