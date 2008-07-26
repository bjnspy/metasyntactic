//
//  AttributeCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AttributeCell.h"
#import "Application.h"
#import "ColorCache.h"

@implementation AttributeCell

@synthesize keyLabel;
@synthesize valueLabel;

- (void) dealloc {
    self.keyLabel = nil;
    self.valueLabel = nil;
    
    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.keyLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        
        self.keyLabel.textColor = [ColorCache commandColor];
        self.keyLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.keyLabel.textAlignment = UITextAlignmentRight;
        
        self.valueLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.valueLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:keyLabel];
        [self addSubview:valueLabel];
    }
    return self;
}

- (void) setKey:(NSString*) key
          value:(NSString*) value
   hasIndicator:(BOOL) hasIndicator {
    [self setKey:key value:value hasIndicator:hasIndicator keyWidth:70];
}

- (void) setKey:(NSString*) key
          value:(NSString*) value
   hasIndicator:(BOOL) hasIndicator
       keyWidth:(CGFloat) keyWidth {
    self.keyLabel.text = key;
    self.valueLabel.text = value;
    
    {
        [self.keyLabel sizeToFit];
        CGRect frame = self.keyLabel.frame;
        
        frame.origin.x = keyWidth - frame.size.width;
        frame.origin.y = 14;
        
        self.keyLabel.frame = frame;
    }
    
    {
        [self.valueLabel sizeToFit];
        CGRect frame = self.valueLabel.frame;
        
        frame.origin.x = keyWidth + 10;
        frame.origin.y = 13;
        frame.size.width = 320 - frame.origin.x - 15 - (hasIndicator ? 15 : 0);
        
        self.valueLabel.frame = frame;
    }
}

- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.keyLabel.textColor = [UIColor whiteColor];
        self.valueLabel.textColor = [UIColor whiteColor];
    } else {
        self.keyLabel.textColor = [ColorCache commandColor];
        self.valueLabel.textColor = [UIColor blackColor];
    }
}

@end
