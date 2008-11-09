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

#import "MovieOverviewCell.h"

#import "ActivityIndicatorViewWithBackground.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "MovieDetailsViewController.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PosterCache.h"
#import "TappableImageView.h"

@interface MovieOverviewCell()
@property (retain) NowPlayingModel* model;
@property (retain) Movie* movie;
@property (copy) NSString* synopsis;
@property NSInteger synopsisSplit;
@property NSInteger synopsisMax;
@property (retain) UILabel* synopsisChunk1Label;
@property (retain) UILabel* synopsisChunk2Label;
@property (retain) UIImage* posterImage;
@end


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


- (CGSize) posterSize {
    CGSize actualSize = posterImage.size;

    if (actualSize.width > 140) {
        actualSize.height *= 140.0 / actualSize.width;
        actualSize.width = 140;
    }

    CGFloat adjustedHeight = 18 * (MIN(145, (int)actualSize.height) / 18);
    CGFloat ratio = adjustedHeight / actualSize.height;

    return CGSizeMake(actualSize.width * ratio, adjustedHeight);
}


- (id) initWithMovie:(Movie*) movie_
               model:(NowPlayingModel*) model_
               frame:(CGRect) frame
         posterImage:(UIImage*) posterImage_
     posterImageView:(TappableImageView*) posterImageView
        activityView:(ActivityIndicatorViewWithBackground*) activityView {
    if (self = [super initWithFrame:frame reuseIdentifier:nil]) {
        self.movie = movie_;
        self.model = model_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.posterImage = posterImage_;

        self.synopsisChunk1Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.synopsisChunk2Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

        synopsisChunk1Label.font = [FontCache helvetica14];
        synopsisChunk1Label.lineBreakMode = UILineBreakModeWordWrap;
        synopsisChunk1Label.numberOfLines = 0;

        synopsisChunk2Label.font = [FontCache helvetica14];
        synopsisChunk2Label.lineBreakMode = UILineBreakModeWordWrap;
        synopsisChunk2Label.numberOfLines = 0;

        {
            posterImageView.frame = CGRectMake(5, 5, self.posterSize.width, self.posterSize.height);

            CGRect imageFrame = posterImageView.frame;
            CGRect activityFrame = activityView.frame;
            activityFrame.origin.x = imageFrame.origin.x + 2;
            activityFrame.origin.y = imageFrame.origin.y + imageFrame.size.height - activityFrame.size.height - 1;
            activityView.frame = activityFrame;
        }

        [self.contentView addSubview:posterImageView];
        [self.contentView addSubview:activityView];
        [self.contentView addSubview:synopsisChunk1Label];
        [self.contentView addSubview:synopsisChunk2Label];
    }

    return self;
}


- (NSInteger) calculateSynopsisSplit:(double) cellWidth {
    CGFloat posterHeight = self.posterSize.height;
    int chunk1X = 5 + self.posterSize.width + 5;
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
        // we didn't even need to split the synopsis. so there's no need to
        // trim.
        return synopsis.length;
    }

    NSInteger guess = synopsisSplit * 2;
    if (guess >= synopsis.length) {
        // we have enough room to fit the full synopsis in.
        return synopsis.length;
    }

    // This is a long synopsis. make a reasonable guess as to where we can
    // trim it in order to keep it short.
    NSRange dot = [synopsis rangeOfString:@"." options:0 range:NSMakeRange(guess, synopsis.length - guess)];
    if (dot.length == 0) {
        return synopsis.length;
    }

    return dot.location + 1;
}


- (void) calculateSynopsisChunks:(double) width {
    self.synopsis = [model synopsisForMovie:movie];
    self.synopsisSplit = [self calculateSynopsisSplit:width];
    self.synopsisMax = [self calculateSynopsisMax];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    [self calculateSynopsisChunks:self.contentView.frame.size.width];

    int chunk1X = 5 + self.posterSize.width + 5;
    int chunk1Width = self.contentView.frame.size.width - 5 - chunk1X;

    CGRect chunk1Frame = CGRectMake(chunk1X, 5, chunk1Width, self.posterSize.height);
    synopsisChunk1Label.frame = chunk1Frame;
    synopsisChunk1Label.text = [synopsis substringToIndex:synopsisSplit];
    [synopsisChunk1Label sizeToFit];

    synopsisChunk2Label.text = @"";
    if (synopsisSplit < synopsis.length) {
        NSInteger start = synopsisSplit + 1;
        NSInteger end = synopsisMax;

        NSString* synopsisChunk2 = [synopsis substringWithRange:NSMakeRange(start, end - start)];

        CGFloat chunk2Width = self.contentView.frame.size.width - 10;
        CGFloat chunk2Height = [synopsisChunk2 sizeWithFont:[FontCache helvetica14]
                                          constrainedToSize:CGSizeMake(chunk2Width, 2000)
                                              lineBreakMode:UILineBreakModeWordWrap].height;

        CGRect chunk2Frame =  CGRectMake(5, self.posterSize.height + 5, chunk2Width, chunk2Height);
        synopsisChunk2Label.text = synopsisChunk2;
        synopsisChunk2Label.frame = chunk2Frame;

        // shift the first chunk down to align with the second
        chunk1Frame = synopsisChunk1Label.frame;
        chunk1Frame.origin.y = self.posterSize.height + 5 - chunk1Frame.size.height;
        synopsisChunk1Label.frame = chunk1Frame;
    }
}


+ (MovieOverviewCell*) cellWithMovie:(Movie*) movie
                               model:(NowPlayingModel*) model
                               frame:(CGRect) frame
                         posterImage:(UIImage*) posterImage
                     posterImageView:(TappableImageView*) posterImageView
                        activityView:(ActivityIndicatorViewWithBackground*) activityView {
    return [[[MovieOverviewCell alloc] initWithMovie:movie
                                               model:model
                                               frame:frame
                                         posterImage:posterImage
                                     posterImageView:posterImageView
                                        activityView:activityView] autorelease];
}


- (CGFloat) height {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    [self calculateSynopsisChunks:width - 20];

    double h1 = self.posterSize.height;

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


+ (CGFloat) heightForMovie:(Movie*) movie model:(NowPlayingModel*) model {
    UIImage* posterImage = [MovieDetailsViewController posterForMovie:movie model:model];
    TappableImageView* posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];

    MovieOverviewCell* cell = [MovieOverviewCell cellWithMovie:movie model:model
                                                         frame:[UIScreen mainScreen].applicationFrame
                                                   posterImage:posterImage
                                               posterImageView:posterImageView
                                                  activityView:nil];
    return cell.height;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self setNeedsLayout];
}


@end