//
//  SwitchCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()
@property (retain) UISwitch* switch_;
@end


@implementation SwitchCell

@synthesize switch_;

- (void) dealloc {
    self.switch_ = nil;
    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.switch_ = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        self.accessoryView = switch_;
    }
    
    return self;
}

@end
