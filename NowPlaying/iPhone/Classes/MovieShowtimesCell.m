// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MovieShowtimesCell.h"

#import "FontCache.h"
#import "ImageCache.h"
#import "Performance.h"

@implementation MovieShowtimesCell

@synthesize showtimesLabel;
@synthesize showtimes;
@synthesize useSmallFonts;

- (void) dealloc {
    self.showtimesLabel = nil;
    self.showtimes = nil;
    self.useSmallFonts = NO;

    [super dealloc];
}


+ (NSString*) showtimesString:(NSArray*) showtimes {
    if (showtimes.count == 0) {
        return @"";
    }

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


+ (CGFloat) heightForShowtimes:(NSArray*) showtimes
                         stale:(BOOL) stale
                 useSmallFonts:(BOOL) useSmallFonts {
    NSString* string = [MovieShowtimesCell showtimesString:showtimes];
    UIFont* font = [MovieShowtimesCell showtimesFont:useSmallFonts];

    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    width -= 20; // outer margin

    if (stale) {
        width -= 32; // image
    } else {
        width -= 8; // left inner margin
    }

    width -= 18; // accessory

    return [string sizeWithFont:font
              constrainedToSize:CGSizeMake(width, 2000)
                  lineBreakMode:UILineBreakModeWordWrap].height;
}


- (id)  initWithFrame:(CGRect) frame
      reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        self.showtimesLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        showtimesLabel.numberOfLines = 0;
        showtimesLabel.lineBreakMode = UILineBreakModeWordWrap;

        [self.contentView addSubview:showtimesLabel];
    }

    return self;
}


- (void) setStale:(BOOL) stale {
    if (stale) {
        self.image = [ImageCache warning16x16];
    } else {
        self.image = nil;
    }
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect showtimesFrame = showtimesLabel.frame;
    if (self.image == nil) {
        showtimesFrame.origin.x = 8;
    } else {
        showtimesFrame.origin.x = 32;
    }
    showtimesFrame.origin.y = 9;

    double width = self.frame.size.width;
    width -= 20; // outer margin
    width -= showtimesFrame.origin.x; // image
    width -= 18; // accessory

    showtimesFrame.size.width = width;
    showtimesFrame.size.height = [MovieShowtimesCell heightForShowtimes:showtimes
                                                                  stale:(self.image != nil)
                                                          useSmallFonts:useSmallFonts];

    showtimesLabel.frame = showtimesFrame;
}


- (void) setShowtimes:(NSArray*) showtimes_
        useSmallFonts:(BOOL) useSmallFonts_ {
    self.showtimes = showtimes_;
    self.useSmallFonts = useSmallFonts_;

    showtimesLabel.font = [MovieShowtimesCell showtimesFont:useSmallFonts];
    showtimesLabel.text = [MovieShowtimesCell showtimesString:showtimes];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        showtimesLabel.textColor = [UIColor whiteColor];
    } else {
        showtimesLabel.textColor = [UIColor blackColor];
    }
}


@end