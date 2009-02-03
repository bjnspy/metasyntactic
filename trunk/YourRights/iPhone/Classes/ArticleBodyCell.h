//
//  ArticleBodyCell.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ArticleBodyCell : UITableViewCell {
@private
    Item* item;
    UILabel* label;
}

- (void) setItem:(Item*) item;

+ (CGFloat) height:(Item*) item;

@end
