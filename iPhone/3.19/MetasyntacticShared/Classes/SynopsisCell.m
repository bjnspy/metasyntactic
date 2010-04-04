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

#import "SynopsisCell.h"

#import "FontCache.h"
#import "MetasyntacticStockImages.h"

@interface SynopsisCell()
@property (copy) NSString* synopsis;
@property BOOL limitLength;
@property (retain) UILabel* synopsisChunk1Label;
@property (retain) UILabel* synopsisChunk2Label;
@end


@implementation SynopsisCell

@synthesize synopsis;
@synthesize limitLength;
@synthesize synopsisChunk1Label;
@synthesize synopsisChunk2Label;

- (void) dealloc {
  self.synopsis = nil;
  self.limitLength = NO;
  self.synopsisChunk1Label = nil;
  self.synopsisChunk2Label = nil;

  [super dealloc];
}


- (CGSize) calculatePreferredImageSize:(UIImage*) synopsisImage {
  if (synopsisImage == nil) {
    return CGSizeZero;
  }

  CGSize actualSize = synopsisImage.size;

  if (actualSize.width > 140) {
    actualSize.height *= 140.0f / actualSize.width;
    actualSize.width = 140;
  }

  NSInteger adjustedHeight = 18 * (MIN(163, (NSInteger) actualSize.height) / 18);
  CGFloat ratio = (CGFloat)adjustedHeight / actualSize.height;

  return CGSizeMake((NSInteger)(actualSize.width * ratio), adjustedHeight);
}


- (id) initWithSynopsis:(NSString*) synopsis_
              imageView:(UIImageView*) imageView
            limitLength:(BOOL) limitLength_
    tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [self initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:nil
              tableViewController:tableViewController_])) {
    self.synopsis = synopsis_;
    self.limitLength = limitLength_;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    imageSize = [self calculatePreferredImageSize:imageView.image];

    if (imageSize.height > 0) {
      UIImage* backgroundImage = [MetasyntacticStockImage(@"SynopsisBackground.png") stretchableImageWithLeftCapWidth:1 topCapHeight:1];
      self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    }

    self.synopsisChunk1Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    self.synopsisChunk2Label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

    synopsisChunk1Label.font = [FontCache helvetica14];
    synopsisChunk1Label.lineBreakMode = UILineBreakModeWordWrap;
    synopsisChunk1Label.numberOfLines = 0;

    synopsisChunk2Label.font = [FontCache helvetica14];
    synopsisChunk2Label.lineBreakMode = UILineBreakModeWordWrap;
    synopsisChunk2Label.numberOfLines = 0;

    imageView.frame = CGRectMake(5, 5, imageSize.width, imageSize.height);

    [self.contentView addSubview:imageView];
    [self.contentView addSubview:synopsisChunk1Label];
    [self.contentView addSubview:synopsisChunk2Label];
  }

  return self;
}


+ (SynopsisCell*) cellWithSynopsis:(NSString*) synopsis
                         imageView:(UIImageView*) imageView
                       limitLength:(BOOL) limitLength
               tableViewController:(UITableViewController*) tableViewController {
  return [[[SynopsisCell alloc] initWithSynopsis:synopsis
                                       imageView:imageView
                                     limitLength:limitLength
                             tableViewController:tableViewController] autorelease];
}


+ (SynopsisCell*) cellWithSynopsis:(NSString*) synopsis
                       limitLength:(BOOL) limitLength
               tableViewController:(UITableViewController*) tableViewController {
  return [self cellWithSynopsis:synopsis
                      imageView:nil
                    limitLength:limitLength
            tableViewController:tableViewController];
}


- (CGFloat) computeTextHeight:(NSString*) text forWidth:(CGFloat) width {
  return [text sizeWithFont:[FontCache helvetica14]
                   constrainedToSize:CGSizeMake(width, 2000)
                       lineBreakMode:UILineBreakModeWordWrap].height;
}


- (NSRange) search:(NSString*) string
           options:(NSStringCompareOptions) options
             range:(NSRange) range {
  NSRange searchRange = [synopsis rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                                  options:options
                                                    range:range];
  if (searchRange.length > 0) {
    return searchRange;
  }
  
  return [synopsis rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]
                                   options:options
                                     range:range];
}


- (NSRange) searchBackward:(NSString*) string
                     range:(NSRange) range {
  return [self search:string
              options:NSBackwardsSearch
                range:range];
}


- (NSRange) searchForward:(NSString*) string
                    range:(NSRange) range {
  return [self search:string
              options:0
                range:range];
}


- (NSInteger) searchBackwardForSplit:(NSInteger) currentSplit
                          chunk1Size:(CGSize) chunk1Size {
  while (YES) {
    NSRange searchRange = [self searchBackward:synopsis
                                         range:NSMakeRange(0, currentSplit)];
    NSInteger whitespaceIndex = searchRange.location;
    if (whitespaceIndex == 0 || searchRange.length == 0) {
      return currentSplit;
    }

    NSString* synopsisChunk = [synopsis substringToIndex:whitespaceIndex];

    CGFloat height = [self computeTextHeight:synopsisChunk forWidth:chunk1Size.width];
    if (height <= chunk1Size.height) {
      return whitespaceIndex;
    }

    currentSplit = whitespaceIndex;
  }
}


- (NSInteger) searchForwardForSplit:(NSInteger) currentSplit
                         chunk1Size:(CGSize) chunk1Size {
  while (YES) {
    NSRange searchRange = [self searchForward:synopsis
                                        range:NSMakeRange(currentSplit + 1, synopsis.length - currentSplit - 1)];
    NSInteger whitespaceIndex = searchRange.location;
    if (whitespaceIndex == 0 || searchRange.length == 0) {
      return currentSplit;
    }

    NSString* synopsisChunk = [synopsis substringToIndex:whitespaceIndex];

    CGFloat height = [self computeTextHeight:synopsisChunk forWidth:chunk1Size.width];
    if (height > chunk1Size.height) {
      return currentSplit;
    }

    currentSplit = whitespaceIndex;
  }
}


- (NSInteger) calculateSynopsisSplit:(float) cellWidth {
  if (synopsis.length == 0) {
    return 0;
  }

  if (imageSize.height == 0) {
    return 0;
  }

  CGFloat chunk1Height = imageSize.height;
  NSInteger chunk1X = 5 + imageSize.width + 5;
  NSInteger chunk1Width = cellWidth - 5 - chunk1X;
  CGSize chunk1Size = CGSizeMake(chunk1Width, chunk1Height);

  CGFloat entireSynopsisHeight = [self computeTextHeight:synopsis forWidth:chunk1Width];
  if (entireSynopsisHeight <= chunk1Height) {
    return synopsis.length;
  }

  NSInteger guess = (NSInteger)((double)synopsis.length * chunk1Height / entireSynopsisHeight);
  guess = MIN(guess, synopsis.length);

  NSRange searchRange = [self searchBackward:synopsis
                                       range:NSMakeRange(0, guess)];
  
  NSInteger currentSplit = searchRange.location;
  if (currentSplit == 0 || searchRange.length == 0) {
    return synopsis.length;
  }

  NSString* synopsisChunk = [synopsis substringToIndex:currentSplit];
  CGFloat chunkHeight = [self computeTextHeight:synopsisChunk forWidth:chunk1Width];

  // Two options.
  // 1) We're too long and we need to trim
  // 2) We're too short and we need to add
  if (chunkHeight > chunk1Height) {
    return [self searchBackwardForSplit:currentSplit chunk1Size:chunk1Size];
  } else {
    return [self searchForwardForSplit:currentSplit chunk1Size:chunk1Size];
  }
}


- (NSInteger) calculateSynopsisMax:(NSInteger) synopsisSplit {
  // in order to not make the synopsis too long, we trim it a bit.
  // We do this by first figuring out how much can go on the right of the
  // poster (i.e. synopsisSplit), tripling that amount, and then terminating
  // at the first period that follows.
  if (synopsisSplit == synopsis.length) {
    // we didn't even need to split the synopsis. so there's no need to
    // trim.
    return synopsis.length;
  }

  if (synopsisSplit == 0) {
    return 0;
  }

  NSInteger guess = synopsisSplit * 3;
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


- (void) calculateSynopsisSplit:(NSInteger*) synopsisSplit
                    synopsisMax:(NSInteger*) synopsisMax
                       forWidth:(float) width {
  *synopsisSplit = [self calculateSynopsisSplit:width];
  if (limitLength) {
    *synopsisMax = [self calculateSynopsisMax:*synopsisSplit];
  } else {
    *synopsisMax = synopsis.length;
  }
}


- (void) layoutSubviews {
  [super layoutSubviews];

  NSInteger synopsisSplit, synopsisMax;
  [self calculateSynopsisSplit:&synopsisSplit
                   synopsisMax:&synopsisMax
                      forWidth:self.contentView.frame.size.width];

  NSInteger chunk1X = 5 + imageSize.width + 5;
  NSInteger chunk1Width = self.contentView.frame.size.width - 5 - chunk1X;

  CGRect chunk1Frame = CGRectMake(chunk1X, 5, chunk1Width, imageSize.height);
  synopsisChunk1Label.frame = chunk1Frame;
  synopsisChunk1Label.text = [synopsis substringToIndex:synopsisSplit];
  [synopsisChunk1Label sizeToFit];

  synopsisChunk2Label.text = @"";
  if (synopsisSplit >= synopsis.length) {
    synopsisChunk2Label.frame = CGRectZero;
  } else {
    NSInteger start = synopsisSplit == 0 ? 0 : synopsisSplit + 1;
    NSInteger end = synopsisMax;

    NSString* synopsisChunk2 = [synopsis substringWithRange:NSMakeRange(start, end - start)];

    CGFloat chunk2Width = self.contentView.frame.size.width - 10;
    CGFloat chunk2Height = [synopsisChunk2 sizeWithFont:[FontCache helvetica14]
                                      constrainedToSize:CGSizeMake(chunk2Width, 2000)
                                          lineBreakMode:UILineBreakModeWordWrap].height;

    CGRect chunk2Frame =  CGRectMake(5, imageSize.height + 5, chunk2Width, chunk2Height);
    synopsisChunk2Label.text = synopsisChunk2;
    synopsisChunk2Label.frame = chunk2Frame;

    // shift the first chunk down to align with the second
#if 0
    chunk1Frame = synopsisChunk1Label.frame;
    chunk1Frame.origin.y = imageSize.height + 5 - chunk1Frame.size.height;
    synopsisChunk1Label.frame = chunk1Frame;
#endif
  }
}


- (CGFloat) height:(UITableViewController*) controller {
  CGFloat width;
  if (UIInterfaceOrientationIsLandscape(controller.interfaceOrientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }

  NSInteger synopsisSplit, synopsisMax;
  [self calculateSynopsisSplit:&synopsisSplit
                   synopsisMax:&synopsisMax 
                      forWidth:width - 2 * groupedTableViewMargin];

  CGFloat h1 = imageSize.height;

  if (synopsisSplit == synopsis.length) {
    return h1 + 10;
  }

  NSInteger start = synopsisSplit == 0 ? 0 : synopsisSplit + 1;
  NSInteger end = synopsisMax;

  NSString* remainder = [synopsis substringWithRange:NSMakeRange(start, end - start)];

  CGFloat h2 =
   [self computeTextHeight:remainder
                  forWidth:width - (2 * groupedTableViewMargin) - 10];

  return h1 + h2 + 10;
}

@end
