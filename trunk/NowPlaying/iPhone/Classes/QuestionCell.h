//
//  QuestionCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface QuestionCell : UITableViewCell {
@private
    BOOL question;
    UILabel* contentLabel;
}

- (id) initWithQuestion:(BOOL) question reuseIdentifier:(NSString*) reuseIdentifier;

+ (CGFloat) height:(BOOL) question text:(NSString*) text;

@end
