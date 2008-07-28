//
//  MovieShowtimesCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieShowtimesCell.h"
#import "Performance.h"
#import "Application.h"
#import "FontCache.h"
#import "ColorCache.h"

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

+ (CGFloat) heightForShowtimes:(NSArray*) showtimes {
    NSString* string = [MovieShowtimesCell showtimesString:showtimes];

    return [string sizeWithFont:[FontCache boldSystem11]
              constrainedToSize:CGSizeMake(232, 1000)
                  lineBreakMode:UILineBreakModeWordWrap].height;
}

- (id)    initWithFrame:(CGRect) frame
        reuseIdentifier:(NSString*) reuseIdentifier  {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {

        self.showtimesLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];

        self.showtimesLabel.numberOfLines = 0;
        self.showtimesLabel.font = [FontCache boldSystem11];
        self.showtimesLabel.lineBreakMode = UILineBreakModeWordWrap;

        {
            CGRect frame = showtimesLabel.frame;
            frame.origin.x = 59;
            frame.origin.y = 9;
            frame.size.width = 232;
            self.showtimesLabel.frame = frame;
        }

        [self addSubview:showtimesLabel];

        self.headerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.headerLabel.font = [FontCache boldSystem11];
        self.headerLabel.textColor = [ColorCache commandColor];
        self.headerLabel.text = NSLocalizedString(@"Shows", nil);
        [self.headerLabel sizeToFit];

        {
            CGRect frame = headerLabel.frame;
            frame.origin.x = 19;
            frame.origin.y = 9;
            self.headerLabel.frame = frame;
        }

        [self addSubview:headerLabel];
    }

    return self;
}

- (void) setShowtimes:(NSArray*) showtimes {
    showtimesLabel.text = [MovieShowtimesCell showtimesString:showtimes];
    CGRect frame = showtimesLabel.frame;
    frame.size.height = [MovieShowtimesCell heightForShowtimes:showtimes];
    showtimesLabel.frame = frame;
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