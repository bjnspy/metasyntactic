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

#import "MovieOverviewCell.h"

#import "BoxOfficeModel.h"
#import "FontCache.h"

@implementation MovieOverviewCell

@synthesize movie;
@synthesize model;
@synthesize posterImage;
@synthesize synopsis;
@synthesize synopsisSplit;
@synthesize synopsisMax;
@synthesize synopsisChunk1Label;
@synthesize synopsisChunk2Label;

- (void) dealloc {
    self.movie = nil;
    self.model = nil;
    self.posterImage = nil;
    self.synopsis = nil;
    self.synopsisSplit = 0;
    self.synopsisMax = 0;
    self.synopsisChunk1Label = nil;
    self.synopsisChunk2Label = nil;

    [super dealloc];
}


- (id) initWithMovie:(Movie*) movie_ model:(BoxOfficeModel*) model_ frame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.movie = movie_;
        self.model = model_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.posterImage = [self.model posterForMovie:self.movie];
        if (self.posterImage == nil) {
            self.posterImage = [UIImage imageNamed:@"ImageNotAvailable.png"];
        }

        UIImageView* imageView = [[[UIImageView alloc] initWithImage:self.posterImage] autorelease];
        imageView.frame = CGRectMake(5, 5, posterImage.size.width, posterImage.size.height);

        self.synopsisChunk1Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.synopsisChunk2Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

        synopsisChunk1Label.font = [FontCache helvetica14];
        synopsisChunk1Label.lineBreakMode = UILineBreakModeWordWrap;
        synopsisChunk1Label.numberOfLines = 0;

        synopsisChunk2Label.font = [FontCache helvetica14];
        synopsisChunk2Label.lineBreakMode = UILineBreakModeWordWrap;
        synopsisChunk2Label.numberOfLines = 0;

        [self.contentView addSubview:imageView];
        [self.contentView addSubview:synopsisChunk1Label];
        [self.contentView addSubview:synopsisChunk2Label];
    }

    return self;
}


- (NSInteger) calculateSynopsisSplit:(double) cellWidth {
    CGFloat posterHeight = self.posterImage.size.height;
    int chunk1X = 5 + self.posterImage.size.width + 5;
    int chunk1Width = cellWidth - 5 - chunk1X;

    CGFloat chunk1Height = [synopsis sizeWithFont:[FontCache helvetica14]
                                  constrainedToSize:CGSizeMake(chunk1Width, 2000)
                                      lineBreakMode:UILineBreakModeWordWrap].height;
    if (chunk1Height <= posterHeight) {
        return synopsis.length;
    }

    NSInteger guess = synopsis.length * posterHeight * 1.1 / chunk1Height;
    guess = MIN(guess, synopsis.length);

    while (true) {
        NSRange whitespaceRange = [synopsis rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, guess)];
        NSInteger whitespace = whitespaceRange.location;
        if (whitespace == 0) {
            return synopsis.length;
        }

        NSString* synopsisChunk = [synopsis substringToIndex:whitespace];

        CGFloat chunkHeight = [synopsisChunk sizeWithFont:[FontCache helvetica14]
                                        constrainedToSize:CGSizeMake(chunk1Width, 2000)
                                            lineBreakMode:UILineBreakModeWordWrap].height;

        if (chunkHeight <= posterHeight) {
            return whitespace;
        }

        guess = whitespace;
    }
}


- (NSInteger) calculateSynopsisMax {
    // in order to not make the synopsis too long, we trim it a bit.
    // We do this by first figuring out how much can go on the right of the
    // poster (i.e. synopsisSplit), doubling that amount, and then terminating
    // at the first period that follows.
    if (synopsisSplit == synopsis.length) {
        // we didn't even need to split the synopsis.  so there's no need to
        // trim.
        return synopsis.length;
    }

    NSInteger guess = synopsisSplit * 2;
    if (guess >= synopsis.length) {
        // we have enough room to fit the full synopsis in.
        return synopsis.length;
    }

    // This is a long synopsis.  make a reasonable guess as to where we can
    // trim it in order to keep it short.
    NSRange dot = [synopsis rangeOfString:@"." options:0 range:NSMakeRange(guess, synopsis.length - guess)];
    if (dot.length == 0) {
        return synopsis.length;
    }

    return dot.location + 1;
}


- (void) calculateSynopsisChunks:(double) width {
    self.synopsis = [self.model synopsisForMovie:self.movie];
    self.synopsisSplit = [self calculateSynopsisSplit:width];
    self.synopsisMax = [self calculateSynopsisMax];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    [self calculateSynopsisChunks:self.contentView.frame.size.width];

    int chunk1X = 5 + posterImage.size.width + 5;
    int chunk1Width = self.contentView.frame.size.width - 5 - chunk1X;

    CGRect chunk1Frame = CGRectMake(chunk1X, 5, chunk1Width, posterImage.size.height);
    self.synopsisChunk1Label.frame = chunk1Frame;
    self.synopsisChunk1Label.text = [synopsis substringToIndex:synopsisSplit];

    self.synopsisChunk2Label.text = @"";
    if (synopsisSplit < synopsis.length) {
        NSInteger start = synopsisSplit + 1;
        NSInteger end = synopsisMax;

        NSString* synopsisChunk2 = [synopsis substringWithRange:NSMakeRange(start, end - start)];

        CGFloat chunk2Width = self.contentView.frame.size.width - 10;
        CGFloat chunk2Height = [synopsisChunk2 sizeWithFont:[FontCache helvetica14]
                                          constrainedToSize:CGSizeMake(chunk2Width, 2000)
                                              lineBreakMode:UILineBreakModeWordWrap].height;

        CGRect chunk2Frame =  CGRectMake(5, posterImage.size.height + 5, chunk2Width, chunk2Height);
        synopsisChunk2Label.text = synopsisChunk2;
        synopsisChunk2Label.frame = chunk2Frame;

        // shift the first chunk down to align with the second
        [synopsisChunk1Label sizeToFit];
        chunk1Frame = synopsisChunk1Label.frame;
        chunk1Frame.origin.y = self.posterImage.size.height + 5 - chunk1Frame.size.height;
        synopsisChunk1Label.frame = chunk1Frame;
    }
}


+ (MovieOverviewCell*) cellWithMovie:(Movie*) movie
                               model:(BoxOfficeModel*) model
                               frame:(CGRect) frame
                     reuseIdentifier:(NSString*) reuseIdentifier {
    return [[[MovieOverviewCell alloc] initWithMovie:movie model:model frame:frame reuseIdentifier:reuseIdentifier] autorelease];
}


- (CGFloat) height {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    [self calculateSynopsisChunks:width - 20];

    double h1 = self.posterImage.size.height;

    if (synopsisSplit == synopsis.length) {
        return h1 + 10;
    }

    NSInteger start = synopsisSplit + 1;
    NSInteger end = synopsisMax;

    NSString* remainder = [synopsis substringWithRange:NSMakeRange(start, end - start)];

    double h2 = [remainder sizeWithFont:[FontCache helvetica14]
                      constrainedToSize:CGSizeMake(width - 30, 2000)
                          lineBreakMode:UILineBreakModeWordWrap].height;

    return h1 + h2 + 10;
}


+ (CGFloat) heightForMovie:(Movie*) movie model:(BoxOfficeModel*) model {
    MovieOverviewCell* cell = [MovieOverviewCell cellWithMovie:movie model:model frame:[UIScreen mainScreen].applicationFrame reuseIdentifier:nil];
    return [cell height];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self setNeedsLayout];
}


@end
