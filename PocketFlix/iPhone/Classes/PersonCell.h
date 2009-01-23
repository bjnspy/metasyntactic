//
//  PersonCell.h
//  PocketFlix
//
//  Created by Cyrus Najmabadi on 1/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractImageCell.h"

@interface PersonCell : AbstractImageCell {
@private
    Person* person;
    UILabel* bioTitleLabel;
    UILabel* bioLabel;
}

@property (retain) Person* person;

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_;

- (void) setPerson:(Person*) movie owner:(id) owner;

// @protected
- (void) onSetSamePerson:(Person*) movie owner:(id) owner;

@end
