//
//  SwitchCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SwitchCell : UITableViewCell {
@private
    UISwitch* switch_;
}

@property (readonly, retain) UISwitch* switch_;

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier;

@end
