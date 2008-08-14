// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "AttributeCell.h"

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
        self.valueLabel.minimumFontSize = 8.0;

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
