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

#import "MovieShowtimesCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "Performance.h"

@implementation MovieShowtimesCell

@synthesize headerLabel;
@synthesize showtimesLabel;

- (void) dealloc {
    self.headerLabel = nil;
    self.showtimesLabel = nil;

    [super dealloc];
}


+ (NSString*) showtimesString:(NSArray*) showtimes {
    NSMutableString* text = [NSMutableString stringWithString:[[showtimes objectAtIndex:0] time]];

    for (int i = 1; i < showtimes.count; i++) {
        [text appendString:@", "];
        Performance* performance = [showtimes objectAtIndex:i];
        [text appendString:performance.time];
    }

    return text;
}


+ (UIFont*) showtimesFont:(BOOL) useSmallFonts {
    if (useSmallFonts) {
        return [FontCache boldSystem11];
    } else {
        return [UIFont boldSystemFontOfSize:16];
    }
}


+ (CGFloat) heightForShowtimes:(NSArray*) showtimes useSmallFonts:(BOOL) useSmallFonts {
    NSString* string = [MovieShowtimesCell showtimesString:showtimes];

    return [string sizeWithFont:[MovieShowtimesCell showtimesFont:useSmallFonts]
              constrainedToSize:CGSizeMake(232, 1000)
                  lineBreakMode:UILineBreakModeWordWrap].height;
}


- (id)    initWithFrame:(CGRect) frame
        reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {
        self.showtimesLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.showtimesLabel.numberOfLines = 0;
        self.showtimesLabel.lineBreakMode = UILineBreakModeWordWrap;

        self.headerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.headerLabel.textColor = [ColorCache commandColor];
        self.headerLabel.text = NSLocalizedString(@"Shows", nil);

        [self addSubview:showtimesLabel];
        [self addSubview:headerLabel];
    }

    return self;
}


- (void) setShowtimes:(NSArray*) showtimes useSmallFonts:(BOOL) useSmallFonts {
    self.showtimesLabel.font = [MovieShowtimesCell showtimesFont:useSmallFonts];
    self.headerLabel.font = [MovieShowtimesCell showtimesFont:useSmallFonts];
    [self.headerLabel sizeToFit];

    {
        CGRect frame = headerLabel.frame;
        frame.origin.x = 19;
        frame.origin.y = 9;
        self.headerLabel.frame = frame;
    }

    {
        CGRect frame;
        frame.origin.y = 9;
        frame.size.height = [MovieShowtimesCell heightForShowtimes:showtimes useSmallFonts:useSmallFonts];

        if (useSmallFonts) {
            frame.origin.x = 59;
            frame.size.width = 232;
        } else {
            frame.origin.x = 79;
            frame.size.width = 212;
        }

        self.showtimesLabel.frame = frame;
    }

    showtimesLabel.text = [MovieShowtimesCell showtimesString:showtimes];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        headerLabel.textColor = [UIColor whiteColor];
        showtimesLabel.textColor = [UIColor whiteColor];
    } else {
        headerLabel.textColor = [ColorCache commandColor];
        showtimesLabel.textColor = [UIColor blackColor];
    }
}


@end
