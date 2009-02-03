//
//  ArticleTitleCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ArticleTitleCell : UITableViewCell {
@private
    Model* model;
    UILabel* titleLabel;
}

- (id) initWithModel:(Model*) model
               frame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier;

- (void) setItem:(Item*) Item;

@end
