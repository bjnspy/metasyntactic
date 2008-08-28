// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MovieShowtimesCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "Performance.h"

@implementation MovieShowtimesCell

@synthesize headerLabel;
@synthesize showtimesLabel;
@synthesize showtimes;
@synthesize useSmallFonts;

- (void) dealloc {
    self.headerLabel = nil;
    self.showtimesLabel = nil;
    self.showtimes = nil;
    self.useSmallFonts = NO;

    [super dealloc];
}


+ (NSString*) showsString {
    return NSLocalizedString(@"Shows", @"This string must be kept small. Preferably 6 characters or less");
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
    UIFont* font = [MovieShowtimesCell showtimesFont:useSmallFonts];

    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    // screen - outer margin - inner margin - space between labels;
    width -= (20 + (8 + 18) + 8);

    NSString* showsString = [MovieShowtimesCell showsString];
    double showsWidth = [showsString sizeWithFont:font].width;
    width -= showsWidth;

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
        self.showtimesLabel.numberOfLines = 0;
        self.showtimesLabel.lineBreakMode = UILineBreakModeWordWrap;

        self.headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.headerLabel.textColor = [ColorCache commandColor];
        self.headerLabel.text = [MovieShowtimesCell showsString];

        [self.contentView addSubview:showtimesLabel];
        [self.contentView addSubview:headerLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect headerFrame = headerLabel.frame;
    headerFrame.origin.x = 8;
    headerFrame.origin.y = 9;
    self.headerLabel.frame = headerFrame;

    CGRect showtimesFrame = showtimesLabel.frame;
    showtimesFrame.origin.x = headerFrame.origin.x + headerFrame.size.width + 8;
    showtimesFrame.origin.y = headerFrame.origin.y;

    double width = self.frame.size.width;
    width -= 20 + (8 + 18) + 8;
    width -= headerFrame.size.width;
    showtimesFrame.size.width = width;
    showtimesFrame.size.height = [MovieShowtimesCell heightForShowtimes:showtimes useSmallFonts:useSmallFonts];
    self.showtimesLabel.frame = showtimesFrame;
}


- (void) setShowtimes:(NSArray*) showtimes_
        useSmallFonts:(BOOL) useSmallFonts_ {
    self.showtimes = showtimes_;
    self.useSmallFonts = useSmallFonts_;

    self.showtimesLabel.font = [MovieShowtimesCell showtimesFont:useSmallFonts];
    self.headerLabel.font = [MovieShowtimesCell showtimesFont:useSmallFonts];

    [self.headerLabel sizeToFit];

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
