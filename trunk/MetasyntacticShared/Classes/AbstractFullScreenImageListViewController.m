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

#import "AbstractFullScreenImageListViewController.h"

#import "AbstractNavigationController.h"
#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "TappableScrollView.h"
#import "ThreadingUtilities.h"

@interface AbstractFullScreenImageListViewController()
@property (retain) NSMutableDictionary* pageNumberToView;
@property (retain) TappableScrollView* scrollView;
@property (retain) UILabel* savingLabel;
@end


@implementation AbstractFullScreenImageListViewController

const double TRANSLUCENCY_LEVEL = 0.9;
const int ACTIVITY_INDICATOR_TAG = -1;
const int LABEL_TAG = -2;
const int IMAGE_TAG = -3;
const double LOAD_DELAY = 1;
const NSInteger PAGE_RANGE = 2;

@synthesize pageNumberToView;
@synthesize scrollView;
@synthesize savingLabel;

- (void) dealloc {
  self.pageNumberToView = nil;
  self.scrollView = nil;
  self.savingLabel = nil;

  [super dealloc];
}


- (id) initWithImageCount:(NSInteger) imageCount_ {
  if ((self = [super init])) {
    imageCount = imageCount_;

    self.wantsFullScreenLayout = YES;

    self.pageNumberToView = [NSMutableDictionary dictionary];
  }

  return self;
}


- (BOOL) allImagesDownloaded {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) imageExistsForPage:(NSInteger) page {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UIImage*) imageForPage:(NSInteger) page {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) allowsSaving {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];

  [self.abstractNavigationController setNavigationBarHidden:YES animated:YES];

  [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
  [self.abstractNavigationController setToolbarHidden:NO animated:YES];
  self.abstractNavigationController.toolbar.barStyle = UIBarStyleBlack;
  self.abstractNavigationController.toolbar.translucent = YES;
}


- (void) onBeforeViewControllerPopped {
  [super onBeforeViewControllerPopped];

  [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
  [self.abstractNavigationController setNavigationBarHidden:NO animated:YES];

  [self.abstractNavigationController setToolbarHidden:YES animated:YES];
}


- (UILabel*) createDownloadingLabel:(NSString*) text; {
  UILabel* downloadingLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  downloadingLabel.tag = LABEL_TAG;
  downloadingLabel.backgroundColor = [UIColor clearColor];
  downloadingLabel.opaque = NO;
  downloadingLabel.text = text;
  downloadingLabel.font = [UIFont boldSystemFontOfSize:24];
  downloadingLabel.textColor = [UIColor whiteColor];
  [downloadingLabel sizeToFit];

  CGRect frame = [UIScreen mainScreen].bounds;
  CGRect labelFrame = downloadingLabel.frame;
  labelFrame.origin.x = (int)((frame.size.width - labelFrame.size.width) / 2.0);
  labelFrame.origin.y = (int)((frame.size.height - labelFrame.size.height) / 2.0);
  downloadingLabel.frame = labelFrame;

  return downloadingLabel;
}


- (UIActivityIndicatorView*) createActivityIndicator:(UILabel*) label {
  UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
  activityIndicator.hidesWhenStopped = YES;
  [activityIndicator sizeToFit];

  CGRect labelFrame = label.frame;
  CGRect activityFrame = activityIndicator.frame;

  activityFrame.origin.x = (int)(labelFrame.origin.x - activityFrame.size.width) - 5;
  activityFrame.origin.y = (int)(labelFrame.origin.y + (labelFrame.size.height / 2) - (activityFrame.size.height / 2));
  activityIndicator.frame = activityFrame;

  [activityIndicator startAnimating];

  return activityIndicator;
}


- (void) createDownloadViews:(UIView*) pageView page:(NSInteger) page {
  NSString* text;
  if ([self imageExistsForPage:page]) {
    text = LocalizedString(@"Loading image", nil);
  } else {
    text = LocalizedString(@"Downloading image", nil);
  }
  UILabel* downloadingLabel = [self createDownloadingLabel:text];
  UIActivityIndicatorView* activityIndicator = [self createActivityIndicator:downloadingLabel];

  CGRect frame = activityIndicator.frame;
  double width = frame.size.width;
  frame.origin.x = (int)(frame.origin.x + width / 2);
  activityIndicator.frame = frame;

  frame = downloadingLabel.frame;
  frame.origin.x = (int)(frame.origin.x + width / 2);
  downloadingLabel.frame = frame;

  [pageView addSubview:activityIndicator];
  [pageView addSubview:downloadingLabel];
}


- (UIImageView*) createImageView:(UIImage*) image {
  UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
  imageView.tag = IMAGE_TAG;
  imageView.contentMode = UIViewContentModeScaleAspectFill;

  CGRect frame = [UIScreen mainScreen].bounds;

  if (image.size.width > image.size.height) {
    int offset = (int)((frame.size.height - frame.size.width) / 2.0);
    CGRect imageFrame = CGRectMake(-offset, offset + 5, frame.size.height, frame.size.width - 10);

    imageView.frame = imageFrame;
    imageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
  } else {
    CGRect imageFrame = CGRectMake(5, 0, frame.size.width - 10, frame.size.height);
    imageView.frame = imageFrame;
    imageView.clipsToBounds = YES;
  }

  return imageView;
}


- (TappableScrollView*) createScrollView {
  CGRect frame = [UIScreen mainScreen].bounds;

  self.scrollView = [[[TappableScrollView alloc] initWithFrame:frame] autorelease];
  scrollView.delegate = self;
  scrollView.tapDelegate = self;
  scrollView.pagingEnabled = YES;
  scrollView.alwaysBounceHorizontal = YES;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.scrollsToTop = NO;
  scrollView.directionalLockEnabled = YES;
  scrollView.autoresizingMask = 0;
  scrollView.backgroundColor = [UIColor blackColor];

  frame.size.width *= imageCount;
  scrollView.contentSize = frame.size;

  return scrollView;
}


- (void) disableActivityIndicator:(UIView*) pageView {
  id view = [pageView viewWithTag:ACTIVITY_INDICATOR_TAG];
  [view stopAnimating];
  [view removeFromSuperview];

  view = [pageView viewWithTag:LABEL_TAG];
  [view removeFromSuperview];
}


- (void) addImage:(UIImage*) image toView:(UIView*) pageView {
  [self disableActivityIndicator:pageView];

  UIImageView* imageView = [self createImageView:image];
  [pageView addSubview:imageView];
  imageView.alpha = 0;

  [UIView beginAnimations:nil context:NULL];
  {
    imageView.alpha = 1;
  }
  [UIView commitAnimations];
}


- (void) addImageToView:(NSArray*) arguments {
  NSNumber* index = [arguments objectAtIndex:0];
  if (index.intValue < (currentPage - PAGE_RANGE) ||
      index.intValue > (currentPage + PAGE_RANGE)) {
    return;
  }

  if (scrollView.dragging || scrollView.decelerating || scrollView.tracking) {
    // should this be 'afterDelay:0'?  That way we do it on the next run
    // loop cycle (which should happen after dragging/decelerating is done).
    // 1/30/09. Right now, i'm going with 'no'.  I'm not totally certain if this
    // won't call back into us immediately, and i don't want to peg the CPU
    // while dragging.  Waiting a sec is safer.
    [self performSelector:@selector(addImageToView:)
               withObject:arguments
               afterDelay:LOAD_DELAY];
    return;
  }

  [self addImage:[arguments objectAtIndex:1]
          toView:[arguments objectAtIndex:2]];
}


- (void) loadPage:(NSInteger) page
            delay:(double) delay {
  if (page < 0 || page >= imageCount) {
    return;
  }

  NSNumber* pageNumber = [NSNumber numberWithInt:page];
  if ([pageNumberToView objectForKey:pageNumber] != nil) {
    return;
  }

  CGRect frame = [UIScreen mainScreen].bounds;
  frame.origin.x = page * frame.size.width;

  UIView* pageView = [[[UIView alloc] initWithFrame:frame] autorelease];
  pageView.backgroundColor = [UIColor blackColor];
  pageView.tag = page;
  pageView.clipsToBounds = YES;

  UIImage* image = nil;
  if (delay == 0) {
    image = [self imageForPage:page];
  }

  if (image != nil) {
    [self addImage:image toView:pageView];
  } else {
    [self createDownloadViews:pageView page:page];
    NSArray* indexAndPageView = [NSArray arrayWithObjects:[NSNumber numberWithInt:page], pageView, nil];
    [self performSelector:@selector(loadPoster:)
               withObject:indexAndPageView
               afterDelay:delay];
  }

  [scrollView addSubview:pageView];
  [pageNumberToView setObject:pageView forKey:pageNumber];
}


- (void) loadPoster:(NSArray*) indexAndPageView {
  if (shutdown) {
    return;
  }

  NSNumber* index = [indexAndPageView objectAtIndex:0];

  if (index.intValue < (currentPage - PAGE_RANGE) ||
      index.intValue > (currentPage + PAGE_RANGE)) {
    return;
  }

  if (scrollView.dragging || scrollView.decelerating || scrollView.tracking) {
    [self performSelector:@selector(loadPoster:) withObject:indexAndPageView afterDelay:1];
    return;
  }

  UIImage* image = [self imageForPage:index.intValue];
  if (image == nil) {
    [self performSelector:@selector(loadPoster:)
               withObject:indexAndPageView
               afterDelay:LOAD_DELAY];
  } else {
    UIView* pageView = [indexAndPageView objectAtIndex:1];
    NSArray* arguments = [NSArray arrayWithObjects:index, image, pageView, nil];
    [self addImageToView:arguments];
  }
}


- (void) setupSavingToolbar {
  self.savingLabel = [[[UILabel alloc] init] autorelease];
  savingLabel.font = [UIFont boldSystemFontOfSize:20];
  savingLabel.textColor = [UIColor whiteColor];
  savingLabel.backgroundColor = [UIColor clearColor];
  savingLabel.opaque = NO;
  savingLabel.shadowColor = [UIColor darkGrayColor];
  savingLabel.text = LocalizedString(@"Saving", nil);
  [savingLabel sizeToFit];

  NSMutableArray* items = [NSMutableArray array];

  [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
  [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:savingLabel] autorelease]];

  UIActivityIndicatorView* savingActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  [savingActivityIndicator startAnimating];

  [items addObject:[[[UIBarButtonItem alloc] initWithCustomView:savingActivityIndicator] autorelease]];
  [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

  [self setToolbarItems:items animated:YES];
}


- (void) updateSavingToolbar:(NSString*) text {
  savingLabel.text = text;
  [savingLabel sizeToFit];
}


- (UIBarButtonItem*) createFlexibleSpace {
  return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}


- (void) setupNormalToolbar {
  NSString* title =
  [NSString stringWithFormat:
   LocalizedString(@"%d of %d", @"i.e.: 5 of 15.  Used when scrolling through a list of items"), (currentPage + 1), imageCount];

  UILabel* label = [[[UILabel alloc] init] autorelease];
  label.text = title;
  label.font = [UIFont boldSystemFontOfSize:20];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  label.opaque = NO;
  label.shadowColor = [UIColor darkGrayColor];
  [label sizeToFit];

  NSMutableArray* items = [NSMutableArray array];

  if (self.allowsSaving) {
    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onActionTapped:)] autorelease]];
  } else {
    [items addObject:self.createFlexibleSpace];
  }

  [items addObject:self.createFlexibleSpace];
  [items addObject:self.createFlexibleSpace];

  UIBarButtonItem* leftArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages leftArrow]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onLeftTapped:)] autorelease];
  [items addObject:leftArrow];

  [items addObject:self.createFlexibleSpace];

  UIBarItem* titleItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease];
  [items addObject:titleItem];

  [items addObject:self.createFlexibleSpace];

  UIBarButtonItem* rightArrow = [[[UIBarButtonItem alloc] initWithImage:[MetasyntacticStockImages rightArrow]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onRightTapped:)] autorelease];
  [items addObject:rightArrow];

  [items addObject:self.createFlexibleSpace];

  UIBarButtonItem* doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTapped:)] autorelease];
  [items addObject:doneItem];

  [self setToolbarItems:items animated:YES];

  if (currentPage <= 0) {
    leftArrow.enabled = NO;
  }

  if (currentPage >= (imageCount - 1)) {
    rightArrow.enabled = NO;
  }
}


- (void) setupToolbar {
  if (saving) {
    return;
  }
  [self setupNormalToolbar];
}


- (void) clearAndLoadPages {
  for (NSNumber* pageNumber in pageNumberToView.allKeys) {
    if (pageNumber.intValue < (currentPage - PAGE_RANGE) || pageNumber.intValue > (currentPage + PAGE_RANGE)) {
      UIView* pageView = [pageNumberToView objectForKey:pageNumber];
      [self disableActivityIndicator:pageView];

      [pageView removeFromSuperview];
      [pageNumberToView removeObjectForKey:pageNumber];
    }
  }

  for (NSInteger i = currentPage - PAGE_RANGE; i <= currentPage + PAGE_RANGE; i++) {
    [self loadPage:i delay:LOAD_DELAY];
  }
}


- (void) setPage:(NSInteger) page {
  if (page != currentPage) {
    currentPage = page;

    [self setupToolbar];
    [self clearAndLoadPages];
  }
}


- (void) hideToolBar {
  if (saving) {
    return;
  }

  [self.abstractNavigationController setToolbarHidden:YES animated:YES];
}


- (void) showToolBar {
  [self.abstractNavigationController setToolbarHidden:NO animated:YES];
}


- (void) onRightTapped:(id) sender {
  CGRect rect = [UIScreen mainScreen].bounds;
  rect.origin.x = (currentPage + 1) * rect.size.width;
  [scrollView scrollRectToVisible:rect animated:YES];
  [self setPage:currentPage + 1];
  [self showToolBar];
}


- (void) onLeftTapped:(id) sender {
  CGRect rect = [UIScreen mainScreen].bounds;
  rect.origin.x = (currentPage - 1) * rect.size.width;
  [scrollView scrollRectToVisible:rect animated:YES];
  [self setPage:currentPage - 1];
  [self showToolBar];
}


- (void) onActionTapped:(id) sender {
  UIActionSheet* actionSheet;
  if (imageCount > 1 && self.allImagesDownloaded) {
    actionSheet =
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:LocalizedString(@"Cancel", nil)
                   destructiveButtonTitle:nil
                        otherButtonTitles:LocalizedString(@"Save to Photo Library", @"Button to let the user save a poster to their photo library"),
      LocalizedString(@"Save All to Photo Library", @"Button to let the user save all the images to their photo library"), nil] autorelease];
  } else {
    actionSheet =
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:LocalizedString(@"Cancel", nil)
                   destructiveButtonTitle:nil
                        otherButtonTitles:LocalizedString(@"Save to Photo Library", nil), nil] autorelease];
  }

  [actionSheet showFromToolbar:self.navigationController.toolbar];
}


- (void) reportSingleSave:(NSNumber*) number {
  NSString* text = [NSString stringWithFormat:LocalizedString(@"Saving %d of %d", @"i.e.: Saving 5 of 15.  Used when saving a list of images"), number.integerValue + 1, imageCount];
  [self updateSavingToolbar:text];
}


- (void) saveImage:(NSInteger) index
         nextIndex:(NSInteger) nextIndex {
  UIImage* image = [self imageForPage:index];
  if (image == nil) {
    [self performSelectorOnMainThread:@selector(onSavingComplete) withObject:nil waitUntilDone:NO];
  } else {
    if (nextIndex != -1) {
      [self performSelectorOnMainThread:@selector(reportSingleSave:) withObject:[NSNumber numberWithInteger:index] waitUntilDone:NO];
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (void*)nextIndex);
  }
}


- (void)                 image:(UIImage*) image
      didFinishSavingWithError:(NSError*) error
                   contextInfo:(void*) contextInfo {
  NSInteger nextIndex = (NSInteger)contextInfo;
  [ThreadingUtilities backgroundSelector:@selector(saveMultipleImages:)
                                onTarget:self
                              withObject:[NSNumber numberWithInteger:nextIndex]
                                    gate:nil
                                  daemon:NO];
}


- (void) onSavingComplete {
  saving = NO;
  [self setupToolbar];
}


- (void) saveMultipleImages:(NSNumber*) startNumber {
  NSInteger startIndex = startNumber.integerValue;
  [self saveImage:startIndex nextIndex:startIndex + 1];
}


- (void) saveSingleImage:(NSNumber*) number {
  [self saveImage:number.integerValue nextIndex:-1];
}


- (void) actionSheet:(UIActionSheet*) actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }

  if (saving) {
    return;
  }
  saving = YES;

  [self setupSavingToolbar];

  if (buttonIndex == 0) {
    [ThreadingUtilities backgroundSelector:@selector(saveSingleImage:)
                                  onTarget:self
                                withObject:[NSNumber numberWithInteger:currentPage]
                                      gate:nil
                                    daemon:NO];
  } else {
    [ThreadingUtilities backgroundSelector:@selector(saveMultipleImages:)
                                  onTarget:self
                                withObject:[NSNumber numberWithInteger:0]
                                      gate:nil
                                    daemon:NO];
  }
}


- (void) loadView {
  [super loadView];

  [self createScrollView];

  [self setupToolbar];
  [self showToolBar];

  // load the first two pages.  Try to load the first one immediately.
  [self loadPage:0 delay:0];
  [self loadPage:1 delay:LOAD_DELAY];
  [self loadPage:2 delay:LOAD_DELAY];

  [self.view addSubview:scrollView];
}


- (AbstractNavigationController*) abstractNavigationController {
  return (id)self.navigationController;
}


- (void) dismiss {
  shutdown = YES;
  [self.abstractNavigationController popFullScreenImageList];
}


- (void) onDoneTapped:(id) argument {
  [self dismiss];
}


- (void) scrollView:(TappableScrollView*) scrollView
          wasTapped:(NSInteger) tapCount
            atPoint:(CGPoint) point {
  if (saving) {
    return;
  }

  if (imageCount == 1) {
    // just dismiss us
    [self dismiss];
  } else {
    if (self.abstractNavigationController.toolbarHidden) {
      [self showToolBar];
    } else {
      [self hideToolBar];
    }
  }
}


- (void) scrollViewWillBeginDragging:(UIScrollView*) scrollView {
  [self hideToolBar];
}


- (void) scrollViewDidEndDecelerating:(UIScrollView*) view {
  CGFloat pageWidth = scrollView.frame.size.width;
  NSInteger page = (NSInteger)((scrollView.contentOffset.x + pageWidth / 2) / pageWidth);

  [self setPage:page];
}

@end
