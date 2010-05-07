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

static const int MARGIN = 5;

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


+ (UIFont*) synopsisFont {
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    return [FontCache helvetica18];
  } else {
    return [FontCache helvetica14];
  }
}


- (CGSize) calculatePreferredImageSize:(UIImage*) synopsisImage {
  if (synopsisImage == nil) {
    return CGSizeZero;
  }

  CGSize actualSize = synopsisImage.size;
  NSInteger lineHeight = 18;
  NSInteger maxWidth = 140;
  NSInteger maxHeight = 163;
  
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    maxWidth = (maxWidth * 2);
    maxHeight = (maxHeight * 2);
    lineHeight = 22;
  }
  
  if (actualSize.width > maxWidth) {
    actualSize.height *= maxWidth / actualSize.width;
    actualSize.width = maxWidth;
  }
  
  NSInteger adjustedHeight = lineHeight * (MIN(maxHeight, (NSInteger) actualSize.height) / lineHeight);
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

    synopsisChunk1Label.font = [SynopsisCell synopsisFont];
    synopsisChunk1Label.lineBreakMode = UILineBreakModeWordWrap;
    synopsisChunk1Label.numberOfLines = 0;
    //synopsisChunk1Label.backgroundColor = [UIColor redColor];

    synopsisChunk2Label.font = [SynopsisCell synopsisFont];
    synopsisChunk2Label.lineBreakMode = UILineBreakModeWordWrap;
    synopsisChunk2Label.numberOfLines = 0;
    //synopsisChunk2Label.backgroundColor = [UIColor blueColor];

    imageView.frame = CGRectMake(MARGIN, MARGIN, imageSize.width, imageSize.height);

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
  return [text sizeWithFont:[SynopsisCell synopsisFont]
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


- (NSInteger) calculateSynopsisSplit:(CGFloat) contentViewWidth {
  if (synopsis.length == 0) {
    return 0;
  }

  if (imageSize.height == 0) {
    return 0;
  }

  CGFloat chunk1Height = imageSize.height;
  CGFloat chunk1X = MARGIN + imageSize.width + MARGIN;
  CGFloat chunk1Width = contentViewWidth - MARGIN - chunk1X;
  CGSize chunk1Size = CGSizeMake(chunk1Width, chunk1Height);

  CGFloat entireSynopsisHeight = [self computeTextHeight:synopsis
                                                forWidth:chunk1Width];
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
  CGFloat chunkHeight = [self computeTextHeight:synopsisChunk
                                       forWidth:chunk1Width];

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
            forContentViewWidth:(CGFloat) contentViewWidth {
  *synopsisSplit = [self calculateSynopsisSplit:contentViewWidth];
  if (limitLength) {
    *synopsisMax = [self calculateSynopsisMax:*synopsisSplit];
  } else {
    *synopsisMax = synopsis.length;
  }
}

- (void) computeChunk1:(NSString**) chunk1 chunk2:(NSString**) chunk2
                frame1:(CGRect*) frame1 frame2:(CGRect*) frame2 
   forContentViewWidth:(CGFloat) forContentViewWidth {
  
  NSInteger synopsisSplit, synopsisMax;
  [self calculateSynopsisSplit:&synopsisSplit
                   synopsisMax:&synopsisMax
           forContentViewWidth:forContentViewWidth];
  
  NSInteger chunk1X = MARGIN + imageSize.width + MARGIN;
  NSInteger chunk1Width = forContentViewWidth - MARGIN - chunk1X;
  
  CGRect chunk1Frame = CGRectMake(chunk1X, MARGIN, chunk1Width, imageSize.height);
  NSString* chunk1Text = [synopsis substringToIndex:synopsisSplit];
  
  CGRect chunk2Frame = CGRectZero;
  NSString* chunk2Text = @"";
  
  
  if (synopsisSplit < synopsis.length) {
    NSInteger start = synopsisSplit == 0 ? 0 : synopsisSplit + 1;
    NSInteger end = synopsisMax;
    
    chunk2Text = [synopsis substringWithRange:NSMakeRange(start, end - start)];
    
    CGFloat chunk2Width = forContentViewWidth - 2 * MARGIN;
    CGFloat chunk2Height = [chunk2Text sizeWithFont:[SynopsisCell synopsisFont]
                                      constrainedToSize:CGSizeMake(chunk2Width, 2000)
                                          lineBreakMode:UILineBreakModeWordWrap].height;
    
    chunk2Frame =  CGRectMake(MARGIN, imageSize.height + MARGIN, chunk2Width, chunk2Height);
  }
  
  *frame1 = chunk1Frame;
  *frame2 = chunk2Frame;
  *chunk1 = chunk1Text;
  *chunk2 = chunk2Text;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGRect chunk1Frame;
  NSString* chunk1Text;
  CGRect chunk2Frame;
  NSString* chunk2Text;
  
  CGFloat contentViewWidth = self.contentView.frame.size.width;
  
  [self computeChunk1:&chunk1Text chunk2:&chunk2Text
               frame1:&chunk1Frame frame2:&chunk2Frame
  forContentViewWidth:contentViewWidth];
  
  synopsisChunk1Label.frame = chunk1Frame;
  synopsisChunk1Label.text = chunk1Text;
  [synopsisChunk1Label sizeToFit];

  synopsisChunk2Label.text = chunk2Text;
  synopsisChunk2Label.frame = chunk2Frame;
}


- (CGFloat) height {
  CGFloat width;
  if (UIInterfaceOrientationIsLandscape(self.tableViewController.interfaceOrientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }

  CGFloat contentViewWidth = width - 2 * groupedTableViewMargin;
  
  CGRect chunk1Frame;
  NSString* chunk1Text;
  CGRect chunk2Frame;
  NSString* chunk2Text;
  
  [self computeChunk1:&chunk1Text chunk2:&chunk2Text
               frame1:&chunk1Frame frame2:&chunk2Frame
  forContentViewWidth:contentViewWidth];
  
  return chunk2Frame.origin.y + chunk2Frame.size.height + MARGIN;
}

@end
