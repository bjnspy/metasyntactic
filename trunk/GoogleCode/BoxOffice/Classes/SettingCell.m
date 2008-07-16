//
//  AttributeCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingCell.h"
#import "Application.h"

@implementation SettingCell

@synthesize valueLabel;

- (void) dealloc {
    self.valueLabel = nil;
    
    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.autoresizesSubviews = YES;
        
        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.valueLabel.textColor = [Application commandColor];
        
        [self addSubview:valueLabel];
    }
    return self;
}

- (void) setKey:(NSString*) key
          value:(NSString*) value {
    self.text = key;
    self.valueLabel.text = value;

    [valueLabel sizeToFit];
    CGRect frame = valueLabel.frame;
    frame.origin.x = 320 - 38 - frame.size.width;
    frame.origin.y = 11;
    valueLabel.frame = frame;
}

- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.valueLabel.textColor = [UIColor whiteColor];
    } else {
        self.valueLabel.textColor = [Application commandColor];
    }
}

@end
