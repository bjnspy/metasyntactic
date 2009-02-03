// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MovieShowtimesCell.h"

#import "DateUtilities.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Model.h"
#import "Performance.h"

@interface MovieShowtimesCell()
@property (retain) Model* model;
@property (retain) UILabel* showtimesLabel;
@property (retain) NSArray* showtimesData;
@property BOOL useSmallFonts;
@end


@implementation MovieShowtimesCell

@synthesize model;
@synthesize showtimesLabel;
@synthesize showtimesData;
@synthesize useSmallFonts;

- (void) dealloc {
    self.model = nil;
    self.showtimesLabel = nil;
    self.showtimesData = nil;
    self.useSmallFonts = NO;

    [super dealloc];
}


+ (NSString*) showtimesString:(NSArray*) showtimes {
    if (showtimes.count == 0) {
        return @"";
    }

    NSMutableString* text = [NSMutableString stringWithString:[[showtimes objectAtIndex:0] timeString]];

    for (int i = 1; i < showtimes.count; i++) {
        [text appendString:@", "];
        Performance* performance = [showtimes objectAtIndex:i];
        [text appendString:performance.timeString];
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
                         model:(Model*) model {
    NSString* string = [MovieShowtimesCell showtimesString:showtimes];
    UIFont* font = [MovieShowtimesCell showtimesFont:model.useSmallFonts];

    double width;
    if ([model screenRotationEnabled] &&
        UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
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
      reuseIdentifier:(NSString*) reuseIdentifier
                model:(Model*) model_ {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
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
    showtimesFrame.size.height = [MovieShowtimesCell heightForShowtimes:showtimesData
                                                                  stale:(self.image != nil)
                                                                  model:model];

    showtimesLabel.frame = showtimesFrame;
}


- (void) setShowtimes:(NSArray*) showtimes_ {
    self.showtimesData = showtimes_;

    showtimesLabel.font = [MovieShowtimesCell showtimesFont:model.useSmallFonts];
    showtimesLabel.text = [MovieShowtimesCell showtimesString:showtimesData];
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